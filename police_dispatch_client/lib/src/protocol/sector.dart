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

/// Sector model
/// Represents a geographic patrol zone within the city.
abstract class Sector
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Sector._({
    this.id,
    required this.name,
    required this.sectorCode,
    required this.centerLatitude,
    required this.centerLongitude,
    required this.minimumVehicles,
    required this.boundaryGeoJson,
  });

  factory Sector({
    int? id,
    required String name,
    required String sectorCode,
    required double centerLatitude,
    required double centerLongitude,
    required int minimumVehicles,
    required String boundaryGeoJson,
  }) = _SectorImpl;

  factory Sector.fromJson(Map<String, dynamic> jsonSerialization) {
    return Sector(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      sectorCode: jsonSerialization['sectorCode'] as String,
      centerLatitude: (jsonSerialization['centerLatitude'] as num).toDouble(),
      centerLongitude: (jsonSerialization['centerLongitude'] as num).toDouble(),
      minimumVehicles: jsonSerialization['minimumVehicles'] as int,
      boundaryGeoJson: jsonSerialization['boundaryGeoJson'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  String sectorCode;

  double centerLatitude;

  double centerLongitude;

  int minimumVehicles;

  String boundaryGeoJson;

  /// Returns a shallow copy of this [Sector]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Sector copyWith({
    int? id,
    String? name,
    String? sectorCode,
    double? centerLatitude,
    double? centerLongitude,
    int? minimumVehicles,
    String? boundaryGeoJson,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Sector',
      if (id != null) 'id': id,
      'name': name,
      'sectorCode': sectorCode,
      'centerLatitude': centerLatitude,
      'centerLongitude': centerLongitude,
      'minimumVehicles': minimumVehicles,
      'boundaryGeoJson': boundaryGeoJson,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Sector',
      if (id != null) 'id': id,
      'name': name,
      'sectorCode': sectorCode,
      'centerLatitude': centerLatitude,
      'centerLongitude': centerLongitude,
      'minimumVehicles': minimumVehicles,
      'boundaryGeoJson': boundaryGeoJson,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SectorImpl extends Sector {
  _SectorImpl({
    int? id,
    required String name,
    required String sectorCode,
    required double centerLatitude,
    required double centerLongitude,
    required int minimumVehicles,
    required String boundaryGeoJson,
  }) : super._(
          id: id,
          name: name,
          sectorCode: sectorCode,
          centerLatitude: centerLatitude,
          centerLongitude: centerLongitude,
          minimumVehicles: minimumVehicles,
          boundaryGeoJson: boundaryGeoJson,
        );

  /// Returns a shallow copy of this [Sector]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Sector copyWith({
    Object? id = _Undefined,
    String? name,
    String? sectorCode,
    double? centerLatitude,
    double? centerLongitude,
    int? minimumVehicles,
    String? boundaryGeoJson,
  }) {
    return Sector(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      sectorCode: sectorCode ?? this.sectorCode,
      centerLatitude: centerLatitude ?? this.centerLatitude,
      centerLongitude: centerLongitude ?? this.centerLongitude,
      minimumVehicles: minimumVehicles ?? this.minimumVehicles,
      boundaryGeoJson: boundaryGeoJson ?? this.boundaryGeoJson,
    );
  }
}
