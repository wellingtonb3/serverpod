/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;

/// MapUpdateMessage model
/// Lightweight message broadcast over the 'map-update' channel.
/// Used to notify all connected dashboards that vehicle state has changed.
abstract class MapUpdateMessage
    implements _is.SerializableModel, _is.ProtocolSerialization {
  MapUpdateMessage._({required this.reason});

  factory MapUpdateMessage({required String reason}) = _MapUpdateMessageImpl;

  factory MapUpdateMessage.fromJson(Map<String, dynamic> jsonSerialization) {
    return MapUpdateMessage(reason: jsonSerialization['reason'] as String);
  }

  String reason;

  /// Returns a shallow copy of this [MapUpdateMessage]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  MapUpdateMessage copyWith({String? reason});
  @override
  Map<String, dynamic> toJson() {
    return {'__className__': 'MapUpdateMessage', 'reason': reason};
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {'__className__': 'MapUpdateMessage', 'reason': reason};
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _MapUpdateMessageImpl extends MapUpdateMessage {
  _MapUpdateMessageImpl({required String reason}) : super._(reason: reason);

  /// Returns a shallow copy of this [MapUpdateMessage]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  MapUpdateMessage copyWith({String? reason}) {
    return MapUpdateMessage(reason: reason ?? this.reason);
  }
}
