/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:police_dispatch_client/src/protocol/fire_station.dart'
    as _iu994c15;
import 'package:police_dispatch_client/src/protocol/fire_vehicle.dart'
    as _iks8j07s;
import 'package:police_dispatch_client/src/protocol/incident.dart' as _i10daq7i;
import 'package:police_dispatch_client/src/protocol/sector.dart' as _ijaqrtkl;
import 'package:police_dispatch_client/src/protocol/vehicle.dart' as _iadov0ic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'dispatch_result.dart' as _ifw1qgcx;
import 'fire_station.dart' as _i7g8p8gq;
import 'fire_vehicle.dart' as _ij7uetzm;
import 'incident.dart' as _iy4wsyyx;
import 'map_update_message.dart' as _iic1uq60;
import 'sector.dart' as _i0xllqjf;
import 'vehicle.dart' as _imszitsy;
export 'dispatch_result.dart';
export 'fire_station.dart';
export 'fire_vehicle.dart';
export 'incident.dart';
export 'map_update_message.dart';
export 'sector.dart';
export 'vehicle.dart';
export 'client.dart';

class Protocol extends _isc.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _isc.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _ifw1qgcx.DispatchResult) {
      return _ifw1qgcx.DispatchResult.fromJson(data) as T;
    }
    if (t == _i7g8p8gq.FireStation) {
      return _i7g8p8gq.FireStation.fromJson(data) as T;
    }
    if (t == _ij7uetzm.FireVehicle) {
      return _ij7uetzm.FireVehicle.fromJson(data) as T;
    }
    if (t == _iy4wsyyx.Incident) {
      return _iy4wsyyx.Incident.fromJson(data) as T;
    }
    if (t == _iic1uq60.MapUpdateMessage) {
      return _iic1uq60.MapUpdateMessage.fromJson(data) as T;
    }
    if (t == _i0xllqjf.Sector) {
      return _i0xllqjf.Sector.fromJson(data) as T;
    }
    if (t == _imszitsy.Vehicle) {
      return _imszitsy.Vehicle.fromJson(data) as T;
    }
    if (t == _isc.getType<_ifw1qgcx.DispatchResult?>()) {
      return (data != null ? _ifw1qgcx.DispatchResult.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i7g8p8gq.FireStation?>()) {
      return (data != null ? _i7g8p8gq.FireStation.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ij7uetzm.FireVehicle?>()) {
      return (data != null ? _ij7uetzm.FireVehicle.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iy4wsyyx.Incident?>()) {
      return (data != null ? _iy4wsyyx.Incident.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iic1uq60.MapUpdateMessage?>()) {
      return (data != null ? _iic1uq60.MapUpdateMessage.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i0xllqjf.Sector?>()) {
      return (data != null ? _i0xllqjf.Sector.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_imszitsy.Vehicle?>()) {
      return (data != null ? _imszitsy.Vehicle.fromJson(data) : null) as T;
    }
    if (t == List<_iadov0ic.Vehicle>) {
      return (data as List)
          .map((e) => deserialize<_iadov0ic.Vehicle>(e))
          .toList() as T;
    }
    if (t == List<_iks8j07s.FireVehicle>) {
      return (data as List)
          .map((e) => deserialize<_iks8j07s.FireVehicle>(e))
          .toList() as T;
    }
    if (t == Map<String, int>) {
      return (data as Map).map(
          (k, v) => MapEntry(deserialize<String>(k), deserialize<int>(v))) as T;
    }
    if (t == List<_ijaqrtkl.Sector>) {
      return (data as List)
          .map((e) => deserialize<_ijaqrtkl.Sector>(e))
          .toList() as T;
    }
    if (t == List<_iu994c15.FireStation>) {
      return (data as List)
          .map((e) => deserialize<_iu994c15.FireStation>(e))
          .toList() as T;
    }
    if (t == List<_i10daq7i.Incident>) {
      return (data as List)
          .map((e) => deserialize<_i10daq7i.Incident>(e))
          .toList() as T;
    }
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _ifw1qgcx.DispatchResult => 'DispatchResult',
      _i7g8p8gq.FireStation => 'FireStation',
      _ij7uetzm.FireVehicle => 'FireVehicle',
      _iy4wsyyx.Incident => 'Incident',
      _iic1uq60.MapUpdateMessage => 'MapUpdateMessage',
      _i0xllqjf.Sector => 'Sector',
      _imszitsy.Vehicle => 'Vehicle',
      _ => null
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String)
          .replaceFirst('police_dispatch.', '');
    }

    switch (data) {
      case _ifw1qgcx.DispatchResult():
        return 'DispatchResult';
      case _i7g8p8gq.FireStation():
        return 'FireStation';
      case _ij7uetzm.FireVehicle():
        return 'FireVehicle';
      case _iy4wsyyx.Incident():
        return 'Incident';
      case _iic1uq60.MapUpdateMessage():
        return 'MapUpdateMessage';
      case _i0xllqjf.Sector():
        return 'Sector';
      case _imszitsy.Vehicle():
        return 'Vehicle';
    }
    if (data is List<_iadov0ic.Vehicle>) {
      return 'List<Vehicle>';
    }
    if (data is List<_iks8j07s.FireVehicle>) {
      return 'List<FireVehicle>';
    }
    if (data is Map<String, int>) {
      return 'Map<String,int>';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'DispatchResult') {
      return deserialize<_ifw1qgcx.DispatchResult>(data['data']);
    }
    if (dataClassName == 'FireStation') {
      return deserialize<_i7g8p8gq.FireStation>(data['data']);
    }
    if (dataClassName == 'FireVehicle') {
      return deserialize<_ij7uetzm.FireVehicle>(data['data']);
    }
    if (dataClassName == 'Incident') {
      return deserialize<_iy4wsyyx.Incident>(data['data']);
    }
    if (dataClassName == 'MapUpdateMessage') {
      return deserialize<_iic1uq60.MapUpdateMessage>(data['data']);
    }
    if (dataClassName == 'Sector') {
      return deserialize<_i0xllqjf.Sector>(data['data']);
    }
    if (dataClassName == 'Vehicle') {
      return deserialize<_imszitsy.Vehicle>(data['data']);
    }
    if (dataClassName == 'List<Vehicle>') {
      return deserialize<List<_iadov0ic.Vehicle>>(data['data']);
    }
    if (dataClassName == 'List<FireVehicle>') {
      return deserialize<List<_iks8j07s.FireVehicle>>(data['data']);
    }
    if (dataClassName == 'Map<String,int>') {
      return deserialize<Map<String, int>>(data['data']);
    }
    return super.deserializeByClassName(data);
  }

  @override
  String getModuleName() => 'police_dispatch';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
