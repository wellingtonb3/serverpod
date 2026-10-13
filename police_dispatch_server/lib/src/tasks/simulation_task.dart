import 'dart:async';
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Background simulation task that moves dispatched, returning, and
/// repositioning vehicles toward their current destinations.
///
/// This simulates real GPS movement using linear interpolation:
/// every tick the vehicle moves 5% of the remaining distance closer
/// to its target. This creates a smooth deceleration effect as it
/// approaches the destination.
///
/// Lifecycle:
///   - Started once at server boot via [SimulationTask.start].
///   - Ticks every [_tickIntervalSeconds] seconds.
///   - Stops automatically when the server shuts down.
class SimulationTask {
  static const int _tickIntervalSeconds = 1;

  /// Distance threshold (decimal degrees) below which the vehicle is
  /// considered to have "arrived" at the incident location.
  static const double _arrivalThreshold = 0.0005; // ~55 meters

  Timer? _timer;
  final Serverpod _server;

  SimulationTask(this._server);

  /// Starts the simulation loop. Call once from [run.dart].
  void start() {
    _timer = Timer.periodic(
      const Duration(seconds: _tickIntervalSeconds),
      (_) => _tick(),
    );
  }

  /// Stops the simulation loop gracefully.
  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  /// One simulation tick: updates the position of every moving vehicle.
  Future<void> _tick() async {
    // Open a dedicated session for this background operation
    final session = await _server.createSession(enableLogging: false);

    try {
      // Fetch units travelling to incidents or assigned patrol posts.
      final movingVehicles = await Vehicle.db.find(
        session,
        where: (v) =>
            v.status.equals('dispatched') |
            v.status.equals('returning') |
            v.status.equals('repositioning'),
      );
      final movingFireVehicles = await FireVehicle.db.find(
        session,
        where: (vehicle) =>
            vehicle.status.equals('dispatched') |
            vehicle.status.equals('returning'),
      );

      if (movingVehicles.isEmpty && movingFireVehicles.isEmpty) {
        await session.close();
        return;
      }

      bool anyUpdated = false;

      for (final vehicle in movingVehicles) {
        // Skip vehicles that somehow have no target (data integrity guard)
        if (vehicle.targetLatitude == null || vehicle.targetLongitude == null) {
          continue;
        }

        final dLat = vehicle.targetLatitude! - vehicle.latitude;
        final dLon = vehicle.targetLongitude! - vehicle.longitude;

        if (dLat.abs() < _arrivalThreshold && dLon.abs() < _arrivalThreshold) {
          vehicle
            ..latitude = vehicle.targetLatitude!
            ..longitude = vehicle.targetLongitude!;
          if (vehicle.status == 'dispatched') {
            vehicle.status = 'on_scene';
          } else {
            vehicle
              ..status = 'available'
              ..targetLatitude = null
              ..targetLongitude = null
              ..assignedIncidentId = null;
          }
        } else {
          // ── Interpolate 5% of remaining distance ──────────────────────────
          // This mimics realistic travel: fast start, gradual approach.
          vehicle
            ..latitude += dLat * 0.05
            ..longitude += dLon * 0.05;
        }

        await Vehicle.db.updateRow(session, vehicle);
        anyUpdated = true;
      }

      for (final vehicle in movingFireVehicles) {
        if (vehicle.targetLatitude == null || vehicle.targetLongitude == null) {
          continue;
        }

        final dLat = vehicle.targetLatitude! - vehicle.latitude;
        final dLon = vehicle.targetLongitude! - vehicle.longitude;
        if (dLat.abs() < _arrivalThreshold && dLon.abs() < _arrivalThreshold) {
          vehicle
            ..latitude = vehicle.targetLatitude!
            ..longitude = vehicle.targetLongitude!;
          if (vehicle.status == 'dispatched') {
            vehicle.status = 'on_scene';
          } else {
            vehicle
              ..status = 'available'
              ..targetLatitude = null
              ..targetLongitude = null
              ..assignedIncidentId = null;
          }
        } else {
          vehicle
            ..latitude += dLat * 0.05
            ..longitude += dLon * 0.05;
        }

        await FireVehicle.db.updateRow(session, vehicle);
        anyUpdated = true;
      }

      // Broadcast a single map-update notification if anything changed,
      // so all connected dashboards refresh simultaneously.
      if (anyUpdated) {
        session.messages.postMessage(
          'map-update',
          MapUpdateMessage(reason: 'simulation-tick'),
        );
      }
    } catch (e, stackTrace) {
      session.log(
        'SimulationTask error: $e',
        level: LogLevel.error,
        exception: e,
        stackTrace: stackTrace,
      );
    } finally {
      await session.close();
    }
  }
}
