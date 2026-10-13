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

  Stream<List<FireVehicle>> monitorFireVehicles(Session session) async* {
    final channel = session.messages.createStream<MapUpdateMessage>(
      'map-update',
    );
    yield await FireVehicle.db.find(session);
    await for (final _ in channel) {
      yield await FireVehicle.db.find(session);
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
    final boundary = await MunicipalCoveragePlanner.readBoundaryGeoJson();
    if (!MunicipalCoveragePlanner.isWithinMunicipality(boundary, (
      latitude: incident.latitude,
      longitude: incident.longitude,
    ))) {
      return DispatchResult(
        success: false,
        message:
            'This address is outside São Paulo. This MVP dashboard manages only São Paulo city.',
        assignedVehicleCode: null,
        assignedFireVehicleCodes: null,
        estimatedArrivalSeconds: null,
      );
    }

    final requestedServices = (incident.requestedServices ?? 'police')
        .split(',')
        .map((service) => service.trim())
        .where((service) => service.isNotEmpty)
        .toSet();
    if (requestedServices.isEmpty ||
        requestedServices.any(
          (service) => service != 'police' && service != 'firefighters',
        )) {
      throw ArgumentError.value(
        incident.requestedServices,
        'requestedServices',
        'Select police, firefighters, or both.',
      );
    }
    final requestsPolice = requestedServices.contains('police');
    final requestsFirefighters = requestedServices.contains('firefighters');

    Vehicle? policeVehicle;
    if (requestsPolice) {
      final available = await Vehicle.db.find(
        session,
        where: (v) =>
            v.status.equals('available') | v.status.equals('repositioning'),
      );
      if (available.isNotEmpty) {
        policeVehicle = await _selectPoliceVehicle(
          session,
          incident,
          available,
        );
      }
    }

    List<FireVehicle> fireVehicles = [];
    if (requestsFirefighters) {
      final fireVehicle = await _selectFireResponseVehicle(session, incident);
      if (fireVehicle != null) fireVehicles = [fireVehicle];
    }

    if ((requestsPolice && policeVehicle == null) ||
        (requestsFirefighters && fireVehicles.isEmpty)) {
      final unavailableServices = <String>[
        if (requestsPolice && policeVehicle == null) 'police',
        if (requestsFirefighters && fireVehicles.isEmpty) 'firefighters',
      ];
      return DispatchResult(
        success: false,
        message:
            'Not enough available units for: ${unavailableServices.join(' and ')}. No unit was dispatched.',
        assignedVehicleCode: null,
        assignedFireVehicleCodes: null,
        estimatedArrivalSeconds: null,
      );
    }

    incident
      ..status = 'dispatched'
      ..sectorId = CoverageChecker.municipalityCode
      ..requestedServices = requestedServices.join(',')
      ..assignedVehicleId = policeVehicle?.id
      ..assignedFireVehicleOneId = fireVehicles.isEmpty
          ? null
          : fireVehicles[0].id
      ..assignedFireVehicleTwoId = null;
    await Incident.db.insertRow(session, incident);

    if (policeVehicle != null) {
      policeVehicle
        ..status = 'dispatched'
        ..targetLatitude = incident.latitude
        ..targetLongitude = incident.longitude
        ..patrolLatitude ??= policeVehicle.latitude
        ..patrolLongitude ??= policeVehicle.longitude
        ..assignedIncidentId = incident.id;
      await Vehicle.db.updateRow(session, policeVehicle);
      await _rebalancePatrolFleet(session);
    }

    for (final vehicle in fireVehicles) {
      vehicle
        ..status = 'dispatched'
        ..targetLatitude = incident.latitude
        ..targetLongitude = incident.longitude
        ..assignedIncidentId = incident.id;
      await FireVehicle.db.updateRow(session, vehicle);
    }

    // Notify all connected dashboards that the map has changed
    session.messages.postMessage(
      'map-update',
      MapUpdateMessage(reason: 'dispatch'),
    );

    final responseCodes = <String>[
      if (policeVehicle != null) 'Police ${policeVehicle.code}',
      if (fireVehicles.isNotEmpty)
        'Fire ${fireVehicles.map((vehicle) => vehicle.code).join(', ')}',
    ];
    final responseDistances = <double>[
      if (policeVehicle != null)
        HaversineCalculator.distanceKm(
          incident.latitude,
          incident.longitude,
          policeVehicle.latitude,
          policeVehicle.longitude,
        ),
      ...fireVehicles.map(
        (vehicle) => HaversineCalculator.distanceKm(
          incident.latitude,
          incident.longitude,
          vehicle.latitude,
          vehicle.longitude,
        ),
      ),
    ];
    final eta = responseDistances
        .map(HaversineCalculator.estimatedTravelSeconds)
        .reduce((first, second) => first < second ? first : second);

    return DispatchResult(
      success: true,
      message: '${responseCodes.join(' and ')} dispatched.',
      assignedVehicleCode: policeVehicle?.code,
      assignedFireVehicleCodes: fireVehicles.isEmpty
          ? null
          : fireVehicles.map((vehicle) => vehicle.code).join(', '),
      estimatedArrivalSeconds: eta,
    );
  }

  Future<Vehicle> _selectPoliceVehicle(
    Session _,
    Incident incident,
    List<Vehicle> available,
  ) async {
    double distanceToIncident(Vehicle vehicle) =>
        HaversineCalculator.distanceKm(
          incident.latitude,
          incident.longitude,
          vehicle.latitude,
          vehicle.longitude,
        );

    available.sort(
      (first, second) =>
          distanceToIncident(first).compareTo(distanceToIncident(second)),
    );
    return available.first;
  }

  Future<FireVehicle?> _selectFireResponseVehicle(
    Session session,
    Incident incident,
  ) async {
    final available = await FireVehicle.db.find(
      session,
      where: (vehicle) => vehicle.status.equals('available'),
    );
    if (available.isEmpty) return null;
    available.sort(
      (first, second) =>
          _distanceToIncident(
            incident,
            first.latitude,
            first.longitude,
          ).compareTo(
            _distanceToIncident(incident, second.latitude, second.longitude),
          ),
    );
    return available.first;
  }

  double _distanceToIncident(
    Incident incident,
    double latitude,
    double longitude,
  ) => HaversineCalculator.distanceKm(
    incident.latitude,
    incident.longitude,
    latitude,
    longitude,
  );

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

  Future<List<FireStation>> getAllFireStations(Session session) =>
      FireStation.db.find(session, orderBy: (station) => station.stationCode);

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

    final incidents = await Incident.db.find(
      session,
      where: (i) =>
          i.assignedVehicleId.equals(vehicleId) & i.status.notEquals('closed'),
    );
    await Vehicle.db.updateRow(session, vehicle);
    for (final incident in incidents) {
      await _closeIncidentWhenResponsesComplete(session, incident);
    }
    await _rebalancePatrolFleet(session, returningVehicle: vehicle);

    session.messages.postMessage(
      'map-update',
      MapUpdateMessage(reason: 'vehicle-returning'),
    );
  }

  Future<void> completeFireIncident(Session session, int fireVehicleId) async {
    final vehicles = await FireVehicle.db.find(
      session,
      where: (vehicle) => vehicle.id.equals(fireVehicleId),
    );
    if (vehicles.isEmpty) return;

    final vehicle = vehicles.first;
    if (vehicle.status != 'on_scene') {
      throw Exception('Only a fire unit on scene can complete its incident.');
    }
    final stations = await FireStation.db.find(
      session,
      where: (station) => station.stationCode.equals(vehicle.stationCode),
    );
    if (stations.isEmpty) {
      throw StateError('Fire station ${vehicle.stationCode} was not found.');
    }
    final station = stations.first;
    vehicle
      ..status = 'returning'
      ..targetLatitude = station.latitude
      ..targetLongitude = station.longitude;
    await FireVehicle.db.updateRow(session, vehicle);

    final incidents = await Incident.db.find(
      session,
      where: (incident) =>
          (incident.assignedFireVehicleOneId.equals(fireVehicleId) |
              incident.assignedFireVehicleTwoId.equals(fireVehicleId)) &
          incident.status.notEquals('closed'),
    );
    for (final incident in incidents) {
      await _closeIncidentWhenResponsesComplete(session, incident);
    }
    session.messages.postMessage(
      'map-update',
      MapUpdateMessage(reason: 'fire-vehicle-returning'),
    );
  }

  Future<void> _closeIncidentWhenResponsesComplete(
    Session session,
    Incident incident,
  ) async {
    final policeId = incident.assignedVehicleId;
    if (policeId != null) {
      final policeVehicles = await Vehicle.db.find(
        session,
        where: (vehicle) => vehicle.id.equals(policeId),
      );
      if (policeVehicles.isNotEmpty &&
          (policeVehicles.first.status == 'dispatched' ||
              policeVehicles.first.status == 'on_scene')) {
        return;
      }
    }

    final fireIds = [
      incident.assignedFireVehicleOneId,
      incident.assignedFireVehicleTwoId,
    ].whereType<int>();
    for (final fireId in fireIds) {
      final fireVehicles = await FireVehicle.db.find(
        session,
        where: (vehicle) => vehicle.id.equals(fireId),
      );
      if (fireVehicles.isNotEmpty &&
          (fireVehicles.first.status == 'dispatched' ||
              fireVehicles.first.status == 'on_scene')) {
        return;
      }
    }

    incident
      ..status = 'closed'
      ..closedAt = DateTime.now();
    await Incident.db.updateRow(session, incident);
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
