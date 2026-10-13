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

abstract class FireStation
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  FireStation._({
    this.id,
    required this.stationCode,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.osmType,
    required this.osmId,
  });

  factory FireStation({
    int? id,
    required String stationCode,
    required String name,
    required double latitude,
    required double longitude,
    required String osmType,
    required String osmId,
  }) = _FireStationImpl;

  factory FireStation.fromJson(Map<String, dynamic> jsonSerialization) {
    return FireStation(
      id: jsonSerialization['id'] as int?,
      stationCode: jsonSerialization['stationCode'] as String,
      name: jsonSerialization['name'] as String,
      latitude: (jsonSerialization['latitude'] as num).toDouble(),
      longitude: (jsonSerialization['longitude'] as num).toDouble(),
      osmType: jsonSerialization['osmType'] as String,
      osmId: jsonSerialization['osmId'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String stationCode;

  String name;

  double latitude;

  double longitude;

  String osmType;

  String osmId;

  /// Returns a shallow copy of this [FireStation]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  FireStation copyWith({
    int? id,
    String? stationCode,
    String? name,
    double? latitude,
    double? longitude,
    String? osmType,
    String? osmId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FireStation',
      if (id != null) 'id': id,
      'stationCode': stationCode,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'osmType': osmType,
      'osmId': osmId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FireStation',
      if (id != null) 'id': id,
      'stationCode': stationCode,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'osmType': osmType,
      'osmId': osmId,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FireStationImpl extends FireStation {
  _FireStationImpl({
    int? id,
    required String stationCode,
    required String name,
    required double latitude,
    required double longitude,
    required String osmType,
    required String osmId,
  }) : super._(
          id: id,
          stationCode: stationCode,
          name: name,
          latitude: latitude,
          longitude: longitude,
          osmType: osmType,
          osmId: osmId,
        );

  /// Returns a shallow copy of this [FireStation]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  FireStation copyWith({
    Object? id = _Undefined,
    String? stationCode,
    String? name,
    double? latitude,
    double? longitude,
    String? osmType,
    String? osmId,
  }) {
    return FireStation(
      id: id is int? ? id : this.id,
      stationCode: stationCode ?? this.stationCode,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      osmType: osmType ?? this.osmType,
      osmId: osmId ?? this.osmId,
    );
  }
}
