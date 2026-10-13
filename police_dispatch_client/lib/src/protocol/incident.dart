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

/// Incident model
/// Represents an emergency call requiring police, firefighters, or both.
abstract class Incident
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Incident._({
    this.id,
    required this.description,
    this.address,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.sectorId,
    this.requestedServices,
    this.assignedVehicleId,
    this.assignedFireVehicleOneId,
    this.assignedFireVehicleTwoId,
    required this.createdAt,
    this.closedAt,
  });

  factory Incident({
    int? id,
    required String description,
    String? address,
    required double latitude,
    required double longitude,
    required String status,
    required String sectorId,
    String? requestedServices,
    int? assignedVehicleId,
    int? assignedFireVehicleOneId,
    int? assignedFireVehicleTwoId,
    required DateTime createdAt,
    DateTime? closedAt,
  }) = _IncidentImpl;

  factory Incident.fromJson(Map<String, dynamic> jsonSerialization) {
    return Incident(
      id: jsonSerialization['id'] as int?,
      description: jsonSerialization['description'] as String,
      address: jsonSerialization['address'] as String?,
      latitude: (jsonSerialization['latitude'] as num).toDouble(),
      longitude: (jsonSerialization['longitude'] as num).toDouble(),
      status: jsonSerialization['status'] as String,
      sectorId: jsonSerialization['sectorId'] as String,
      requestedServices: jsonSerialization['requestedServices'] as String?,
      assignedVehicleId: jsonSerialization['assignedVehicleId'] as int?,
      assignedFireVehicleOneId:
          jsonSerialization['assignedFireVehicleOneId'] as int?,
      assignedFireVehicleTwoId:
          jsonSerialization['assignedFireVehicleTwoId'] as int?,
      createdAt:
          _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      closedAt: jsonSerialization['closedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['closedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String description;

  String? address;

  double latitude;

  double longitude;

  String status;

  String sectorId;

  String? requestedServices;

  int? assignedVehicleId;

  int? assignedFireVehicleOneId;

  int? assignedFireVehicleTwoId;

  DateTime createdAt;

  DateTime? closedAt;

  /// Returns a shallow copy of this [Incident]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Incident copyWith({
    int? id,
    String? description,
    String? address,
    double? latitude,
    double? longitude,
    String? status,
    String? sectorId,
    String? requestedServices,
    int? assignedVehicleId,
    int? assignedFireVehicleOneId,
    int? assignedFireVehicleTwoId,
    DateTime? createdAt,
    DateTime? closedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Incident',
      if (id != null) 'id': id,
      'description': description,
      if (address != null) 'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      'sectorId': sectorId,
      if (requestedServices != null) 'requestedServices': requestedServices,
      if (assignedVehicleId != null) 'assignedVehicleId': assignedVehicleId,
      if (assignedFireVehicleOneId != null)
        'assignedFireVehicleOneId': assignedFireVehicleOneId,
      if (assignedFireVehicleTwoId != null)
        'assignedFireVehicleTwoId': assignedFireVehicleTwoId,
      'createdAt': createdAt.toJson(),
      if (closedAt != null) 'closedAt': closedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Incident',
      if (id != null) 'id': id,
      'description': description,
      if (address != null) 'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      'sectorId': sectorId,
      if (requestedServices != null) 'requestedServices': requestedServices,
      if (assignedVehicleId != null) 'assignedVehicleId': assignedVehicleId,
      if (assignedFireVehicleOneId != null)
        'assignedFireVehicleOneId': assignedFireVehicleOneId,
      if (assignedFireVehicleTwoId != null)
        'assignedFireVehicleTwoId': assignedFireVehicleTwoId,
      'createdAt': createdAt.toJson(),
      if (closedAt != null) 'closedAt': closedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _IncidentImpl extends Incident {
  _IncidentImpl({
    int? id,
    required String description,
    String? address,
    required double latitude,
    required double longitude,
    required String status,
    required String sectorId,
    String? requestedServices,
    int? assignedVehicleId,
    int? assignedFireVehicleOneId,
    int? assignedFireVehicleTwoId,
    required DateTime createdAt,
    DateTime? closedAt,
  }) : super._(
          id: id,
          description: description,
          address: address,
          latitude: latitude,
          longitude: longitude,
          status: status,
          sectorId: sectorId,
          requestedServices: requestedServices,
          assignedVehicleId: assignedVehicleId,
          assignedFireVehicleOneId: assignedFireVehicleOneId,
          assignedFireVehicleTwoId: assignedFireVehicleTwoId,
          createdAt: createdAt,
          closedAt: closedAt,
        );

  /// Returns a shallow copy of this [Incident]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Incident copyWith({
    Object? id = _Undefined,
    String? description,
    Object? address = _Undefined,
    double? latitude,
    double? longitude,
    String? status,
    String? sectorId,
    Object? requestedServices = _Undefined,
    Object? assignedVehicleId = _Undefined,
    Object? assignedFireVehicleOneId = _Undefined,
    Object? assignedFireVehicleTwoId = _Undefined,
    DateTime? createdAt,
    Object? closedAt = _Undefined,
  }) {
    return Incident(
      id: id is int? ? id : this.id,
      description: description ?? this.description,
      address: address is String? ? address : this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status: status ?? this.status,
      sectorId: sectorId ?? this.sectorId,
      requestedServices: requestedServices is String?
          ? requestedServices
          : this.requestedServices,
      assignedVehicleId: assignedVehicleId is int?
          ? assignedVehicleId
          : this.assignedVehicleId,
      assignedFireVehicleOneId: assignedFireVehicleOneId is int?
          ? assignedFireVehicleOneId
          : this.assignedFireVehicleOneId,
      assignedFireVehicleTwoId: assignedFireVehicleTwoId is int?
          ? assignedFireVehicleTwoId
          : this.assignedFireVehicleTwoId,
      createdAt: createdAt ?? this.createdAt,
      closedAt: closedAt is DateTime? ? closedAt : this.closedAt,
    );
  }
}
