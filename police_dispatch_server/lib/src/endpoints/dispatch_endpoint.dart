import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../utils/haversine_calculator.dart';
import '../utils/coverage_checker.dart';
import '../utils/municipal_coverage_planner.dart';

/// Handles all dispatch operations and real-time vehicle monitoring.
///
/// This endpoint is the core of the system — it implements the intelligent
/// dispatch algorithm that ensures no sector is left uncovered while
/// responding to incidents as quickly as possible.
class DispatchEndpoint extends Endpoint {
  // ─── Real-time monitoring stream ────────────────────────────────────────────

  /// Opens a persistent stream connection for the dashboard to monitor
  /// all vehicle positions and statuses in real time.
  ///
  /// The stream yields a fresh vehicle list:
  ///   - immediately upon connection (initial state)
  ///   - whenever any vehicle update is broadcast on the 'map-update' channel
  ///
  /// Flutter usage:
  /// ```dart
  /// final stream = client.dispatch.monitorVehicles();
  /// ```
  Stream<List<Vehicle>> monitorVehicles(Session session) async* {
    // Create a named channel — all vehicle updates are broadcast here
    final channel = session.messages.createStream<MapUpdateMessage>(
      'map-update',
    );

    // Send the current fleet state immediately on connect
    yield await Vehicle.db.find(session);

    // Re-fetch and yield the full state on every broadcast notification
    await for (final _ in channel) {
      yield await Vehicle.db.find(session);
    }
  }

  /// Streams sector coverage data (sectorCode → availableVehicleCount).
  /// The dashboard uses this to colour-code sector polygons on the map.
  Stream<Map<String, int>> monitorSectorCoverage(Session session) async* {
    final channel = session.messages.createStream<MapUpdateMessage>(
      'map-update',
    );

    yield await CoverageChecker.sectorCoverageMap(session);

    await for (final _ in channel) {
      yield await CoverageChecker.sectorCoverageMap(session);
    }
  }

  // ─── Incident dispatch ───────────────────────────────────────────────────────

  /// Dispatches the unit whose removal causes the smallest geographic coverage
  /// loss, then repositions the remaining fleet over the municipality.
  ///
  /// Returns a [DispatchResult] with success status and ETA.
  Future<DispatchResult> requestDispatch(
    Session session,
    Incident incident,
  ) async {
    final available = await Vehicle.db.find(
      session,
      where: (v) =>
          v.status.equals('available') | v.status.equals('repositioning'),
    );

    if (available.isEmpty) {
      return DispatchResult(
        success: false,
        message: 'No vehicles currently available. All units are dispatched.',
        assignedVehicleCode: null,
        estimatedArrivalSeconds: null,
      );
    }

    final boundary = await MunicipalCoveragePlanner.readBoundaryGeoJson();
    final coverageSamples = MunicipalCoveragePlanner.sampleMunicipality(
      boundary,
    );

    double distanceToIncident(Vehicle vehicle) =>
        HaversineCalculator.distanceKm(
          incident.latitude,
          incident.longitude,
          vehicle.latitude,
          vehicle.longitude,
        );

    final coverageAfterDispatch = <String, double>{};
    for (final candidate in available) {
      final remainingPositions = available
          .where((vehicle) => vehicle.id != candidate.id)
          .map(
            (vehicle) =>
                (latitude: vehicle.latitude, longitude: vehicle.longitude),
          )
          .toList();
      coverageAfterDispatch[candidate.code] =
          MunicipalCoveragePlanner.maximumCoverageDistanceKm(
            coverageSamples,
            remainingPositions,
          );
    }

    available.sort((a, b) {
      final coverageComparison = coverageAfterDispatch[a.code]!.compareTo(
        coverageAfterDispatch[b.code]!,
      );
      if (coverageComparison != 0) return coverageComparison;
      return distanceToIncident(a).compareTo(distanceToIncident(b));
    });
    final vehicleToDispatch = available.first;

    // ── Commit the dispatch ───────────────────────────────────────────────────
    vehicleToDispatch
      ..status = 'dispatched'
      ..targetLatitude = incident.latitude
      ..targetLongitude = incident.longitude
      ..patrolLatitude ??= vehicleToDispatch.latitude
      ..patrolLongitude ??= vehicleToDispatch.longitude
      ..assignedIncidentId = incident.id;

    // Save the incident with the assigned vehicle
    incident
      ..status = 'dispatched'
      ..sectorId = CoverageChecker.municipalityCode
      ..assignedVehicleId = vehicleToDispatch.id;

    await Incident.db.insertRow(session, incident);
    vehicleToDispatch.assignedIncidentId = incident.id;
    await Vehicle.db.updateRow(session, vehicleToDispatch);
    await _rebalancePatrolFleet(session);

    // Notify all connected dashboards that the map has changed
    session.messages.postMessage(
      'map-update',
      MapUpdateMessage(reason: 'dispatch'),
    );

    final distance = HaversineCalculator.distanceKm(
      incident.latitude,
      incident.longitude,
      vehicleToDispatch.latitude,
      vehicleToDispatch.longitude,
    );
    final eta = HaversineCalculator.estimatedTravelSeconds(distance);

    return DispatchResult(
      success: true,
      message: 'Vehicle ${vehicleToDispatch.code} dispatched successfully.',
      assignedVehicleCode: vehicleToDispatch.code,
      estimatedArrivalSeconds: eta,
    );
  }

  // ─── Fleet management helpers ────────────────────────────────────────────────

  /// Returns all sectors with their current vehicle-count summary.
  Future<List<Sector>> getAllSectors(Session session) async {
    final boundary = await MunicipalCoveragePlanner.readBoundaryGeoJson();
    return [
      Sector(
        name: 'Município de São Paulo',
        sectorCode: CoverageChecker.municipalityCode,
        centerLatitude: -23.5505,
        centerLongitude: -46.6333,
        minimumVehicles: 1,
        boundaryGeoJson: boundary,
      ),
    ];
  }

  /// Returns all incidents with the given [status].
  /// Valid values: 'open', 'dispatched', 'closed'.
  Future<List<Incident>> getIncidentsByStatus(
    Session session,
    String status,
  ) async {
    return await Incident.db.find(
      session,
      where: (i) => i.status.equals(status),
    );
  }

  /// Closes the active incident and starts the vehicle's return to its
  /// patrol position. It becomes available when the simulation reaches it.
  Future<void> completeIncident(Session session, int vehicleId) async {
    final vehicles = await Vehicle.db.find(
      session,
      where: (v) => v.id.equals(vehicleId),
    );

    if (vehicles.isEmpty) return;

    final vehicle = vehicles.first;
    if (vehicle.status != 'on_scene') {
      throw Exception('Only a unit on scene can complete its incident.');
    }

    var returnLatitude = vehicle.patrolLatitude;
    var returnLongitude = vehicle.patrolLongitude;
    if (returnLatitude == null || returnLongitude == null) {
      final sectors = await Sector.db.find(
        session,
        where: (sector) => sector.sectorCode.equals(vehicle.currentSector),
      );
      if (sectors.isNotEmpty) {
        returnLatitude = sectors.first.centerLatitude;
        returnLongitude = sectors.first.centerLongitude;
      } else {
        returnLatitude = vehicle.latitude;
        returnLongitude = vehicle.longitude;
      }
    }

    vehicle
      ..status = 'returning'
      ..targetLatitude = returnLatitude
      ..targetLongitude = returnLongitude
      ..patrolLatitude = returnLatitude
      ..patrolLongitude = returnLongitude
      ..currentSector = CoverageChecker.municipalityCode;

    // Close the associated incident if one exists
    final incidents = await Incident.db.find(
      session,
      where: (i) =>
          i.assignedVehicleId.equals(vehicleId) & i.status.notEquals('closed'),
    );
    for (final incident in incidents) {
      incident
        ..status = 'closed'
        ..closedAt = DateTime.now();
      await Incident.db.updateRow(session, incident);
    }

    await _rebalancePatrolFleet(session, returningVehicle: vehicle);

    session.messages.postMessage(
      'map-update',
      MapUpdateMessage(reason: 'vehicle-returning'),
    );
  }

  Future<void> _rebalancePatrolFleet(
    Session session, {
    Vehicle? returningVehicle,
  }) async {
    final movingFleet = await Vehicle.db.find(
      session,
      where: (vehicle) =>
          vehicle.status.equals('available') |
          vehicle.status.equals('repositioning'),
    );
    if (returningVehicle != null &&
        movingFleet.every((vehicle) => vehicle.id != returningVehicle.id)) {
      movingFleet.add(returningVehicle);
    }
    if (movingFleet.isEmpty) return;

    final boundary = await MunicipalCoveragePlanner.readBoundaryGeoJson();
    final samples = MunicipalCoveragePlanner.sampleMunicipality(boundary);
    final targets = MunicipalCoveragePlanner.selectPatrolTargets(
      samples,
      movingFleet.length,
    );

    if (returningVehicle != null) {
      final returnTarget = (
        latitude: returningVehicle.patrolLatitude!,
        longitude: returningVehicle.patrolLongitude!,
      );
      if (targets.isNotEmpty) {
        var closestTargetIndex = 0;
        var closestDistance = double.infinity;
        for (var index = 0; index < targets.length; index++) {
          final target = targets[index];
          final distance = HaversineCalculator.distanceKm(
            returnTarget.latitude,
            returnTarget.longitude,
            target.latitude,
            target.longitude,
          );
          if (distance < closestDistance) {
            closestDistance = distance;
            closestTargetIndex = index;
          }
        }
        targets.removeAt(closestTargetIndex);
      }

      final returnDistance = HaversineCalculator.distanceKm(
        returningVehicle.latitude,
        returningVehicle.longitude,
        returnTarget.latitude,
        returnTarget.longitude,
      );
      returningVehicle
        ..targetLatitude = returnTarget.latitude
        ..targetLongitude = returnTarget.longitude
        ..status = returnDistance <= 0.1 ? 'available' : 'returning';
      if (returnDistance <= 0.1) {
        returningVehicle
          ..latitude = returnTarget.latitude
          ..longitude = returnTarget.longitude
          ..targetLatitude = null
          ..targetLongitude = null
          ..assignedIncidentId = null;
      }
      await Vehicle.db.updateRow(session, returningVehicle);
    }

    final vehiclesToReposition = returningVehicle == null
        ? movingFleet
        : movingFleet
              .where((vehicle) => vehicle.id != returningVehicle.id)
              .toList();
    final assignments = MunicipalCoveragePlanner.assignTargets(
      vehiclesToReposition,
      targets,
      (vehicle) => (latitude: vehicle.latitude, longitude: vehicle.longitude),
    );
    for (final assignment in assignments) {
      final vehicle = assignment.unit;
      final target = assignment.target;
      vehicle
        ..patrolLatitude = target.latitude
        ..patrolLongitude = target.longitude
        ..targetLatitude = target.latitude
        ..targetLongitude = target.longitude
        ..currentSector = CoverageChecker.municipalityCode;
      if (assignment.distanceKm <= 0.1) {
        vehicle
          ..latitude = target.latitude
          ..longitude = target.longitude
          ..status = 'available'
          ..targetLatitude = null
          ..targetLongitude = null
          ..assignedIncidentId = null;
      } else {
        vehicle.status = 'repositioning';
      }
      await Vehicle.db.updateRow(session, vehicle);
    }
  }
}
