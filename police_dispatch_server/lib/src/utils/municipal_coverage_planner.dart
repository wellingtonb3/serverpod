import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'haversine_calculator.dart';

typedef PatrolPoint = ({double latitude, double longitude});
typedef PatrolAssignment<T> = ({T unit, PatrolPoint target, double distanceKm});

class MunicipalCoveragePlanner {
  static const patrolFleetSize = 75;
  static const targetRadiusKm = 5.0;
  static const _sampleStepKm = 1.0;
  static const boundaryAssetPath = 'assets/sao_paulo_municipality.geojson';

  static Future<String> readBoundaryGeoJson() =>
      File(boundaryAssetPath).readAsString();

  static bool isWithinMunicipality(String geoJson, PatrolPoint point) {
    final collection = jsonDecode(geoJson) as Map<String, dynamic>;
    final features = collection['features'] as List<dynamic>;
    for (final feature in features) {
      final geometry =
          (feature as Map<String, dynamic>)['geometry'] as Map<String, dynamic>;
      final polygons = _polygonRings(
        geometry['type'] as String,
        geometry['coordinates'] as List<dynamic>,
      );
      for (final polygon in polygons) {
        final rings = polygon
            .map(
              (ring) => ring.map((coordinate) {
                final pair = coordinate;
                return (
                  latitude: (pair[1] as num).toDouble(),
                  longitude: (pair[0] as num).toDouble(),
                );
              }).toList(),
            )
            .toList();
        if (rings.isNotEmpty &&
            _contains(rings.first, point) &&
            !rings.skip(1).any((hole) => _contains(hole, point))) {
          return true;
        }
      }
    }
    return false;
  }

  static List<PatrolPoint> sampleMunicipality(String geoJson) {
    final collection = jsonDecode(geoJson) as Map<String, dynamic>;
    final features = collection['features'] as List<dynamic>;
    final polygons = <List<List<PatrolPoint>>>[];

    for (final feature in features) {
      final geometry =
          (feature as Map<String, dynamic>)['geometry'] as Map<String, dynamic>;
      final coordinates = geometry['coordinates'] as List<dynamic>;
      for (final polygon in _polygonRings(
        geometry['type'] as String,
        coordinates,
      )) {
        polygons.add(
          polygon
              .map(
                (ring) => ring.map((coordinate) {
                  final pair = coordinate;
                  return (
                    latitude: (pair[1] as num).toDouble(),
                    longitude: (pair[0] as num).toDouble(),
                  );
                }).toList(),
              )
              .toList(),
        );
      }
    }

    if (polygons.isEmpty || polygons.every((polygon) => polygon.isEmpty)) {
      throw const FormatException(
        'Municipality boundary has no polygon rings.',
      );
    }

    final latitudeStep = _sampleStepKm / 111.0;
    final samples = <PatrolPoint>[];
    for (final polygon in polygons) {
      if (polygon.isEmpty) continue;
      final outerRing = polygon.first;
      final latitudes = outerRing.map((point) => point.latitude);
      final longitudes = outerRing.map((point) => point.longitude);
      final minLatitude = latitudes.reduce(math.min);
      final maxLatitude = latitudes.reduce(math.max);
      final minLongitude = longitudes.reduce(math.min);
      final maxLongitude = longitudes.reduce(math.max);
      final longitudeStep =
          _sampleStepKm /
          (111.0 *
              math.cos(_degreesToRadians((minLatitude + maxLatitude) / 2)));

      for (
        var latitude = minLatitude;
        latitude <= maxLatitude;
        latitude += latitudeStep
      ) {
        for (
          var longitude = minLongitude;
          longitude <= maxLongitude;
          longitude += longitudeStep
        ) {
          final point = (latitude: latitude, longitude: longitude);
          if (_contains(outerRing, point) &&
              !polygon.skip(1).any((hole) => _contains(hole, point))) {
            samples.add(point);
          }
        }
      }
      for (final ring in polygon) {
        samples.addAll(_sampleBoundary(ring));
      }
    }
    return samples;
  }

  static List<PatrolPoint> selectPatrolTargets(
    List<PatrolPoint> coverageSamples,
    int vehicleCount,
  ) {
    if (vehicleCount <= 0 || coverageSamples.isEmpty) return [];

    final center = (
      latitude:
          coverageSamples
              .map((point) => point.latitude)
              .reduce((a, b) => a + b) /
          coverageSamples.length,
      longitude:
          coverageSamples
              .map((point) => point.longitude)
              .reduce((a, b) => a + b) /
          coverageSamples.length,
    );
    var selectedIndex = 0;
    var closestToCenter = double.infinity;
    for (var index = 0; index < coverageSamples.length; index++) {
      final distance = _distanceKm(center, coverageSamples[index]);
      if (distance < closestToCenter) {
        closestToCenter = distance;
        selectedIndex = index;
      }
    }

    final selected = <PatrolPoint>[];
    final nearestDistance = List<double>.filled(
      coverageSamples.length,
      double.infinity,
    );
    while (selected.length < vehicleCount) {
      final target = coverageSamples[selectedIndex];
      selected.add(target);

      var farthestDistance = -1.0;
      for (var index = 0; index < coverageSamples.length; index++) {
        nearestDistance[index] = math.min(
          nearestDistance[index],
          _distanceKm(coverageSamples[index], target),
        );
        if (nearestDistance[index] > farthestDistance) {
          farthestDistance = nearestDistance[index];
          selectedIndex = index;
        }
      }
      if (farthestDistance == 0) break;
    }

    return selected;
  }

  static double maximumCoverageDistanceKm(
    List<PatrolPoint> coverageSamples,
    List<PatrolPoint> vehiclePositions,
  ) {
    if (coverageSamples.isEmpty) {
      throw ArgumentError.value(coverageSamples, 'coverageSamples');
    }
    if (vehiclePositions.isEmpty) return double.infinity;

    var maximumDistance = 0.0;
    for (final sample in coverageSamples) {
      var nearestDistance = double.infinity;
      for (final vehicle in vehiclePositions) {
        nearestDistance = math.min(
          nearestDistance,
          _distanceKm(sample, vehicle),
        );
      }
      maximumDistance = math.max(maximumDistance, nearestDistance);
    }
    return maximumDistance;
  }

  static List<PatrolAssignment<T>> assignTargets<T>(
    List<T> units,
    List<PatrolPoint> targets,
    PatrolPoint Function(T unit) positionOf,
  ) {
    final remainingUnits = [...units];
    final remainingTargets = [...targets];
    final assignments = <PatrolAssignment<T>>[];

    while (remainingUnits.isNotEmpty && remainingTargets.isNotEmpty) {
      var nearestUnitIndex = 0;
      var nearestTargetIndex = 0;
      var nearestDistance = double.infinity;

      for (var unitIndex = 0; unitIndex < remainingUnits.length; unitIndex++) {
        final position = positionOf(remainingUnits[unitIndex]);
        for (
          var targetIndex = 0;
          targetIndex < remainingTargets.length;
          targetIndex++
        ) {
          final target = remainingTargets[targetIndex];
          final distance = _distanceKm(position, target);
          if (distance < nearestDistance) {
            nearestDistance = distance;
            nearestUnitIndex = unitIndex;
            nearestTargetIndex = targetIndex;
          }
        }
      }

      final unit = remainingUnits.removeAt(nearestUnitIndex);
      final target = remainingTargets.removeAt(nearestTargetIndex);
      assignments.add((
        unit: unit,
        target: target,
        distanceKm: nearestDistance,
      ));
    }

    return assignments;
  }

  static List<List<List<List<dynamic>>>> _polygonRings(
    String geometryType,
    List<dynamic> coordinates,
  ) {
    if (geometryType == 'Polygon') {
      return [
        coordinates
            .map((ring) => ring as List<dynamic>)
            .map((ring) => ring.map((point) => point as List<dynamic>).toList())
            .toList(),
      ];
    }
    if (geometryType == 'MultiPolygon') {
      return coordinates
          .map(
            (polygon) => (polygon as List<dynamic>)
                .map(
                  (ring) => (ring as List<dynamic>)
                      .map((point) => point as List<dynamic>)
                      .toList(),
                )
                .toList(),
          )
          .toList();
    }
    throw FormatException('Unsupported boundary geometry: $geometryType');
  }

  static bool _contains(List<PatrolPoint> ring, PatrolPoint point) {
    var inside = false;
    for (var i = 0, j = ring.length - 1; i < ring.length; j = i++) {
      final first = ring[i];
      final second = ring[j];
      final crosses =
          (first.latitude > point.latitude) !=
          (second.latitude > point.latitude);
      if (crosses &&
          point.longitude <
              (second.longitude - first.longitude) *
                      (point.latitude - first.latitude) /
                      (second.latitude - first.latitude) +
                  first.longitude) {
        inside = !inside;
      }
    }
    return inside;
  }

  static List<PatrolPoint> _sampleBoundary(List<PatrolPoint> ring) {
    final samples = <PatrolPoint>[];
    for (var index = 0; index < ring.length; index++) {
      final start = ring[index];
      final end = ring[(index + 1) % ring.length];
      final distance = _distanceKm(start, end);
      final segments = math.max(1, (distance / _sampleStepKm).ceil());
      for (var segment = 0; segment < segments; segment++) {
        final fraction = segment / segments;
        samples.add((
          latitude: start.latitude + (end.latitude - start.latitude) * fraction,
          longitude:
              start.longitude + (end.longitude - start.longitude) * fraction,
        ));
      }
    }
    return samples;
  }

  static double _distanceKm(PatrolPoint first, PatrolPoint second) =>
      HaversineCalculator.distanceKm(
        first.latitude,
        first.longitude,
        second.latitude,
        second.longitude,
      );

  static double _degreesToRadians(double degrees) => degrees * (math.pi / 180);
}
