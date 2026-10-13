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

/// DispatchResult model
/// Returned by the dispatch endpoint to describe the result of a dispatch request.
abstract class DispatchResult
    implements _is.SerializableModel, _is.ProtocolSerialization {
  DispatchResult._({
    required this.success,
    required this.message,
    this.assignedVehicleCode,
    this.assignedFireVehicleCodes,
    this.estimatedArrivalSeconds,
  });

  factory DispatchResult({
    required bool success,
    required String message,
    String? assignedVehicleCode,
    String? assignedFireVehicleCodes,
    int? estimatedArrivalSeconds,
  }) = _DispatchResultImpl;

  factory DispatchResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return DispatchResult(
      success: _is.BoolJsonExtension.fromJson(jsonSerialization['success']),
      message: jsonSerialization['message'] as String,
      assignedVehicleCode: jsonSerialization['assignedVehicleCode'] as String?,
      assignedFireVehicleCodes:
          jsonSerialization['assignedFireVehicleCodes'] as String?,
      estimatedArrivalSeconds:
          jsonSerialization['estimatedArrivalSeconds'] as int?,
    );
  }

  bool success;

  String message;

  String? assignedVehicleCode;

  String? assignedFireVehicleCodes;

  int? estimatedArrivalSeconds;

  /// Returns a shallow copy of this [DispatchResult]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DispatchResult copyWith({
    bool? success,
    String? message,
    String? assignedVehicleCode,
    String? assignedFireVehicleCodes,
    int? estimatedArrivalSeconds,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DispatchResult',
      'success': success,
      'message': message,
      if (assignedVehicleCode != null)
        'assignedVehicleCode': assignedVehicleCode,
      if (assignedFireVehicleCodes != null)
        'assignedFireVehicleCodes': assignedFireVehicleCodes,
      if (estimatedArrivalSeconds != null)
        'estimatedArrivalSeconds': estimatedArrivalSeconds,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DispatchResult',
      'success': success,
      'message': message,
      if (assignedVehicleCode != null)
        'assignedVehicleCode': assignedVehicleCode,
      if (assignedFireVehicleCodes != null)
        'assignedFireVehicleCodes': assignedFireVehicleCodes,
      if (estimatedArrivalSeconds != null)
        'estimatedArrivalSeconds': estimatedArrivalSeconds,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DispatchResultImpl extends DispatchResult {
  _DispatchResultImpl({
    required bool success,
    required String message,
    String? assignedVehicleCode,
    String? assignedFireVehicleCodes,
    int? estimatedArrivalSeconds,
  }) : super._(
         success: success,
         message: message,
         assignedVehicleCode: assignedVehicleCode,
         assignedFireVehicleCodes: assignedFireVehicleCodes,
         estimatedArrivalSeconds: estimatedArrivalSeconds,
       );

  /// Returns a shallow copy of this [DispatchResult]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DispatchResult copyWith({
    bool? success,
    String? message,
    Object? assignedVehicleCode = _Undefined,
    Object? assignedFireVehicleCodes = _Undefined,
    Object? estimatedArrivalSeconds = _Undefined,
  }) {
    return DispatchResult(
      success: success ?? this.success,
      message: message ?? this.message,
      assignedVehicleCode: assignedVehicleCode is String?
          ? assignedVehicleCode
          : this.assignedVehicleCode,
      assignedFireVehicleCodes: assignedFireVehicleCodes is String?
          ? assignedFireVehicleCodes
          : this.assignedFireVehicleCodes,
      estimatedArrivalSeconds: estimatedArrivalSeconds is int?
          ? estimatedArrivalSeconds
          : this.estimatedArrivalSeconds,
    );
  }
}
