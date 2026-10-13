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
import 'package:serverpod_client/serverpod_client.dart' as _isc;

abstract class FireVehicle
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  FireVehicle._({
    this.id,
    required this.code,
    required this.stationCode,
    required this.latitude,
    required this.longitude,
    required this.status,
    this.targetLatitude,
    this.targetLongitude,
    this.assignedIncidentId,
  });

  factory FireVehicle({
    int? id,
    required String code,
    required String stationCode,
    required double latitude,
    required double longitude,
    required String status,
    double? targetLatitude,
    double? targetLongitude,
    int? assignedIncidentId,
  }) = _FireVehicleImpl;

  factory FireVehicle.fromJson(Map<String, dynamic> jsonSerialization) {
    return FireVehicle(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      stationCode: jsonSerialization['stationCode'] as String,
      latitude: (jsonSerialization['latitude'] as num).toDouble(),
      longitude: (jsonSerialization['longitude'] as num).toDouble(),
      status: jsonSerialization['status'] as String,
      targetLatitude: (jsonSerialization['targetLatitude'] as num?)?.toDouble(),
      targetLongitude:
          (jsonSerialization['targetLongitude'] as num?)?.toDouble(),
      assignedIncidentId: jsonSerialization['assignedIncidentId'] as int?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String code;

  String stationCode;

  double latitude;

  double longitude;

  String status;

  double? targetLatitude;

  double? targetLongitude;

  int? assignedIncidentId;

  /// Returns a shallow copy of this [FireVehicle]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  FireVehicle copyWith({
    int? id,
    String? code,
    String? stationCode,
    double? latitude,
    double? longitude,
    String? status,
    double? targetLatitude,
    double? targetLongitude,
    int? assignedIncidentId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FireVehicle',
      if (id != null) 'id': id,
      'code': code,
      'stationCode': stationCode,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      if (targetLatitude != null) 'targetLatitude': targetLatitude,
      if (targetLongitude != null) 'targetLongitude': targetLongitude,
      if (assignedIncidentId != null) 'assignedIncidentId': assignedIncidentId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FireVehicle',
      if (id != null) 'id': id,
      'code': code,
      'stationCode': stationCode,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      if (targetLatitude != null) 'targetLatitude': targetLatitude,
      if (targetLongitude != null) 'targetLongitude': targetLongitude,
      if (assignedIncidentId != null) 'assignedIncidentId': assignedIncidentId,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FireVehicleImpl extends FireVehicle {
  _FireVehicleImpl({
    int? id,
    required String code,
    required String stationCode,
    required double latitude,
    required double longitude,
    required String status,
    double? targetLatitude,
    double? targetLongitude,
    int? assignedIncidentId,
  }) : super._(
          id: id,
          code: code,
          stationCode: stationCode,
          latitude: latitude,
          longitude: longitude,
          status: status,
          targetLatitude: targetLatitude,
          targetLongitude: targetLongitude,
          assignedIncidentId: assignedIncidentId,
        );

  /// Returns a shallow copy of this [FireVehicle]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  FireVehicle copyWith({
    Object? id = _Undefined,
    String? code,
    String? stationCode,
    double? latitude,
    double? longitude,
    String? status,
    Object? targetLatitude = _Undefined,
    Object? targetLongitude = _Undefined,
    Object? assignedIncidentId = _Undefined,
  }) {
    return FireVehicle(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      stationCode: stationCode ?? this.stationCode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status: status ?? this.status,
      targetLatitude:
          targetLatitude is double? ? targetLatitude : this.targetLatitude,
      targetLongitude:
          targetLongitude is double? ? targetLongitude : this.targetLongitude,
      assignedIncidentId: assignedIncidentId is int?
          ? assignedIncidentId
          : this.assignedIncidentId,
    );
  }
}
