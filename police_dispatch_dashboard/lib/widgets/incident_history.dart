import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:police_dispatch_client/police_dispatch_client.dart';

import '../providers/dispatch_providers.dart';

class IncidentHistory extends ConsumerWidget {
  const IncidentHistory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(incidentHistoryProvider);
    final vehicles = ref.watch(vehicleStreamProvider).valueOrNull ?? [];
    final fireVehicles = ref.watch(fireVehicleStreamProvider).valueOrNull ?? [];
    final vehicleCodes = {
      for (final vehicle in vehicles)
        if (vehicle.id != null) vehicle.id!: vehicle.code,
    };
    final fireVehicleCodes = {
      for (final vehicle in fireVehicles)
        if (vehicle.id != null) vehicle.id!: vehicle.code,
    };

    return Dialog(
      backgroundColor: const Color(0xFF1A1A2E),
      insetPadding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760, maxHeight: 650),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.history, color: Color(0xFF00B0FF)),
                  const SizedBox(width: 10),
                  const Text(
                    'Dispatch History',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Close',
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white70),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Completed incidents and assigned response units',
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: history.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, _) => Center(
                    child: Text(
                      'Could not load dispatch history: $error',
                      style: const TextStyle(color: Color(0xFFFF5252)),
                    ),
                  ),
                  data: (incidents) => incidents.isEmpty
                      ? const Center(
                          child: Text(
                            'No completed incidents yet.',
                            style: TextStyle(color: Colors.white54),
                          ),
                        )
                      : ListView.separated(
                          itemCount: incidents.length,
                          separatorBuilder: (_, __) => const Divider(
                            height: 1,
                            color: Color(0xFF2A2A4A),
                          ),
                          itemBuilder: (context, index) => _HistoryItem(
                            incident: incidents[index],
                            vehicleCodes: vehicleCodes,
                            fireVehicleCodes: fireVehicleCodes,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HistoryItem extends StatelessWidget {
  final Incident incident;
  final Map<int, String> vehicleCodes;
  final Map<int, String> fireVehicleCodes;

  const _HistoryItem({
    required this.incident,
    required this.vehicleCodes,
    required this.fireVehicleCodes,
  });

  @override
  Widget build(BuildContext context) {
    final duration = incident.closedAt?.difference(incident.createdAt);
    final assignedUnits = <String>[
      if (incident.assignedVehicleId != null)
        vehicleCodes[incident.assignedVehicleId] ??
            'Police unit #${incident.assignedVehicleId}',
      if (incident.assignedFireVehicleOneId != null)
        fireVehicleCodes[incident.assignedFireVehicleOneId!] ??
            'Fire unit #${incident.assignedFireVehicleOneId}',
      if (incident.assignedFireVehicleTwoId != null)
        fireVehicleCodes[incident.assignedFireVehicleTwoId!] ??
            'Fire unit #${incident.assignedFireVehicleTwoId}',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            incident.description,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          _DetailLine(
            icon: Icons.location_on_outlined,
            text: incident.address?.trim().isNotEmpty == true
                ? incident.address!
                : 'Coordinates: ${incident.latitude.toStringAsFixed(5)}, '
                      '${incident.longitude.toStringAsFixed(5)}',
          ),
          _DetailLine(
            icon: Icons.local_police_outlined,
            text: assignedUnits.isEmpty
                ? 'No unit recorded'
                : assignedUnits.join('  •  '),
          ),
          _DetailLine(
            icon: Icons.timer_outlined,
            text: duration == null
                ? 'Duration unavailable'
                : 'Duration: ${_formatDuration(duration)}',
          ),
          _DetailLine(
            icon: Icons.event_outlined,
            text: _formatDate(incident.createdAt),
          ),
        ],
      ),
    );
  }

  static String _formatDuration(Duration duration) {
    final totalMinutes = duration.inMinutes;
    if (totalMinutes < 1) return '${duration.inSeconds}s';
    if (totalMinutes < 60) return '${totalMinutes}min';
    final hours = totalMinutes ~/ 60;
    return '${hours}h ${totalMinutes % 60}min';
  }

  static String _formatDate(DateTime date) {
    final local = date.toLocal();
    String twoDigits(int value) => value.toString().padLeft(2, '0');
    return '${twoDigits(local.day)}/${twoDigits(local.month)}/${local.year} '
        '${twoDigits(local.hour)}:${twoDigits(local.minute)}';
  }
}

class _DetailLine extends StatelessWidget {
  final IconData icon;
  final String text;

  const _DetailLine({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.white38),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
