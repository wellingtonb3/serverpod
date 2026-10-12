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

/// Vehicle model
/// Represents a police patrol vehicle with real-time GPS position and status.
abstract class Vehicle
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Vehicle._({
    this.id,
    required this.code,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.currentSector,
    this.targetLatitude,
    this.targetLongitude,
    this.patrolLatitude,
    this.patrolLongitude,
    this.assignedIncidentId,
  });

  factory Vehicle({
    int? id,
    required String code,
    required double latitude,
    required double longitude,
    required String status,
    required String currentSector,
    double? targetLatitude,
    double? targetLongitude,
    double? patrolLatitude,
    double? patrolLongitude,
    int? assignedIncidentId,
  }) = _VehicleImpl;

  factory Vehicle.fromJson(Map<String, dynamic> jsonSerialization) {
    return Vehicle(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      latitude: (jsonSerialization['latitude'] as num).toDouble(),
      longitude: (jsonSerialization['longitude'] as num).toDouble(),
      status: jsonSerialization['status'] as String,
      currentSector: jsonSerialization['currentSector'] as String,
      targetLatitude: (jsonSerialization['targetLatitude'] as num?)?.toDouble(),
      targetLongitude:
          (jsonSerialization['targetLongitude'] as num?)?.toDouble(),
      patrolLatitude: (jsonSerialization['patrolLatitude'] as num?)?.toDouble(),
      patrolLongitude:
          (jsonSerialization['patrolLongitude'] as num?)?.toDouble(),
      assignedIncidentId: jsonSerialization['assignedIncidentId'] as int?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String code;

  double latitude;

  double longitude;

  String status;

  String currentSector;

  double? targetLatitude;

  double? targetLongitude;

  double? patrolLatitude;

  double? patrolLongitude;

  int? assignedIncidentId;

  /// Returns a shallow copy of this [Vehicle]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Vehicle copyWith({
    int? id,
    String? code,
    double? latitude,
    double? longitude,
    String? status,
    String? currentSector,
    double? targetLatitude,
    double? targetLongitude,
    double? patrolLatitude,
    double? patrolLongitude,
    int? assignedIncidentId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Vehicle',
      if (id != null) 'id': id,
      'code': code,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      'currentSector': currentSector,
      if (targetLatitude != null) 'targetLatitude': targetLatitude,
      if (targetLongitude != null) 'targetLongitude': targetLongitude,
      if (patrolLatitude != null) 'patrolLatitude': patrolLatitude,
      if (patrolLongitude != null) 'patrolLongitude': patrolLongitude,
      if (assignedIncidentId != null) 'assignedIncidentId': assignedIncidentId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Vehicle',
      if (id != null) 'id': id,
      'code': code,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      'currentSector': currentSector,
      if (targetLatitude != null) 'targetLatitude': targetLatitude,
      if (targetLongitude != null) 'targetLongitude': targetLongitude,
      if (patrolLatitude != null) 'patrolLatitude': patrolLatitude,
      if (patrolLongitude != null) 'patrolLongitude': patrolLongitude,
      if (assignedIncidentId != null) 'assignedIncidentId': assignedIncidentId,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _VehicleImpl extends Vehicle {
  _VehicleImpl({
    int? id,
    required String code,
    required double latitude,
    required double longitude,
    required String status,
    required String currentSector,
    double? targetLatitude,
    double? targetLongitude,
    double? patrolLatitude,
    double? patrolLongitude,
    int? assignedIncidentId,
  }) : super._(
          id: id,
          code: code,
          latitude: latitude,
          longitude: longitude,
          status: status,
          currentSector: currentSector,
          targetLatitude: targetLatitude,
          targetLongitude: targetLongitude,
          patrolLatitude: patrolLatitude,
          patrolLongitude: patrolLongitude,
          assignedIncidentId: assignedIncidentId,
        );

  /// Returns a shallow copy of this [Vehicle]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Vehicle copyWith({
    Object? id = _Undefined,
    String? code,
    double? latitude,
    double? longitude,
    String? status,
    String? currentSector,
    Object? targetLatitude = _Undefined,
    Object? targetLongitude = _Undefined,
    Object? patrolLatitude = _Undefined,
    Object? patrolLongitude = _Undefined,
    Object? assignedIncidentId = _Undefined,
  }) {
    return Vehicle(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status: status ?? this.status,
      currentSector: currentSector ?? this.currentSector,
      targetLatitude:
          targetLatitude is double? ? targetLatitude : this.targetLatitude,
      targetLongitude:
          targetLongitude is double? ? targetLongitude : this.targetLongitude,
      patrolLatitude:
          patrolLatitude is double? ? patrolLatitude : this.patrolLatitude,
      patrolLongitude:
          patrolLongitude is double? ? patrolLongitude : this.patrolLongitude,
      assignedIncidentId: assignedIncidentId is int?
          ? assignedIncidentId
          : this.assignedIncidentId,
    );
  }
}
