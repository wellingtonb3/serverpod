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
    final fireVehicleStream = ref.watch(fireVehicleStreamProvider);
    final sectorsAsync = ref.watch(sectorsProvider);
    final sectorCoverage = ref.watch(sectorCoverageProvider);

    return Container(
      color: const Color(0xFF12122A),
      child: vehicleStream.when(
        data: (vehicles) {
          final orderedPoliceVehicles = _sortIncidentUnits(
            vehicles,
            (vehicle) => vehicle.status == 'on_scene',
            (vehicle) => vehicle.status == 'dispatched',
            (vehicle) => vehicle.code,
          );
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _PanelSectionTitle(
                        title: 'POLICE PATROL STATUS',
                        color: Color(0xFF00B0FF),
                      ),
                      _StatusSummaryRow.fromStatuses(vehicles),
                      const SizedBox(height: 10),
                      const _PanelSectionTitle(
                        title: 'FIRE UNIT STATUS',
                        color: Color(0xFFFF8A65),
                      ),
                      fireVehicleStream.when(
                        data: (fireVehicles) =>
                            _StatusSummaryRow.fromFireStatuses(fireVehicles),
                        loading: () => const SizedBox(
                          height: 52,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        error: (error, _) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'Could not load fire unit status: $error',
                            style: const TextStyle(
                              color: Color(0xFFFF5252),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Divider(height: 1, color: Color(0xFF2A2A4A)),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 8, bottom: 4),
                        child: _PanelSectionTitle(
                          title: 'SECTOR COVERAGE',
                          color: Color(0xFFB388FF),
                        ),
                      ),
                      sectorsAsync.when(
                        data: (sectors) => _SectorCoverageList(
                          sectors: sectors,
                          coverage: sectorCoverage.valueOrNull ?? {},
                        ),
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (error, _) => Text(
                          'Error: $error',
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(height: 1, color: Color(0xFF2A2A4A)),
              const Padding(
                padding: EdgeInsets.fromLTRB(12, 8, 12, 4),
                child: _PanelSectionTitle(
                  title: 'ALL UNITS',
                  color: Colors.white70,
                ),
              ),
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    Expanded(
                      child: _UnitGroup(
                        title: 'POLICE PATROL UNITS',
                        color: const Color(0xFF00B0FF),
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          itemCount: orderedPoliceVehicles.length,
                          itemBuilder: (context, index) => _VehicleListTile(
                            vehicle: orderedPoliceVehicles[index],
                          ),
                        ),
                      ),
                    ),
                    const Divider(height: 1, color: Color(0xFF2A2A4A)),
                    Expanded(
                      child: fireVehicleStream.when(
                        data: (fireVehicles) {
                          final orderedFireVehicles = _sortIncidentUnits(
                            fireVehicles,
                            (vehicle) => vehicle.status == 'on_scene',
                            (vehicle) => vehicle.status == 'dispatched',
                            (vehicle) => vehicle.code,
                          );
                          return _UnitGroup(
                            title: 'FIRE UNITS',
                            color: const Color(0xFFFF8A65),
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              itemCount: orderedFireVehicles.length,
                              itemBuilder: (context, index) =>
                                  _FireVehicleListTile(
                                    vehicle: orderedFireVehicles[index],
                                  ),
                            ),
                          );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (error, _) => Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              'Could not load fire units: $error',
                              style: const TextStyle(
                                color: Color(0xFFFF5252),
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
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

List<T> _sortIncidentUnits<T>(
  List<T> units,
  bool Function(T) isOnScene,
  bool Function(T) isDispatched,
  String Function(T) codeOf,
) {
  final sortedUnits = [...units];
  int priority(T unit) {
    if (isOnScene(unit)) return 0;
    if (isDispatched(unit)) return 1;
    return 2;
  }

  sortedUnits.sort((first, second) {
    final priorityComparison = priority(first).compareTo(priority(second));
    if (priorityComparison != 0) return priorityComparison;
    return codeOf(first).compareTo(codeOf(second));
  });
  return sortedUnits;
}

// ─── Summary row ────────────────────────────────────────────────────────────

class _PanelSectionTitle extends StatelessWidget {
  final String title;
  final Color color;

  const _PanelSectionTitle({required this.title, required this.color});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      title,
      style: TextStyle(
        color: color,
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    ),
  );
}

class _UnitGroup extends StatelessWidget {
  final String title;
  final Color color;
  final Widget child;

  const _UnitGroup({
    required this.title,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(12, 6, 12, 2),
        child: Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
      ),
      Expanded(child: child),
    ],
  );
}

class _StatusSummaryRow extends StatelessWidget {
  final int available;
  final int inTransit;
  final int onScene;

  const _StatusSummaryRow({
    required this.available,
    required this.inTransit,
    required this.onScene,
  });

  factory _StatusSummaryRow.fromStatuses(List<Vehicle> vehicles) =>
      _StatusSummaryRow(
        available: vehicles
            .where((vehicle) => vehicle.status == 'available')
            .length,
        inTransit: vehicles
            .where(
              (vehicle) =>
                  vehicle.status == 'dispatched' ||
                  vehicle.status == 'returning' ||
                  vehicle.status == 'repositioning',
            )
            .length,
        onScene: vehicles
            .where((vehicle) => vehicle.status == 'on_scene')
            .length,
      );

  factory _StatusSummaryRow.fromFireStatuses(
    List<FireVehicle> vehicles,
  ) => _StatusSummaryRow(
    available: vehicles
        .where((vehicle) => vehicle.status == 'available')
        .length,
    inTransit: vehicles
        .where(
          (vehicle) =>
              vehicle.status == 'dispatched' || vehicle.status == 'returning',
        )
        .length,
    onScene: vehicles.where((vehicle) => vehicle.status == 'on_scene').length,
  );

  @override
  Widget build(BuildContext context) => Row(
    children: [
      _CounterCard(
        label: 'Available',
        count: available,
        color: const Color(0xFF00E676),
      ),
      const SizedBox(width: 8),
      _CounterCard(
        label: 'In Transit',
        count: inTransit,
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
              tooltip: 'Complete response and release unit',
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
      ref.invalidate(activeIncidentsProvider);
      ref.invalidate(incidentHistoryProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Incident closed. Unit returning to patrol.'),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not complete response: $error'),
        ),
      );
    } finally {
      if (mounted) setState(() => _isCompleting = false);
    }
  }
}

class _FireVehicleListTile extends ConsumerStatefulWidget {
  final FireVehicle vehicle;
  const _FireVehicleListTile({required this.vehicle});

  @override
  ConsumerState<_FireVehicleListTile> createState() =>
      _FireVehicleListTileState();
}

class _FireVehicleListTileState extends ConsumerState<_FireVehicleListTile> {
  bool _isCompleting = false;

  @override
  Widget build(BuildContext context) {
    final vehicle = widget.vehicle;
    final color = switch (vehicle.status) {
      'available' => const Color(0xFF00E676),
      'dispatched' => const Color(0xFFFFD740),
      'on_scene' => const Color(0xFFFF5252),
      'returning' => const Color(0xFF40C4FF),
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
          Icon(Icons.fire_truck, color: color, size: 18),
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
              vehicle.stationCode,
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
              tooltip: 'Complete fire response and return unit to its station',
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
    final fireVehicleId = widget.vehicle.id;
    if (fireVehicleId == null) return;

    setState(() => _isCompleting = true);
    try {
      await ref
          .read(clientProvider)
          .dispatch
          .completeFireIncident(fireVehicleId);
      if (!mounted) return;
      ref.invalidate(activeIncidentsProvider);
      ref.invalidate(incidentHistoryProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fire response completed. Unit returning to station.'),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not complete fire response: $error')),
      );
    } finally {
      if (mounted) setState(() => _isCompleting = false);
    }
  }
}
