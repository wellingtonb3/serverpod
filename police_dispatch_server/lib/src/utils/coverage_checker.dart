import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import 'municipal_coverage_planner.dart';

/// Summarizes the available fleet's sampled coverage of São Paulo.
///
/// This class answers the question: "Can we safely move vehicle X away
/// from its current sector without leaving that sector uncovered?"
class CoverageChecker {
  static const municipalityCode = 'CITY_SAO_PAULO';
  static const municipalityMaxDistanceKey = 'CITY_MAX_DISTANCE_METERS';

  /// Returns available counts and the maximum sampled distance to a unit.
  static Future<Map<String, int>> sectorCoverageMap(Session session) async {
    final vehicles = await Vehicle.db.find(
      session,
      where: (v) =>
          v.status.equals('available') | v.status.equals('repositioning'),
    );

    final Map<String, int> coverage = {};
    for (final v in vehicles) {
      coverage[v.currentSector] = (coverage[v.currentSector] ?? 0) + 1;
    }
    coverage[municipalityCode] = vehicles.length;
    if (vehicles.isNotEmpty) {
      final boundary = await MunicipalCoveragePlanner.readBoundaryGeoJson();
      final samples = MunicipalCoveragePlanner.sampleMunicipality(boundary);
      final positions = vehicles
          .map(
            (vehicle) =>
                (latitude: vehicle.latitude, longitude: vehicle.longitude),
          )
          .toList();
      coverage[municipalityMaxDistanceKey] =
          (MunicipalCoveragePlanner.maximumCoverageDistanceKm(
                    samples,
                    positions,
                  ) *
                  1000)
              .round();
    } else {
      coverage[municipalityMaxDistanceKey] = -1;
    }
    return coverage;
  }
}
