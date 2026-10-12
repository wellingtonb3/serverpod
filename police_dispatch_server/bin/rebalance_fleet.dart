import 'package:police_dispatch_server/src/generated/endpoints.dart';
import 'package:police_dispatch_server/src/generated/protocol.dart';
import 'package:police_dispatch_server/src/utils/coverage_checker.dart';
import 'package:police_dispatch_server/src/utils/haversine_calculator.dart';
import 'package:police_dispatch_server/src/utils/municipal_coverage_planner.dart';
import 'package:serverpod/serverpod.dart';

Future<void> main(List<String> args) async {
  final applyChanges = args.contains('--apply');
  final serverArgs = args.where((argument) => argument != '--apply').toList();
  final server = Serverpod(serverArgs, Protocol(), Endpoints());
  await server.start();

  final session = await server.createSession();
  try {
    final vehicles = await Vehicle.db.find(session);
    if (vehicles.isEmpty) {
      throw StateError('No patrol vehicles exist in the database.');
    }
    final patrolVehicles = vehicles
        .where(
          (vehicle) =>
              vehicle.status == 'available' ||
              vehicle.status == 'repositioning',
        )
        .toList();
    if (patrolVehicles.isEmpty) {
      throw StateError('No available patrol vehicles can be repositioned.');
    }

    final boundary = await MunicipalCoveragePlanner.readBoundaryGeoJson();
    final samples = MunicipalCoveragePlanner.sampleMunicipality(boundary);
    final plannedTargets = MunicipalCoveragePlanner.selectPatrolTargets(
      samples,
      vehicles.length,
    );
    final targets = [...plannedTargets];
    final activeVehicles = vehicles
        .where(
          (vehicle) =>
              vehicle.status != 'available' &&
              vehicle.status != 'repositioning',
        )
        .toList();
    for (final vehicle in activeVehicles) {
      final anchorLatitude = vehicle.status == 'returning'
          ? vehicle.targetLatitude ?? vehicle.patrolLatitude ?? vehicle.latitude
          : vehicle.patrolLatitude ??
                vehicle.targetLatitude ??
                vehicle.latitude;
      final anchorLongitude = vehicle.status == 'returning'
          ? vehicle.targetLongitude ??
                vehicle.patrolLongitude ??
                vehicle.longitude
          : vehicle.patrolLongitude ??
                vehicle.targetLongitude ??
                vehicle.longitude;
      var closestTargetIndex = 0;
      var closestDistance = double.infinity;
      for (var index = 0; index < targets.length; index++) {
        final target = targets[index];
        final distance = HaversineCalculator.distanceKm(
          anchorLatitude,
          anchorLongitude,
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

    final assignments = MunicipalCoveragePlanner.assignTargets(
      patrolVehicles,
      targets,
      (vehicle) => (latitude: vehicle.latitude, longitude: vehicle.longitude),
    );
    final maximumDistance = MunicipalCoveragePlanner.maximumCoverageDistanceKm(
      samples,
      targets,
    );

    print('Units: ${vehicles.length}');
    print('Units being repositioned: ${assignments.length}');
    print('Active units left undisturbed: ${activeVehicles.length}');
    print('Municipal boundary sample points: ${samples.length}');
    print(
      'Estimated maximum straight-line coverage distance: '
      '${maximumDistance.toStringAsFixed(2)} km',
    );
    print(
      '5 km target: ${maximumDistance <= MunicipalCoveragePlanner.targetRadiusKm ? 'met' : 'not met'}',
    );
    if (!applyChanges) {
      print('Dry run only. Use --apply to save these patrol locations.');
      return;
    }

    for (final assignment in assignments) {
      final vehicle = assignment.unit
        ..patrolLatitude = assignment.target.latitude
        ..patrolLongitude = assignment.target.longitude
        ..targetLatitude = assignment.target.latitude
        ..targetLongitude = assignment.target.longitude
        ..currentSector = CoverageChecker.municipalityCode;
      final distance = HaversineCalculator.distanceKm(
        vehicle.latitude,
        vehicle.longitude,
        assignment.target.latitude,
        assignment.target.longitude,
      );
      if (distance <= 0.1) {
        vehicle
          ..latitude = assignment.target.latitude
          ..longitude = assignment.target.longitude
          ..status = 'available'
          ..targetLatitude = null
          ..targetLongitude = null
          ..assignedIncidentId = null;
      } else {
        vehicle.status = 'repositioning';
      }
      await Vehicle.db.updateRow(session, vehicle);
    }

    print('Saved ${assignments.length} distributed patrol locations.');
  } finally {
    await session.close();
    await server.shutdown();
  }
}
