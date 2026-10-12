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
import 'dart:async' as _ida;
import 'package:http/http.dart' as _i85jenna;
import 'package:police_dispatch_client/src/protocol/dispatch_result.dart'
    as _it223q1i;
import 'package:police_dispatch_client/src/protocol/incident.dart' as _i10daq7i;
import 'package:police_dispatch_client/src/protocol/sector.dart' as _ijaqrtkl;
import 'package:police_dispatch_client/src/protocol/vehicle.dart' as _iadov0ic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'protocol.dart' as _il2as5qe;

/// Handles all dispatch operations and real-time vehicle monitoring.
///
/// This endpoint is the core of the system — it implements the intelligent
/// dispatch algorithm that ensures no sector is left uncovered while
/// responding to incidents as quickly as possible.
/// {@category Endpoint}
class EndpointDispatch extends _isc.EndpointRef {
  EndpointDispatch(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'dispatch';

  /// Opens a persistent stream connection for the dashboard to monitor
  /// all vehicle positions and statuses in real time.
  ///
  /// The stream yields a fresh vehicle list:
  ///   - immediately upon connection (initial state)
  ///   - whenever any vehicle update is broadcast on the 'map-update' channel
  ///
  /// Flutter usage:
  /// ```dart
  /// final stream = client.dispatch.monitorVehicles();
  /// ```
  _ida.Stream<List<_iadov0ic.Vehicle>> monitorVehicles() =>
      caller.callStreamingServerEndpoint<_ida.Stream<List<_iadov0ic.Vehicle>>,
          List<_iadov0ic.Vehicle>>(
        'dispatch',
        'monitorVehicles',
        {},
        {},
      );

  /// Streams sector coverage data (sectorCode → availableVehicleCount).
  /// The dashboard uses this to colour-code sector polygons on the map.
  _ida.Stream<Map<String, int>> monitorSectorCoverage() =>
      caller.callStreamingServerEndpoint<_ida.Stream<Map<String, int>>,
          Map<String, int>>(
        'dispatch',
        'monitorSectorCoverage',
        {},
        {},
      );

  /// Executes the intelligent dispatch algorithm for a new [incident].
  ///
  /// Algorithm (three-phase validation):
  ///
  ///   Phase 1 — Coverage-reserve ranking:
  ///     Prefer the sector that will retain the largest available surplus
  ///     above its minimum coverage after dispatch.
  ///
  ///   Phase 2 — Proximity tie-break:
  ///     Among equally covered sectors, choose the closest vehicle.
  ///
  ///   Phase 3 — Emergency fallback:
  ///     If no sector has a safe surplus, dispatch the closest available unit.
  ///
  /// Returns a [DispatchResult] with success status and ETA.
  _ida.Future<_it223q1i.DispatchResult> requestDispatch(
          _i10daq7i.Incident incident) =>
      caller.callServerEndpoint<_it223q1i.DispatchResult>(
        'dispatch',
        'requestDispatch',
        {'incident': incident},
      );

  /// Returns all sectors with their current vehicle-count summary.
  _ida.Future<List<_ijaqrtkl.Sector>> getAllSectors() =>
      caller.callServerEndpoint<List<_ijaqrtkl.Sector>>(
        'dispatch',
        'getAllSectors',
        {},
      );

  /// Returns all incidents with the given [status].
  /// Valid values: 'open', 'dispatched', 'closed'.
  _ida.Future<List<_i10daq7i.Incident>> getIncidentsByStatus(String status) =>
      caller.callServerEndpoint<List<_i10daq7i.Incident>>(
        'dispatch',
        'getIncidentsByStatus',
        {'status': status},
      );

  /// Closes the active incident and starts the vehicle's return to its
  /// patrol position. It becomes available when the simulation reaches it.
  _ida.Future<void> completeIncident(int vehicleId) =>
      caller.callServerEndpoint<void>(
        'dispatch',
        'completeIncident',
        {'vehicleId': vehicleId},
      );
}

class Client extends _isc.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _isc.MethodCallContext,
      Object,
      StackTrace,
    )? onFailedCall,
    Function(_isc.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
    _i85jenna.Client? httpClientOverride,
  }) : super(
          host,
          _il2as5qe.Protocol(),
          securityContext: securityContext,
          streamingConnectionTimeout: streamingConnectionTimeout,
          connectionTimeout: connectionTimeout,
          onFailedCall: onFailedCall,
          onSucceededCall: onSucceededCall,
          disconnectStreamsOnLostInternetConnection:
              disconnectStreamsOnLostInternetConnection,
          httpClientOverride: httpClientOverride,
        ) {
    dispatch = EndpointDispatch(this);
  }

  late final EndpointDispatch dispatch;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {'dispatch': dispatch};

  @override
  Map<String, _isc.ModuleEndpointCaller> get moduleLookup => {};
}
