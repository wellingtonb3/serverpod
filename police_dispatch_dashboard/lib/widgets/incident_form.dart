import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:police_dispatch_client/police_dispatch_client.dart';

import '../main.dart';

/// Modal bottom sheet for reporting a new incident.
///
/// The dispatcher fills in:
///   - Description of the incident
///   - Latitude / Longitude of the location
///
/// On submit, the intelligent dispatch algorithm on the server selects
/// the most appropriate available vehicle and returns an ETA.
class IncidentForm extends ConsumerStatefulWidget {
  const IncidentForm({super.key});

  @override
  ConsumerState<IncidentForm> createState() => _IncidentFormState();
}

class _IncidentFormState extends ConsumerState<IncidentForm> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _latController = TextEditingController(text: '-23.5505');
  final _lonController = TextEditingController(text: '-46.6333');

  bool _isSubmitting = false;
  String? _resultMessage;
  bool _success = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    _latController.dispose();
    _lonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A2E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Header ─────────────────────────────────────────────────
              Row(
                children: [
                  const Icon(
                    Icons.report_problem,
                    color: Color(0xFFFF5252),
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Report New Incident',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white54),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ── Description field ──────────────────────────────────────
              _buildLabel('Incident Description'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _descriptionController,
                style: const TextStyle(color: Colors.white),
                maxLines: 2,
                decoration: _inputDecoration(
                  hint: 'e.g. Armed robbery at Avenida Paulista, near subway',
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              // ── Coordinates row ────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Latitude'),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _latController,
                          style: const TextStyle(color: Colors.white),
                          keyboardType: const TextInputType.numberWithOptions(
                            signed: true,
                            decimal: true,
                          ),
                          decoration: _inputDecoration(hint: '-23.5505'),
                          validator: (v) => _validateDouble(v, 'Latitude'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Longitude'),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _lonController,
                          style: const TextStyle(color: Colors.white),
                          keyboardType: const TextInputType.numberWithOptions(
                            signed: true,
                            decimal: true,
                          ),
                          decoration: _inputDecoration(hint: '-46.6333'),
                          validator: (v) => _validateDouble(v, 'Longitude'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ── Result message ─────────────────────────────────────────
              if (_resultMessage != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color:
                        (_success
                                ? const Color(0xFF00E676)
                                : const Color(0xFFFF5252))
                            .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _success
                          ? const Color(0xFF00E676)
                          : const Color(0xFFFF5252),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _success ? Icons.check_circle : Icons.error,
                        color: _success
                            ? const Color(0xFF00E676)
                            : const Color(0xFFFF5252),
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _resultMessage!,
                          style: TextStyle(
                            color: _success
                                ? const Color(0xFF00E676)
                                : const Color(0xFFFF5252),
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // ── Submit button ──────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB71C1C),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: _isSubmitting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.send),
                  label: Text(
                    _isSubmitting ? 'Dispatching...' : 'Dispatch Vehicle',
                  ),
                  onPressed: _isSubmitting ? null : _submit,
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Submit handler ────────────────────────────────────────────────────────

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
      _resultMessage = null;
    });

    try {
      final client = ref.read(clientProvider);
      final incident = Incident(
        description: _descriptionController.text.trim(),
        latitude: double.parse(_latController.text),
        longitude: double.parse(_lonController.text),
        status: 'open',
        sectorId: 'CITY_SAO_PAULO',
        createdAt: DateTime.now(),
      );

      final result = await client.dispatch.requestDispatch(incident);

      setState(() {
        _success = result.success;
        _resultMessage = result.success
            ? '${result.message} ETA: ${result.estimatedArrivalSeconds}s'
            : result.message;
      });

      if (result.success) {
        // Close the form after a short delay so the user sees confirmation
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) Navigator.pop(context);
      }
    } catch (e) {
      setState(() {
        _success = false;
        _resultMessage = 'Connection error: $e';
      });
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  Widget _buildLabel(String text) => Text(
    text,
    style: const TextStyle(
      color: Colors.white70,
      fontSize: 12,
      fontWeight: FontWeight.w600,
    ),
  );

  InputDecoration _inputDecoration({required String hint}) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Colors.white30),
    filled: true,
    fillColor: const Color(0xFF0D0D1A),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFF2A2A4A)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFF2A2A4A)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFF1565C0), width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFFF5252)),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  );

  String? _validateDouble(String? value, String field) {
    if (value == null || value.isEmpty) return 'Required';
    if (double.tryParse(value) == null) return 'Invalid $field';
    return null;
  }
}
