import 'dart:math' as math;

/// Utility class for geospatial distance calculations.
///
/// Uses the Haversine formula to compute great-circle distances between
/// two GPS coordinates. Accurate enough for urban-scale dispatch operations
/// (error < 0.5% for distances under 100 km).
class HaversineCalculator {
  static const double _earthRadiusKm = 6371.0;

  /// Calculates the distance in kilometres between two GPS coordinates.
  ///
  /// [lat1], [lon1] — origin point (decimal degrees)
  /// [lat2], [lon2] — destination point (decimal degrees)
  static double distanceKm(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);

    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) *
            math.cos(_toRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return _earthRadiusKm * c;
  }

  /// Estimates travel time in seconds given a distance (km) and average
  /// speed (km/h). Default speed is 50 km/h (urban patrol average).
  static int estimatedTravelSeconds(double distanceKm, {double speedKmh = 50}) {
    return ((distanceKm / speedKmh) * 3600).round();
  }

  static double _toRadians(double degrees) => degrees * (math.pi / 180.0);
}
