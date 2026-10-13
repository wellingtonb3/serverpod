import 'package:police_dispatch_server/src/utils/municipal_coverage_planner.dart';
import 'package:test/test.dart';

void main() {
  group('MunicipalCoveragePlanner', () {
    test('samples the official municipality boundary', () async {
      final geoJson = await MunicipalCoveragePlanner.readBoundaryGeoJson();
      final samples = MunicipalCoveragePlanner.sampleMunicipality(geoJson);

      expect(samples.length, greaterThan(100));
      expect(
        samples.every(
          (point) =>
              point.latitude < -23.3 &&
              point.latitude > -24.1 &&
              point.longitude < -46.3 &&
              point.longitude > -46.9,
        ),
        isTrue,
      );
    });

    test('identifies addresses inside and outside the municipality', () async {
      final geoJson = await MunicipalCoveragePlanner.readBoundaryGeoJson();

      expect(
        MunicipalCoveragePlanner.isWithinMunicipality(geoJson, (
          latitude: -23.5505,
          longitude: -46.6333,
        )),
        isTrue,
      );
      expect(
        MunicipalCoveragePlanner.isWithinMunicipality(geoJson, (
          latitude: -23.5505,
          longitude: -46.3,
        )),
        isFalse,
      );
    });

    test('spreads patrol targets across the coverage area', () async {
      final geoJson = await MunicipalCoveragePlanner.readBoundaryGeoJson();
      final samples = MunicipalCoveragePlanner.sampleMunicipality(geoJson);
      final targets = MunicipalCoveragePlanner.selectPatrolTargets(samples, 18);
      final maximumDistance =
          MunicipalCoveragePlanner.maximumCoverageDistanceKm(samples, targets);

      expect(targets, hasLength(18));
      expect(targets.toSet(), hasLength(18));
      expect(maximumDistance, closeTo(10.44, 0.05));
      expect(
        maximumDistance,
        greaterThan(MunicipalCoveragePlanner.targetRadiusKm),
      );
    });

    test('75 patrol targets improve sampled citywide coverage', () async {
      final geoJson = await MunicipalCoveragePlanner.readBoundaryGeoJson();
      final samples = MunicipalCoveragePlanner.sampleMunicipality(geoJson);
      final targets75 = MunicipalCoveragePlanner.selectPatrolTargets(
        samples,
        MunicipalCoveragePlanner.patrolFleetSize,
      );
      final targets30 = MunicipalCoveragePlanner.selectPatrolTargets(
        samples,
        30,
      );
      final maximumDistance75 =
          MunicipalCoveragePlanner.maximumCoverageDistanceKm(
            samples,
            targets75,
          );
      final maximumDistance30 =
          MunicipalCoveragePlanner.maximumCoverageDistanceKm(
            samples,
            targets30,
          );

      expect(targets75, hasLength(MunicipalCoveragePlanner.patrolFleetSize));
      expect(
        targets75.toSet(),
        hasLength(MunicipalCoveragePlanner.patrolFleetSize),
      );
      expect(maximumDistance75, lessThan(maximumDistance30));
      expect(
        maximumDistance75,
        lessThan(MunicipalCoveragePlanner.targetRadiusKm),
      );
    });

    test('assigns each patrol unit to a distinct target', () {
      final units = [
        (code: 'RP-01', latitude: -23.55, longitude: -46.63),
        (code: 'RP-02', latitude: -23.56, longitude: -46.64),
      ];
      final targets = [
        (latitude: -23.54, longitude: -46.62),
        (latitude: -23.57, longitude: -46.65),
      ];

      final assignments = MunicipalCoveragePlanner.assignTargets(
        units,
        targets,
        (unit) => (latitude: unit.latitude, longitude: unit.longitude),
      );

      expect(assignments, hasLength(2));
      expect(assignments.map((assignment) => assignment.unit.code).toSet(), {
        'RP-01',
        'RP-02',
      });
      expect(
        assignments.map((assignment) => assignment.target).toSet(),
        hasLength(2),
      );
    });
  });
}
