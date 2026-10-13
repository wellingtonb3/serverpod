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
import 'package:police_dispatch_server/src/generated/incident.dart'
    as _ij8xcy4q;
import 'package:serverpod/serverpod.dart' as _is;
import '../endpoints/dispatch_endpoint.dart' as _i67rg7lj;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
      'dispatch': _i67rg7lj.DispatchEndpoint()
        ..initialize(server, 'dispatch', null),
    };
    connectors['dispatch'] = _is.EndpointConnector(
      name: 'dispatch',
      endpoint: endpoints['dispatch']!,
      methodConnectors: {
        'requestDispatch': _is.MethodConnector(
          name: 'requestDispatch',
          params: {
            'incident': _is.ParameterDescription(
              name: 'incident',
              type: _is.getType<_ij8xcy4q.Incident>(),
              nullable: false,
            ),
          },
          call: (_is.Session session, Map<String, dynamic> params) async =>
              (endpoints['dispatch'] as _i67rg7lj.DispatchEndpoint)
                  .requestDispatch(session, params['incident']),
        ),
        'getAllSectors': _is.MethodConnector(
          name: 'getAllSectors',
          params: {},
          call: (_is.Session session, Map<String, dynamic> params) async =>
              (endpoints['dispatch'] as _i67rg7lj.DispatchEndpoint)
                  .getAllSectors(session),
        ),
        'getAllFireStations': _is.MethodConnector(
          name: 'getAllFireStations',
          params: {},
          call: (_is.Session session, Map<String, dynamic> params) async =>
              (endpoints['dispatch'] as _i67rg7lj.DispatchEndpoint)
                  .getAllFireStations(session),
        ),
        'getIncidentsByStatus': _is.MethodConnector(
          name: 'getIncidentsByStatus',
          params: {
            'status': _is.ParameterDescription(
              name: 'status',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call: (_is.Session session, Map<String, dynamic> params) async =>
              (endpoints['dispatch'] as _i67rg7lj.DispatchEndpoint)
                  .getIncidentsByStatus(session, params['status']),
        ),
        'completeIncident': _is.MethodConnector(
          name: 'completeIncident',
          params: {
            'vehicleId': _is.ParameterDescription(
              name: 'vehicleId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call: (_is.Session session, Map<String, dynamic> params) async =>
              (endpoints['dispatch'] as _i67rg7lj.DispatchEndpoint)
                  .completeIncident(session, params['vehicleId']),
        ),
        'completeFireIncident': _is.MethodConnector(
          name: 'completeFireIncident',
          params: {
            'fireVehicleId': _is.ParameterDescription(
              name: 'fireVehicleId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call: (_is.Session session, Map<String, dynamic> params) async =>
              (endpoints['dispatch'] as _i67rg7lj.DispatchEndpoint)
                  .completeFireIncident(session, params['fireVehicleId']),
        ),
        'monitorVehicles': _is.MethodStreamConnector(
          name: 'monitorVehicles',
          params: {},
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['dispatch'] as _i67rg7lj.DispatchEndpoint)
                  .monitorVehicles(session),
        ),
        'monitorFireVehicles': _is.MethodStreamConnector(
          name: 'monitorFireVehicles',
          params: {},
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['dispatch'] as _i67rg7lj.DispatchEndpoint)
                  .monitorFireVehicles(session),
        ),
        'monitorSectorCoverage': _is.MethodStreamConnector(
          name: 'monitorSectorCoverage',
          params: {},
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['dispatch'] as _i67rg7lj.DispatchEndpoint)
                  .monitorSectorCoverage(session),
        ),
      },
    );
  }
}
