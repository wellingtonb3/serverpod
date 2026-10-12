import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:police_dispatch_client/police_dispatch_client.dart';

import '../main.dart';
import '../providers/dispatch_providers.dart';

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
  final _addressController = TextEditingController();
  final _latController = TextEditingController();
  final _lonController = TextEditingController();

  bool _isSubmitting = false;
  bool _isGeocoding = false;
  String? _resultMessage;
  bool _success = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    _addressController.dispose();
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

              _buildLabel('Incident Address in São Paulo'),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _addressController,
                      style: const TextStyle(color: Colors.white),
                      textCapitalization: TextCapitalization.words,
                      decoration: _inputDecoration(
                        hint: 'e.g. Avenida Rebouças, 1000',
                      ),
                      onFieldSubmitted: (_) => _searchAddress(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    tooltip: 'Find address',
                    onPressed: _isGeocoding || _isSubmitting
                        ? null
                        : _searchAddress,
                    icon: _isGeocoding
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.search),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Searches OpenStreetMap. Select the matching result to set the destination.',
                style: TextStyle(color: Colors.white38, fontSize: 11),
              ),
              const SizedBox(height: 16),

              // ── Coordinates row ────────────────────────────────────────
              _buildLabel(
                'Coordinates (filled by address search or manual entry)',
              ),
              const SizedBox(height: 6),
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
        latitude: _parseCoordinate(_latController.text),
        longitude: _parseCoordinate(_lonController.text),
        status: 'open',
        sectorId: 'CITY_SAO_PAULO',
        createdAt: DateTime.now(),
      );

      final result = await client.dispatch.requestDispatch(incident);
      if (result.success) ref.invalidate(activeIncidentsProvider);

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

  Future<void> _searchAddress() async {
    final address = _addressController.text.trim();
    if (address.isEmpty) {
      setState(() {
        _success = false;
        _resultMessage = 'Enter an address to search.';
      });
      return;
    }

    setState(() {
      _isGeocoding = true;
      _resultMessage = null;
    });

    try {
      final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
        'q': '$address, São Paulo, SP, Brasil',
        'countrycodes': 'br',
        'format': 'jsonv2',
        'limit': '5',
        'accept-language': 'pt-BR',
      });
      final response = await http
          .get(
            uri,
            headers: const {'User-Agent': 'PoliceDispatchDashboard/1.0'},
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        throw Exception('Address lookup failed (HTTP ${response.statusCode}).');
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! List) {
        throw const FormatException('Unexpected address lookup response.');
      }
      if (!mounted) return;
      final results = decoded.map((item) {
        if (item is! Map<String, dynamic>) {
          throw const FormatException('Unexpected address result format.');
        }
        return _AddressSearchResult.fromJson(item);
      }).toList();
      if (results.isEmpty) {
        setState(() {
          _success = false;
          _resultMessage =
              'No matching address found in São Paulo. Try adding a street number or neighborhood.';
        });
        return;
      }

      final selected = await showDialog<_AddressSearchResult>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF1A1A2E),
          title: const Text(
            'Select the incident location',
            style: TextStyle(color: Colors.white),
          ),
          content: SizedBox(
            width: 480,
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: results.length,
              separatorBuilder: (_, _) =>
                  const Divider(color: Color(0xFF2A2A4A)),
              itemBuilder: (context, index) {
                final result = results[index];
                return ListTile(
                  leading: const Icon(
                    Icons.location_on,
                    color: Color(0xFFFF5252),
                  ),
                  title: Text(
                    result.displayName,
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () => Navigator.pop(context, result),
                );
              },
            ),
          ),
        ),
      );

      if (!mounted || selected == null) return;
      setState(() {
        _latController.text = selected.latitude.toString();
        _lonController.text = selected.longitude.toString();
        _success = true;
        _resultMessage =
            'Destination set: ${selected.latitude.toStringAsFixed(5)}, ${selected.longitude.toStringAsFixed(5)}';
      });
    } on FormatException catch (error) {
      if (!mounted) return;
      setState(() {
        _success = false;
        _resultMessage = 'Could not read the address search response: $error';
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _success = false;
        _resultMessage = 'Address search failed: $error';
      });
    } finally {
      if (mounted) setState(() => _isGeocoding = false);
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
    if (value == null || value.trim().isEmpty) {
      return 'Search an address or enter coordinates';
    }
    if (_parseCoordinateOrNull(value) == null) return 'Invalid $field';
    return null;
  }

  double _parseCoordinate(String value) => _parseCoordinateOrNull(value)!;

  double? _parseCoordinateOrNull(String value) =>
      double.tryParse(value.trim().replaceAll(',', '.'));
}

class _AddressSearchResult {
  final String displayName;
  final double latitude;
  final double longitude;

  const _AddressSearchResult({
    required this.displayName,
    required this.latitude,
    required this.longitude,
  });

  factory _AddressSearchResult.fromJson(Map<String, dynamic> json) {
    final displayName = json['display_name'];
    final latitude = json['lat'];
    final longitude = json['lon'];
    if (displayName is! String || latitude is! String || longitude is! String) {
      throw const FormatException('Address result has invalid coordinates.');
    }
    final parsedLatitude = double.tryParse(latitude);
    final parsedLongitude = double.tryParse(longitude);
    if (parsedLatitude == null ||
        parsedLongitude == null ||
        parsedLatitude < -90 ||
        parsedLatitude > 90 ||
        parsedLongitude < -180 ||
        parsedLongitude > 180) {
      throw const FormatException('Address result has invalid coordinates.');
    }
    return _AddressSearchResult(
      displayName: displayName,
      latitude: parsedLatitude,
      longitude: parsedLongitude,
    );
  }
}
