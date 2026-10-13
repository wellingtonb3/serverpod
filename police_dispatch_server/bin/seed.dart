import 'package:serverpod/serverpod.dart';
import 'package:police_dispatch_server/src/generated/endpoints.dart';
import 'package:police_dispatch_server/src/generated/protocol.dart';
import 'package:police_dispatch_server/src/utils/coverage_checker.dart';
import 'package:police_dispatch_server/src/utils/fire_station_catalog.dart';
import 'package:police_dispatch_server/src/utils/municipal_coverage_planner.dart';

/// Database seeder for development and testing.
///
/// Seeds the database with:
///   - The official municipality boundary for São Paulo
///   - 75 patrol vehicles distributed across that boundary
///   - Two fire-response vehicles at each mapped fire station
///
/// Run with:
///   dart run bin/seed.dart --apply-migrations
void main(List<String> args) async {
  final pod = Serverpod(args, Protocol(), Endpoints());
  await pod.start();

  final session = await pod.createSession();

  await _seedSectors(session);
  await _seedVehicles(session);
  await _seedFireStationsAndVehicles(session);

  await session.close();
  await pod.shutdown();
}

Future<void> _seedSectors(Session session) async {
  final existing = await Sector.db.find(
    session,
    where: (sector) =>
        sector.sectorCode.equals(CoverageChecker.municipalityCode),
  );
  final sector = Sector(
    id: existing.isEmpty ? null : existing.first.id,
    name: 'Município de São Paulo',
    sectorCode: CoverageChecker.municipalityCode,
    centerLatitude: -23.5505,
    centerLongitude: -46.6333,
    minimumVehicles: 1,
    boundaryGeoJson: await MunicipalCoveragePlanner.readBoundaryGeoJson(),
  );

  if (existing.isEmpty) {
    await Sector.db.insertRow(session, sector);
  } else {
    await Sector.db.updateRow(session, sector);
  }
  print('Seeded the São Paulo municipality boundary.');
}

Future<void> _seedVehicles(Session session) async {
  final existing = await Vehicle.db.find(session);
  final existingCodes = existing.map((vehicle) => vehicle.code).toSet();
  final samples = MunicipalCoveragePlanner.sampleMunicipality(
    await MunicipalCoveragePlanner.readBoundaryGeoJson(),
  );
  final targets = MunicipalCoveragePlanner.selectPatrolTargets(
    samples,
    MunicipalCoveragePlanner.patrolFleetSize,
  );

  for (
    var index = 0;
    index < MunicipalCoveragePlanner.patrolFleetSize;
    index++
  ) {
    final code = 'RP-${(index + 1).toString().padLeft(2, '0')}';
    if (existingCodes.contains(code)) continue;
    final target = targets[index];
    await Vehicle.db.insertRow(
      session,
      Vehicle(
        code: code,
        latitude: target.latitude,
        longitude: target.longitude,
        patrolLatitude: target.latitude,
        patrolLongitude: target.longitude,
        status: 'available',
        currentSector: CoverageChecker.municipalityCode,
      ),
    );
  }

  print(
    'Ensured ${MunicipalCoveragePlanner.patrolFleetSize} distributed patrol vehicles.',
  );
}

Future<void> _seedFireStationsAndVehicles(Session session) async {
  final stations = await FireStationCatalog.readStations();
  final existingStations = await FireStation.db.find(session);
  final stationsByCode = {
    for (final station in existingStations) station.stationCode: station,
  };
  final existingVehicles = await FireVehicle.db.find(session);
  final existingVehicleCodes = existingVehicles
      .map((vehicle) => vehicle.code)
      .toSet();

  for (final station in stations) {
    final storedStation = stationsByCode[station.code];
    if (storedStation == null) {
      await FireStation.db.insertRow(
        session,
        FireStation(
          stationCode: station.code,
          name: station.name,
          latitude: station.latitude,
          longitude: station.longitude,
          osmType: station.osmType,
          osmId: station.osmId,
        ),
      );
    } else {
      storedStation
        ..name = station.name
        ..latitude = station.latitude
        ..longitude = station.longitude
        ..osmType = station.osmType
        ..osmId = station.osmId;
      await FireStation.db.updateRow(session, storedStation);
    }

    for (
      var unitNumber = 1;
      unitNumber <= FireStationCatalog.unitsPerStation;
      unitNumber++
    ) {
      final code =
          'FB-${station.osmId}-${unitNumber.toString().padLeft(2, '0')}';
      if (existingVehicleCodes.contains(code)) continue;
      await FireVehicle.db.insertRow(
        session,
        FireVehicle(
          code: code,
          stationCode: station.code,
          latitude: station.latitude,
          longitude: station.longitude,
          status: 'available',
        ),
      );
    }
  }

  print(
    'Ensured ${stations.length} mapped fire stations and '
    '${stations.length * FireStationCatalog.unitsPerStation} fire units.',
  );
}
