import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:police_dispatch_client/police_dispatch_client.dart';

import '../main.dart';
import '../providers/dispatch_providers.dart';

/// Side panel that shows fleet statistics and a scrollable vehicle list.
///
/// Displays:
///   - Active / En Route / On Scene vehicle counts
///   - Per-sector coverage summary
///   - Scrollable list of all vehicles with live status
class StatsPanel extends ConsumerWidget {
  const StatsPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicleStream = ref.watch(vehicleStreamProvider);
    final sectorsAsync = ref.watch(sectorsProvider);
    final sectorCoverage = ref.watch(sectorCoverageProvider);

    return Container(
      color: const Color(0xFF12122A),
      child: vehicleStream.when(
        data: (vehicles) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Summary counters ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(16),
              child: _SummaryRow(vehicles: vehicles),
            ),
            const Divider(height: 1, color: Color(0xFF2A2A4A)),

            // ── Sector coverage ───────────────────────────────────────────
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Text(
                'SECTOR COVERAGE',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            sectorsAsync.when(
              data: (sectors) => _SectorCoverageList(
                sectors: sectors,
                coverage: sectorCoverage.valueOrNull ?? {},
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Error: $e',
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            ),

            const Divider(height: 1, color: Color(0xFF2A2A4A)),

            // ── Vehicle list ──────────────────────────────────────────────
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Text(
                'ALL UNITS',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: vehicles.length,
                itemBuilder: (_, i) => _VehicleListTile(vehicle: vehicles[i]),
              ),
            ),
          ],
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFF00B0FF)),
        ),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off, color: Colors.red, size: 40),
              const SizedBox(height: 12),
              Text(
                'Connection lost\n$e',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Summary row ────────────────────────────────────────────────────────────

class _SummaryRow extends StatelessWidget {
  final List<Vehicle> vehicles;
  const _SummaryRow({required this.vehicles});

  @override
  Widget build(BuildContext context) {
    final available = vehicles.where((v) => v.status == 'available').length;
    final dispatched = vehicles
        .where(
          (v) =>
              v.status == 'dispatched' ||
              v.status == 'returning' ||
              v.status == 'repositioning',
        )
        .length;
    final onScene = vehicles.where((v) => v.status == 'on_scene').length;

    return Row(
      children: [
        _CounterCard(
          label: 'Available',
          count: available,
          color: const Color(0xFF00E676),
        ),
        const SizedBox(width: 8),
        _CounterCard(
          label: 'In Transit',
          count: dispatched,
          color: const Color(0xFFFFD740),
        ),
        const SizedBox(width: 8),
        _CounterCard(
          label: 'On Scene',
          count: onScene,
          color: const Color(0xFFFF5252),
        ),
      ],
    );
  }
}

class _CounterCard extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  const _CounterCard({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(
              '$count',
              style: TextStyle(
                color: color,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(color: Colors.white54, fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Sector coverage list ────────────────────────────────────────────────────

class _SectorCoverageList extends StatelessWidget {
  final List<Sector> sectors;
  final Map<String, int> coverage;
  const _SectorCoverageList({required this.sectors, required this.coverage});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _MunicipalityCoverageRow(coverage: coverage),
        ...sectors.where((sector) => sector.sectorCode != 'CITY_SAO_PAULO').map(
          (sector) {
            final count = coverage[sector.sectorCode] ?? 0;
            final isOk = count >= sector.minimumVehicles;
            final color = isOk
                ? const Color(0xFF00E676)
                : count > 0
                ? const Color(0xFFFFD740)
                : const Color(0xFFFF5252);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      sector.name,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Text(
                    '$count / ${sector.minimumVehicles}',
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _MunicipalityCoverageRow extends StatelessWidget {
  final Map<String, int> coverage;
  const _MunicipalityCoverageRow({required this.coverage});

  @override
  Widget build(BuildContext context) {
    final availableUnits = coverage['CITY_SAO_PAULO'] ?? 0;
    final maxDistanceMeters = coverage['CITY_MAX_DISTANCE_METERS'] ?? -1;
    final meetsTarget = maxDistanceMeters >= 0 && maxDistanceMeters <= 5000;
    final color = meetsTarget
        ? const Color(0xFF00E676)
        : const Color(0xFFFF5252);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'São Paulo · $availableUnits units · sampled max',
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
          Text(
            maxDistanceMeters < 0
                ? '-- / 5 km'
                : '${(maxDistanceMeters / 1000).toStringAsFixed(1)} / 5 km',
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Vehicle list tile ───────────────────────────────────────────────────────

class _VehicleListTile extends ConsumerStatefulWidget {
  final Vehicle vehicle;
  const _VehicleListTile({required this.vehicle});

  @override
  ConsumerState<_VehicleListTile> createState() => _VehicleListTileState();
}

class _VehicleListTileState extends ConsumerState<_VehicleListTile> {
  bool _isCompleting = false;

  @override
  Widget build(BuildContext context) {
    final vehicle = widget.vehicle;
    final color = switch (vehicle.status) {
      'available' => const Color(0xFF00E676),
      'dispatched' => const Color(0xFFFFD740),
      'on_scene' => const Color(0xFFFF5252),
      'returning' => const Color(0xFF40C4FF),
      'repositioning' => const Color(0xFFB388FF),
      _ => Colors.grey,
    };

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(Icons.local_police, color: color, size: 18),
          const SizedBox(width: 10),
          Text(
            vehicle.code,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              vehicle.currentSector == 'CITY_SAO_PAULO'
                  ? 'SÃO PAULO'
                  : vehicle.currentSector.replaceAll('ZONE_', ''),
              style: const TextStyle(color: Colors.white38, fontSize: 11),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: color.withValues(alpha: 0.4)),
            ),
            child: Text(
              vehicle.status.toUpperCase().replaceAll('_', ' '),
              style: TextStyle(
                color: color,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (vehicle.status == 'on_scene') ...[
            const SizedBox(width: 6),
            IconButton(
              onPressed: _isCompleting || vehicle.id == null
                  ? null
                  : _completeIncident,
              tooltip: 'Concluir atendimento e liberar unidade',
              visualDensity: VisualDensity.compact,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              padding: EdgeInsets.zero,
              icon: _isCompleting
                  ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(
                      Icons.check_circle_outline,
                      color: Color(0xFF00E676),
                      size: 20,
                    ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _completeIncident() async {
    final vehicleId = widget.vehicle.id;
    if (vehicleId == null) return;

    setState(() => _isCompleting = true);
    try {
      await ref.read(clientProvider).dispatch.completeIncident(vehicleId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ocorrência encerrada. Unidade retornando à patrulha.'),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Não foi possível concluir o atendimento: $error'),
        ),
      );
    } finally {
      if (mounted) setState(() => _isCompleting = false);
    }
  }
}
