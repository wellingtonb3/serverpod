import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:police_dispatch_client/police_dispatch_client.dart';

import '../providers/dispatch_providers.dart';
import '../services/dispatch_alert_service.dart';
import '../widgets/dispatch_map.dart';
import '../widgets/stats_panel.dart';
import '../widgets/incident_form.dart';
import '../widgets/incident_history.dart';

/// Main dashboard screen — the primary view of the application.
///
/// Layout (responsive):
/// ┌─────────────────────────────┬──────────────────┐
/// │                             │  Stats Panel     │
/// │   Live Dispatch Map         │  (vehicle list,  │
/// │   (flutter_map / OSM)       │   sector cover.) │
/// │                             │                  │
/// └─────────────────────────────┴──────────────────┘
///
/// On screens narrower than 800 dp the stats panel moves below the map.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(vehicleStreamProvider, (previous, next) {
      DispatchAlertService.updatePoliceDispatchState(
        _hasDispatchedUnit(next.valueOrNull),
      );
    });
    ref.listen(fireVehicleStreamProvider, (previous, next) {
      DispatchAlertService.updateFireDispatchState(
        _hasDispatchedUnit(next.valueOrNull),
      );
    });

    final width = MediaQuery.of(context).size.width;
    final isWide = width >= 800;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      appBar: _buildAppBar(context, ref),
      body: isWide ? _wideLayout() : _narrowLayout(),
    );
  }

  bool _hasDispatchedUnit<T extends Object>(List<T>? units) {
    return units?.any((unit) => _unitStatus(unit) == 'dispatched') ?? false;
  }

  String _unitStatus(Object unit) {
    if (unit is Vehicle) return unit.status;
    if (unit is FireVehicle) return unit.status;
    return '';
  }

  // ─── App bar ───────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar(BuildContext context, WidgetRef ref) {
    return AppBar(
      backgroundColor: const Color(0xFF0A0A1A),
      elevation: 0,
      title: Row(
        children: [
          Image.asset(
            'assets/images/titan_logo.jpg',
            width: 76,
            height: 40,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 8),
          const Flexible(
            child: Text(
              'Titan System',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Spacer(),
          const _ConnectionIndicator(),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: _historyButton(context),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: _reportIncidentButton(context),
        ),
      ],
    );
  }

  // ─── Layout variants ───────────────────────────────────────────────────────

  Widget _wideLayout() {
    return Row(
      children: [
        // Map takes ~65% of the width
        const Expanded(flex: 65, child: DispatchMap()),
        // Vertical divider
        Container(width: 1, color: const Color(0xFF2A2A4A)),
        // Stats panel takes ~35%
        const Expanded(flex: 35, child: StatsPanel()),
      ],
    );
  }

  Widget _narrowLayout() {
    return const Column(
      children: [
        Expanded(flex: 55, child: DispatchMap()),
        Divider(height: 1, color: Color(0xFF2A2A4A)),
        Expanded(flex: 45, child: StatsPanel()),
      ],
    );
  }

  // ─── FAB — report incident ─────────────────────────────────────────────────

  Widget _reportIncidentButton(BuildContext context) {
    if (MediaQuery.sizeOf(context).width < 600) {
      return IconButton.filled(
        tooltip: 'Report Incident',
        onPressed: () => _showIncidentForm(context),
        style: IconButton.styleFrom(
          backgroundColor: const Color(0xFFB71C1C),
          foregroundColor: Colors.white,
        ),
        icon: const Icon(Icons.report_problem),
      );
    }

    return FilledButton.icon(
      style: FilledButton.styleFrom(
        backgroundColor: const Color(0xFFB71C1C),
        foregroundColor: Colors.white,
      ),
      onPressed: () => _showIncidentForm(context),
      icon: const Icon(Icons.report_problem),
      label: const Text('Report Incident'),
    );
  }

  Widget _historyButton(BuildContext context) {
    return IconButton.filled(
      tooltip: 'Dispatch History',
      onPressed: () =>
          showDialog(context: context, builder: (_) => const IncidentHistory()),
      style: IconButton.styleFrom(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
      ),
      icon: const Icon(Icons.history),
    );
  }

  void _showIncidentForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const IncidentForm(),
    );
  }
}

// ─── Connection indicator ──────────────────────────────────────────────────

/// Small dot that shows green when the server stream is alive, red otherwise.
class _ConnectionIndicator extends ConsumerWidget {
  const _ConnectionIndicator();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stream = ref.watch(vehicleStreamProvider);
    final color = stream.when(
      data: (_) => const Color(0xFF00E676),
      loading: () => const Color(0xFFFFD740),
      error: (_, __) => const Color(0xFFFF5252),
    );
    final label = stream.when(
      data: (_) => 'Live',
      loading: () => 'Connecting',
      error: (_, __) => 'Disconnected',
    );

    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(color: color, fontSize: 12)),
        const SizedBox(width: 16),
      ],
    );
  }
}
