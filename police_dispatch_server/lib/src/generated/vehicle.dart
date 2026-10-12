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

/// Vehicle model
/// Represents a police patrol vehicle with real-time GPS position and status.
abstract class Vehicle
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
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
      targetLongitude: (jsonSerialization['targetLongitude'] as num?)
          ?.toDouble(),
      patrolLatitude: (jsonSerialization['patrolLatitude'] as num?)?.toDouble(),
      patrolLongitude: (jsonSerialization['patrolLongitude'] as num?)
          ?.toDouble(),
      assignedIncidentId: jsonSerialization['assignedIncidentId'] as int?,
    );
  }

  static final t = VehicleTable();

  static const db = VehicleRepository._();

  @override
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

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Vehicle]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
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

  static VehicleInclude include() {
    return VehicleInclude._();
  }

  static VehicleIncludeList includeList({
    _is.WhereExpressionBuilder<VehicleTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<VehicleTable>? orderBy,
    _is.OrderByListBuilder<VehicleTable>? orderByList,
    VehicleInclude? include,
  }) {
    return VehicleIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Vehicle.t),
      orderByList: orderByList?.call(Vehicle.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
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
  @_is.useResult
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
      targetLatitude: targetLatitude is double?
          ? targetLatitude
          : this.targetLatitude,
      targetLongitude: targetLongitude is double?
          ? targetLongitude
          : this.targetLongitude,
      patrolLatitude: patrolLatitude is double?
          ? patrolLatitude
          : this.patrolLatitude,
      patrolLongitude: patrolLongitude is double?
          ? patrolLongitude
          : this.patrolLongitude,
      assignedIncidentId: assignedIncidentId is int?
          ? assignedIncidentId
          : this.assignedIncidentId,
    );
  }
}

class VehicleUpdateTable extends _is.UpdateTable<VehicleTable> {
  VehicleUpdateTable(super.table);

  _is.ColumnValue<String, String> code(String value) =>
      _is.ColumnValue(table.code, value);

  _is.ColumnValue<double, double> latitude(double value) =>
      _is.ColumnValue(table.latitude, value);

  _is.ColumnValue<double, double> longitude(double value) =>
      _is.ColumnValue(table.longitude, value);

  _is.ColumnValue<String, String> status(String value) =>
      _is.ColumnValue(table.status, value);

  _is.ColumnValue<String, String> currentSector(String value) =>
      _is.ColumnValue(table.currentSector, value);

  _is.ColumnValue<double, double> targetLatitude(double? value) =>
      _is.ColumnValue(table.targetLatitude, value);

  _is.ColumnValue<double, double> targetLongitude(double? value) =>
      _is.ColumnValue(table.targetLongitude, value);

  _is.ColumnValue<double, double> patrolLatitude(double? value) =>
      _is.ColumnValue(table.patrolLatitude, value);

  _is.ColumnValue<double, double> patrolLongitude(double? value) =>
      _is.ColumnValue(table.patrolLongitude, value);

  _is.ColumnValue<int, int> assignedIncidentId(int? value) =>
      _is.ColumnValue(table.assignedIncidentId, value);
}

class VehicleTable extends _is.Table<int?> {
  VehicleTable({super.tableRelation}) : super(tableName: 'vehicle') {
    updateTable = VehicleUpdateTable(this);
    code = _is.ColumnString('code', this);
    latitude = _is.ColumnDouble('latitude', this);
    longitude = _is.ColumnDouble('longitude', this);
    status = _is.ColumnString('status', this);
    currentSector = _is.ColumnString('currentSector', this);
    targetLatitude = _is.ColumnDouble('targetLatitude', this);
    targetLongitude = _is.ColumnDouble('targetLongitude', this);
    patrolLatitude = _is.ColumnDouble('patrolLatitude', this);
    patrolLongitude = _is.ColumnDouble('patrolLongitude', this);
    assignedIncidentId = _is.ColumnInt('assignedIncidentId', this);
  }

  late final VehicleUpdateTable updateTable;

  late final _is.ColumnString code;

  late final _is.ColumnDouble latitude;

  late final _is.ColumnDouble longitude;

  late final _is.ColumnString status;

  late final _is.ColumnString currentSector;

  late final _is.ColumnDouble targetLatitude;

  late final _is.ColumnDouble targetLongitude;

  late final _is.ColumnDouble patrolLatitude;

  late final _is.ColumnDouble patrolLongitude;

  late final _is.ColumnInt assignedIncidentId;

  @override
  List<_is.Column> get columns => [
    id,
    code,
    latitude,
    longitude,
    status,
    currentSector,
    targetLatitude,
    targetLongitude,
    patrolLatitude,
    patrolLongitude,
    assignedIncidentId,
  ];
}

class VehicleInclude extends _is.IncludeObject {
  VehicleInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Vehicle.t;
}

class VehicleIncludeList extends _is.IncludeList {
  VehicleIncludeList._({
    _is.WhereExpressionBuilder<VehicleTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Vehicle.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Vehicle.t;
}

class VehicleRepository {
  const VehicleRepository._();

  /// Returns a list of [Vehicle]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Vehicle>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<VehicleTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<VehicleTable>? orderBy,
    _is.OrderByListBuilder<VehicleTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Vehicle>(
      where: where?.call(Vehicle.t),
      orderBy: orderBy?.call(Vehicle.t),
      orderByList: orderByList?.call(Vehicle.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Vehicle] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Vehicle?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<VehicleTable>? where,
    int? offset,
    _is.OrderByBuilder<VehicleTable>? orderBy,
    _is.OrderByListBuilder<VehicleTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Vehicle>(
      where: where?.call(Vehicle.t),
      orderBy: orderBy?.call(Vehicle.t),
      orderByList: orderByList?.call(Vehicle.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Vehicle] by its [id] or null if no such row exists.
  Future<Vehicle?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Vehicle>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Vehicle]s in the list and returns the inserted rows.
  ///
  /// The returned [Vehicle]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Vehicle>> insert(
    _is.DatabaseSession session,
    List<Vehicle> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Vehicle>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Vehicle] and returns the inserted row.
  ///
  /// The returned [Vehicle] will have its `id` field set.
  Future<Vehicle> insertRow(
    _is.DatabaseSession session,
    Vehicle row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Vehicle>(row, transaction: transaction);
  }

  /// Upserts all [Vehicle]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [Vehicle]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Vehicle>> upsert(
    _is.DatabaseSession session,
    List<Vehicle> rows, {
    required _is.ColumnSelections<VehicleTable> conflictColumns,
    _is.ColumnSelections<VehicleTable>? updateColumns,
    _is.WhereExpressionBuilder<VehicleTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Vehicle>(
      rows,
      conflictColumns: conflictColumns(Vehicle.t),
      updateColumns: updateColumns?.call(Vehicle.t),
      updateWhere: updateWhere?.call(Vehicle.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Vehicle] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [Vehicle] will have its `id` field set.
  Future<Vehicle?> upsertRow(
    _is.DatabaseSession session,
    Vehicle row, {
    required _is.ColumnSelections<VehicleTable> conflictColumns,
    _is.ColumnSelections<VehicleTable>? updateColumns,
    _is.WhereExpressionBuilder<VehicleTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Vehicle>(
      row,
      conflictColumns: conflictColumns(Vehicle.t),
      updateColumns: updateColumns?.call(Vehicle.t),
      updateWhere: updateWhere?.call(Vehicle.t),
      transaction: transaction,
    );
  }

  /// Updates all [Vehicle]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Vehicle>> update(
    _is.DatabaseSession session,
    List<Vehicle> rows, {
    _is.ColumnSelections<VehicleTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Vehicle>(
      rows,
      columns: columns?.call(Vehicle.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Vehicle]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Vehicle> updateRow(
    _is.DatabaseSession session,
    Vehicle row, {
    _is.ColumnSelections<VehicleTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Vehicle>(
      row,
      columns: columns?.call(Vehicle.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Vehicle] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Vehicle?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<VehicleUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Vehicle>(
      id,
      columnValues: columnValues(Vehicle.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Vehicle]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Vehicle>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<VehicleUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<VehicleTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<VehicleTable>? orderBy,
    _is.OrderByListBuilder<VehicleTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Vehicle>(
      columnValues: columnValues(Vehicle.t.updateTable),
      where: where(Vehicle.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Vehicle.t),
      orderByList: orderByList?.call(Vehicle.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Vehicle]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Vehicle>> delete(
    _is.DatabaseSession session,
    List<Vehicle> rows, {
    _is.OrderByBuilder<VehicleTable>? orderBy,
    _is.OrderByListBuilder<VehicleTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Vehicle>(
      rows,
      orderBy: orderBy?.call(Vehicle.t),
      orderByList: orderByList?.call(Vehicle.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Vehicle].
  Future<Vehicle> deleteRow(
    _is.DatabaseSession session,
    Vehicle row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Vehicle>(row, transaction: transaction);
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Vehicle>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<VehicleTable> where,
    _is.OrderByBuilder<VehicleTable>? orderBy,
    _is.OrderByListBuilder<VehicleTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Vehicle>(
      where: where(Vehicle.t),
      orderBy: orderBy?.call(Vehicle.t),
      orderByList: orderByList?.call(Vehicle.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<VehicleTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Vehicle>(
      where: where?.call(Vehicle.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Vehicle] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<VehicleTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Vehicle>(
      where: where(Vehicle.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
