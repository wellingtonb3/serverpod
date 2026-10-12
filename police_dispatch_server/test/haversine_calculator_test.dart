import 'package:test/test.dart';
import 'package:police_dispatch_server/src/utils/haversine_calculator.dart';

/// Unit tests for the Haversine distance calculator.
///
/// Reference values obtained from online Haversine calculators and
/// cross-validated against PostGIS ST_DistanceSphere results.
void main() {
  group('HaversineCalculator', () {
    test('returns 0 km for identical coordinates', () {
      final result = HaversineCalculator.distanceKm(
        -23.5505, -46.6333,
        -23.5505, -46.6333,
      );
      expect(result, closeTo(0.0, 0.001));
    });

    test('calculates known São Paulo cross-city distance correctly', () {
      // Downtown (Centro) to Guarulhos Airport: approx 20.7 km by haversine
      final result = HaversineCalculator.distanceKm(
        -23.5505, -46.6333, // Centro
        -23.4356, -46.4731, // Guarulhos Airport
      );
      // Allow a reasonable tolerance around the actual great-circle distance.
      expect(result, inInclusiveRange(18.0, 24.0));
    });

    test('calculates approximate 1 km distance correctly', () {
      // Move approximately 1 degree of latitude ≈ 111 km, so 0.009° ≈ 1 km
      final result = HaversineCalculator.distanceKm(
        -23.5505, -46.6333,
        -23.5415, -46.6333,
      );
      expect(result, closeTo(1.0, 0.2));
    });

    test('is symmetric — distance A→B equals distance B→A', () {
      final ab = HaversineCalculator.distanceKm(
        -23.5505, -46.6333,
        -23.6300, -46.6600,
      );
      final ba = HaversineCalculator.distanceKm(
        -23.6300, -46.6600,
        -23.5505, -46.6333,
      );
      expect(ab, closeTo(ba, 0.0001));
    });

    test('estimatedTravelSeconds returns correct value at 50 km/h', () {
      // 10 km at 50 km/h should take 720 seconds (12 minutes)
      final seconds = HaversineCalculator.estimatedTravelSeconds(10.0);
      expect(seconds, equals(720));
    });

    test('estimatedTravelSeconds respects custom speed', () {
      // 10 km at 100 km/h should take 360 seconds (6 minutes)
      final seconds = HaversineCalculator.estimatedTravelSeconds(
          10.0, speedKmh: 100);
      expect(seconds, equals(360));
    });
  });
}
