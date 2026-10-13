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

abstract class FireVehicle
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
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
      targetLongitude: (jsonSerialization['targetLongitude'] as num?)
          ?.toDouble(),
      assignedIncidentId: jsonSerialization['assignedIncidentId'] as int?,
    );
  }

  static final t = FireVehicleTable();

  static const db = FireVehicleRepository._();

  @override
  int? id;

  String code;

  String stationCode;

  double latitude;

  double longitude;

  String status;

  double? targetLatitude;

  double? targetLongitude;

  int? assignedIncidentId;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [FireVehicle]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
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

  static FireVehicleInclude include() {
    return FireVehicleInclude._();
  }

  static FireVehicleIncludeList includeList({
    _is.WhereExpressionBuilder<FireVehicleTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FireVehicleTable>? orderBy,
    _is.OrderByListBuilder<FireVehicleTable>? orderByList,
    FireVehicleInclude? include,
  }) {
    return FireVehicleIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FireVehicle.t),
      orderByList: orderByList?.call(FireVehicle.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
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
  @_is.useResult
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
      targetLatitude: targetLatitude is double?
          ? targetLatitude
          : this.targetLatitude,
      targetLongitude: targetLongitude is double?
          ? targetLongitude
          : this.targetLongitude,
      assignedIncidentId: assignedIncidentId is int?
          ? assignedIncidentId
          : this.assignedIncidentId,
    );
  }
}

class FireVehicleUpdateTable extends _is.UpdateTable<FireVehicleTable> {
  FireVehicleUpdateTable(super.table);

  _is.ColumnValue<String, String> code(String value) =>
      _is.ColumnValue(table.code, value);

  _is.ColumnValue<String, String> stationCode(String value) =>
      _is.ColumnValue(table.stationCode, value);

  _is.ColumnValue<double, double> latitude(double value) =>
      _is.ColumnValue(table.latitude, value);

  _is.ColumnValue<double, double> longitude(double value) =>
      _is.ColumnValue(table.longitude, value);

  _is.ColumnValue<String, String> status(String value) =>
      _is.ColumnValue(table.status, value);

  _is.ColumnValue<double, double> targetLatitude(double? value) =>
      _is.ColumnValue(table.targetLatitude, value);

  _is.ColumnValue<double, double> targetLongitude(double? value) =>
      _is.ColumnValue(table.targetLongitude, value);

  _is.ColumnValue<int, int> assignedIncidentId(int? value) =>
      _is.ColumnValue(table.assignedIncidentId, value);
}

class FireVehicleTable extends _is.Table<int?> {
  FireVehicleTable({super.tableRelation}) : super(tableName: 'fire_vehicle') {
    updateTable = FireVehicleUpdateTable(this);
    code = _is.ColumnString('code', this);
    stationCode = _is.ColumnString('stationCode', this);
    latitude = _is.ColumnDouble('latitude', this);
    longitude = _is.ColumnDouble('longitude', this);
    status = _is.ColumnString('status', this);
    targetLatitude = _is.ColumnDouble('targetLatitude', this);
    targetLongitude = _is.ColumnDouble('targetLongitude', this);
    assignedIncidentId = _is.ColumnInt('assignedIncidentId', this);
  }

  late final FireVehicleUpdateTable updateTable;

  late final _is.ColumnString code;

  late final _is.ColumnString stationCode;

  late final _is.ColumnDouble latitude;

  late final _is.ColumnDouble longitude;

  late final _is.ColumnString status;

  late final _is.ColumnDouble targetLatitude;

  late final _is.ColumnDouble targetLongitude;

  late final _is.ColumnInt assignedIncidentId;

  @override
  List<_is.Column> get columns => [
    id,
    code,
    stationCode,
    latitude,
    longitude,
    status,
    targetLatitude,
    targetLongitude,
    assignedIncidentId,
  ];
}

class FireVehicleInclude extends _is.IncludeObject {
  FireVehicleInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => FireVehicle.t;
}

class FireVehicleIncludeList extends _is.IncludeList {
  FireVehicleIncludeList._({
    _is.WhereExpressionBuilder<FireVehicleTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(FireVehicle.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => FireVehicle.t;
}

class FireVehicleRepository {
  const FireVehicleRepository._();

  /// Returns a list of [FireVehicle]s matching the given query parameters.
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
  Future<List<FireVehicle>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FireVehicleTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FireVehicleTable>? orderBy,
    _is.OrderByListBuilder<FireVehicleTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<FireVehicle>(
      where: where?.call(FireVehicle.t),
      orderBy: orderBy?.call(FireVehicle.t),
      orderByList: orderByList?.call(FireVehicle.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [FireVehicle] matching the given query parameters.
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
  Future<FireVehicle?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FireVehicleTable>? where,
    int? offset,
    _is.OrderByBuilder<FireVehicleTable>? orderBy,
    _is.OrderByListBuilder<FireVehicleTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<FireVehicle>(
      where: where?.call(FireVehicle.t),
      orderBy: orderBy?.call(FireVehicle.t),
      orderByList: orderByList?.call(FireVehicle.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [FireVehicle] by its [id] or null if no such row exists.
  Future<FireVehicle?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<FireVehicle>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [FireVehicle]s in the list and returns the inserted rows.
  ///
  /// The returned [FireVehicle]s will have their `id` fields set.
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
  Future<List<FireVehicle>> insert(
    _is.DatabaseSession session,
    List<FireVehicle> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<FireVehicle>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [FireVehicle] and returns the inserted row.
  ///
  /// The returned [FireVehicle] will have its `id` field set.
  Future<FireVehicle> insertRow(
    _is.DatabaseSession session,
    FireVehicle row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<FireVehicle>(row, transaction: transaction);
  }

  /// Upserts all [FireVehicle]s in the list and returns the resulting rows.
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
  /// The returned [FireVehicle]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FireVehicle>> upsert(
    _is.DatabaseSession session,
    List<FireVehicle> rows, {
    required _is.ColumnSelections<FireVehicleTable> conflictColumns,
    _is.ColumnSelections<FireVehicleTable>? updateColumns,
    _is.WhereExpressionBuilder<FireVehicleTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<FireVehicle>(
      rows,
      conflictColumns: conflictColumns(FireVehicle.t),
      updateColumns: updateColumns?.call(FireVehicle.t),
      updateWhere: updateWhere?.call(FireVehicle.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [FireVehicle] and returns the resulting row.
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
  /// The returned [FireVehicle] will have its `id` field set.
  Future<FireVehicle?> upsertRow(
    _is.DatabaseSession session,
    FireVehicle row, {
    required _is.ColumnSelections<FireVehicleTable> conflictColumns,
    _is.ColumnSelections<FireVehicleTable>? updateColumns,
    _is.WhereExpressionBuilder<FireVehicleTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<FireVehicle>(
      row,
      conflictColumns: conflictColumns(FireVehicle.t),
      updateColumns: updateColumns?.call(FireVehicle.t),
      updateWhere: updateWhere?.call(FireVehicle.t),
      transaction: transaction,
    );
  }

  /// Updates all [FireVehicle]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FireVehicle>> update(
    _is.DatabaseSession session,
    List<FireVehicle> rows, {
    _is.ColumnSelections<FireVehicleTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<FireVehicle>(
      rows,
      columns: columns?.call(FireVehicle.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [FireVehicle]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<FireVehicle> updateRow(
    _is.DatabaseSession session,
    FireVehicle row, {
    _is.ColumnSelections<FireVehicleTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<FireVehicle>(
      row,
      columns: columns?.call(FireVehicle.t),
      transaction: transaction,
    );
  }

  /// Updates a single [FireVehicle] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<FireVehicle?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<FireVehicleUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<FireVehicle>(
      id,
      columnValues: columnValues(FireVehicle.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [FireVehicle]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FireVehicle>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<FireVehicleUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<FireVehicleTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FireVehicleTable>? orderBy,
    _is.OrderByListBuilder<FireVehicleTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<FireVehicle>(
      columnValues: columnValues(FireVehicle.t.updateTable),
      where: where(FireVehicle.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FireVehicle.t),
      orderByList: orderByList?.call(FireVehicle.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [FireVehicle]s in the list and returns the deleted rows.
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
  Future<List<FireVehicle>> delete(
    _is.DatabaseSession session,
    List<FireVehicle> rows, {
    _is.OrderByBuilder<FireVehicleTable>? orderBy,
    _is.OrderByListBuilder<FireVehicleTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<FireVehicle>(
      rows,
      orderBy: orderBy?.call(FireVehicle.t),
      orderByList: orderByList?.call(FireVehicle.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [FireVehicle].
  Future<FireVehicle> deleteRow(
    _is.DatabaseSession session,
    FireVehicle row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<FireVehicle>(row, transaction: transaction);
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FireVehicle>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<FireVehicleTable> where,
    _is.OrderByBuilder<FireVehicleTable>? orderBy,
    _is.OrderByListBuilder<FireVehicleTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<FireVehicle>(
      where: where(FireVehicle.t),
      orderBy: orderBy?.call(FireVehicle.t),
      orderByList: orderByList?.call(FireVehicle.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FireVehicleTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<FireVehicle>(
      where: where?.call(FireVehicle.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [FireVehicle] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<FireVehicleTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<FireVehicle>(
      where: where(FireVehicle.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
