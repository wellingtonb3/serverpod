import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:police_dispatch_client/police_dispatch_client.dart';

import '../main.dart';

/// Provides a live stream of all patrol vehicles from the server.
///
/// Automatically reconnects if the stream is interrupted.
/// Consumed by the map and stats panels via [vehicleStreamProvider].
final vehicleStreamProvider = StreamProvider<List<Vehicle>>((ref) {
  final client = ref.watch(clientProvider);
  return client.dispatch.monitorVehicles();
});

/// Provides a live stream of sector coverage (sectorCode → vehicleCount).
/// Used to colour-code sector polygons on the map.
final sectorCoverageProvider = StreamProvider<Map<String, int>>((ref) {
  final client = ref.watch(clientProvider);
  return client.dispatch.monitorSectorCoverage();
});

/// Provides the full list of patrol sectors (static — loaded once).
final sectorsProvider = FutureProvider<List<Sector>>((ref) async {
  final client = ref.watch(clientProvider);
  return client.dispatch.getAllSectors();
});

/// Tracks the currently selected incident form state.
/// Null means no incident creation is in progress.
final pendingIncidentProvider = StateProvider<PendingIncident?>((ref) => null);

/// Simple value class for the incident creation form.
class PendingIncident {
  final double latitude;
  final double longitude;
  final String description;

  const PendingIncident({
    required this.latitude,
    required this.longitude,
    required this.description,
  });
}
