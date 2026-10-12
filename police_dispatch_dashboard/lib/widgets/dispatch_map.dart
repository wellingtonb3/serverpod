import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:police_dispatch_client/police_dispatch_client.dart';

import '../providers/dispatch_providers.dart';

/// Live interactive map showing all patrol vehicles, sector boundaries,
/// and open incidents.
///
/// Uses OpenStreetMap tiles (no API key required).
/// Vehicle markers update in real time via the Serverpod stream.
class DispatchMap extends ConsumerStatefulWidget {
  const DispatchMap({super.key});

  @override
  ConsumerState<DispatchMap> createState() => _DispatchMapState();
}

class _DispatchMapState extends ConsumerState<DispatchMap> {
  final MapController _mapController = MapController();

  // São Paulo city centre — initial camera position
  static const LatLng _saoPauloCenter = LatLng(-23.5505, -46.6333);
  static const double _initialZoom = 10.5;

  @override
  Widget build(BuildContext context) {
    final vehicleStream = ref.watch(vehicleStreamProvider);
    final sectorCoverage = ref.watch(sectorCoverageProvider);
    final sectorsAsync = ref.watch(sectorsProvider);
    final incidentsAsync = ref.watch(activeIncidentsProvider);

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: const MapOptions(
            initialCenter: _saoPauloCenter,
            initialZoom: _initialZoom,
            interactionOptions: InteractionOptions(flags: InteractiveFlag.all),
          ),
          children: [
            // ── Base tile layer (OpenStreetMap dark variant) ───────────────
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.police_dispatch_dashboard',
              retinaMode: RetinaMode.isHighDensity(context),
            ),

            // ── Sector boundary polygons ───────────────────────────────────
            sectorsAsync.when(
              data: (sectors) => PolygonLayer<LatLng>(
                polygons: sectors.map<Polygon<LatLng>>((sector) {
                  final coverage = sectorCoverage.valueOrNull;
                  final count = coverage?[sector.sectorCode] ?? 0;
                  return _buildSectorPolygon(sector, count);
                }).toList(),
              ),
              loading: () => const PolygonLayer<LatLng>(polygons: []),
              error: (_, __) => const PolygonLayer<LatLng>(polygons: []),
            ),

            // ── Vehicle markers ────────────────────────────────────────────
            vehicleStream.when(
              data: (vehicles) => MarkerLayer(
                markers: vehicles.map(_buildVehicleMarker).toList(),
              ),
              loading: () => const MarkerLayer(markers: []),
              error: (_, __) => const MarkerLayer(markers: []),
            ),
            incidentsAsync.when(
              data: (incidents) => MarkerLayer(
                markers: incidents
                    .map(
                      (incident) => Marker(
                        point: LatLng(incident.latitude, incident.longitude),
                        width: 64,
                        height: 58,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFB71C1C),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'CALL #${incident.id ?? ''}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.location_on,
                              color: Color(0xFFFF5252),
                              size: 30,
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
              loading: () => const MarkerLayer(markers: []),
              error: (_, __) => const MarkerLayer(markers: []),
            ),
          ],
        ),

        // ── Map legend overlay ─────────────────────────────────────────────
        Positioned(bottom: 12, left: 12, child: _MapLegend()),

        // ── Vehicle count badge ────────────────────────────────────────────
        Positioned(
          top: 12,
          right: 12,
          child: vehicleStream.when(
            data: (v) => _VehicleCountBadge(count: v.length),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }

  // ─── Marker builders ───────────────────────────────────────────────────────

  Marker _buildVehicleMarker(Vehicle vehicle) {
    return Marker(
      point: LatLng(vehicle.latitude, vehicle.longitude),
      width: 48,
      height: 60,
      child: GestureDetector(
        onTap: () => _showVehicleDetails(vehicle),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                vehicle.code,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Icon(
              Icons.local_police,
              color: _vehicleColor(vehicle.status),
              size: 28,
              shadows: const [Shadow(color: Colors.black, blurRadius: 4)],
            ),
          ],
        ),
      ),
    );
  }

  Polygon<LatLng> _buildSectorPolygon(Sector sector, int coverageCount) {
    // Parse the GeoJSON polygon string to a list of LatLng points
    final points = _parseGeoJsonPolygon(sector.boundaryGeoJson);

    // Coverage-based colour: green (good) → yellow (warning) → red (critical)
    final fillColor = _coverageColor(coverageCount, sector.minimumVehicles);
    final label = sector.sectorCode == 'CITY_SAO_PAULO'
        ? '${sector.name}\n$coverageCount patrol units'
        : '${sector.name}\n$coverageCount / ${sector.minimumVehicles}';

    return Polygon<LatLng>(
      points: points,
      color: fillColor.withValues(alpha: 0.15),
      borderColor: fillColor.withValues(alpha: 0.6),
      borderStrokeWidth: 1.5,
      label: label,
      labelStyle: const TextStyle(
        color: Colors.white70,
        fontSize: 10,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  // ─── Detail bottom sheet ───────────────────────────────────────────────────

  void _showVehicleDetails(Vehicle vehicle) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.local_police, color: _vehicleColor(vehicle.status)),
                const SizedBox(width: 10),
                Text(
                  vehicle.code,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                _StatusBadge(status: vehicle.status),
              ],
            ),
            const SizedBox(height: 12),
            _DetailRow(
              'Sector',
              vehicle.currentSector == 'CITY_SAO_PAULO'
                  ? 'São Paulo'
                  : vehicle.currentSector,
            ),
            _DetailRow('Latitude', vehicle.latitude.toStringAsFixed(5)),
            _DetailRow('Longitude', vehicle.longitude.toStringAsFixed(5)),
            if (vehicle.assignedIncidentId != null)
              _DetailRow('Incident ID', '#${vehicle.assignedIncidentId}'),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  Color _vehicleColor(String status) => switch (status) {
    'available' => const Color(0xFF00E676),
    'dispatched' => const Color(0xFFFFD740),
    'on_scene' => const Color(0xFFFF5252),
    'returning' => const Color(0xFF40C4FF),
    'repositioning' => const Color(0xFFB388FF),
    _ => Colors.grey,
  };

  Color _coverageColor(int count, int minimum) {
    if (count >= minimum) return const Color(0xFF00E676);
    if (count > 0) return const Color(0xFFFFD740);
    return const Color(0xFFFF5252);
  }

  /// Parses a GeoJSON Polygon string into a list of [LatLng] points.
  List<LatLng> _parseGeoJsonPolygon(String geoJson) {
    final document = jsonDecode(geoJson) as Map<String, dynamic>;
    final map = document['type'] == 'FeatureCollection'
        ? ((document['features'] as List<dynamic>).first
                  as Map<String, dynamic>)['geometry']
              as Map<String, dynamic>
        : document['type'] == 'Feature'
        ? document['geometry'] as Map<String, dynamic>
        : document;
    if (map['type'] != 'Polygon') {
      throw FormatException(
        'Unsupported map boundary geometry: ${map['type']}',
      );
    }
    final rings = map['coordinates'] as List<dynamic>;
    if (rings.isEmpty || (rings.first as List<dynamic>).isEmpty) {
      throw const FormatException('Map boundary polygon has no outer ring.');
    }
    final coordinates = rings.first as List<dynamic>;
    return coordinates
        .map(
          (coordinate) => LatLng(
            (coordinate[1] as num).toDouble(),
            (coordinate[0] as num).toDouble(),
          ),
        )
        .toList();
  }
}

// ─── Supporting widgets ─────────────────────────────────────────────────────

class _VehicleCountBadge extends StatelessWidget {
  final int count;
  const _VehicleCountBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A1A).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF00B0FF), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.directions_car, color: Color(0xFF00B0FF), size: 16),
          const SizedBox(width: 6),
          Text(
            '$count units active',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _MapLegend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A1A).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF2A2A4A)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LegendItem(color: Color(0xFF00E676), label: 'Available'),
          SizedBox(height: 4),
          _LegendItem(color: Color(0xFFFFD740), label: 'En Route'),
          SizedBox(height: 4),
          _LegendItem(color: Color(0xFF40C4FF), label: 'Returning'),
          SizedBox(height: 4),
          _LegendItem(color: Color(0xFFB388FF), label: 'Repositioning'),
          SizedBox(height: 4),
          _LegendItem(color: Color(0xFFFF5252), label: 'On Scene'),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.local_police, color: color, size: 14),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      'available' => const Color(0xFF00E676),
      'dispatched' => const Color(0xFFFFD740),
      'on_scene' => const Color(0xFFFF5252),
      'returning' => const Color(0xFF40C4FF),
      'repositioning' => const Color(0xFFB388FF),
      _ => Colors.grey,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        status.toUpperCase().replaceAll('_', ' '),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(color: Colors.white54, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
