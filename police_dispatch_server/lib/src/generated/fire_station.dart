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

abstract class FireStation
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
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

  static final t = FireStationTable();

  static const db = FireStationRepository._();

  @override
  int? id;

  String stationCode;

  String name;

  double latitude;

  double longitude;

  String osmType;

  String osmId;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [FireStation]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
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

  static FireStationInclude include() {
    return FireStationInclude._();
  }

  static FireStationIncludeList includeList({
    _is.WhereExpressionBuilder<FireStationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FireStationTable>? orderBy,
    _is.OrderByListBuilder<FireStationTable>? orderByList,
    FireStationInclude? include,
  }) {
    return FireStationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FireStation.t),
      orderByList: orderByList?.call(FireStation.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
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
  @_is.useResult
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

class FireStationUpdateTable extends _is.UpdateTable<FireStationTable> {
  FireStationUpdateTable(super.table);

  _is.ColumnValue<String, String> stationCode(String value) =>
      _is.ColumnValue(table.stationCode, value);

  _is.ColumnValue<String, String> name(String value) =>
      _is.ColumnValue(table.name, value);

  _is.ColumnValue<double, double> latitude(double value) =>
      _is.ColumnValue(table.latitude, value);

  _is.ColumnValue<double, double> longitude(double value) =>
      _is.ColumnValue(table.longitude, value);

  _is.ColumnValue<String, String> osmType(String value) =>
      _is.ColumnValue(table.osmType, value);

  _is.ColumnValue<String, String> osmId(String value) =>
      _is.ColumnValue(table.osmId, value);
}

class FireStationTable extends _is.Table<int?> {
  FireStationTable({super.tableRelation}) : super(tableName: 'fire_station') {
    updateTable = FireStationUpdateTable(this);
    stationCode = _is.ColumnString('stationCode', this);
    name = _is.ColumnString('name', this);
    latitude = _is.ColumnDouble('latitude', this);
    longitude = _is.ColumnDouble('longitude', this);
    osmType = _is.ColumnString('osmType', this);
    osmId = _is.ColumnString('osmId', this);
  }

  late final FireStationUpdateTable updateTable;

  late final _is.ColumnString stationCode;

  late final _is.ColumnString name;

  late final _is.ColumnDouble latitude;

  late final _is.ColumnDouble longitude;

  late final _is.ColumnString osmType;

  late final _is.ColumnString osmId;

  @override
  List<_is.Column> get columns => [
    id,
    stationCode,
    name,
    latitude,
    longitude,
    osmType,
    osmId,
  ];
}

class FireStationInclude extends _is.IncludeObject {
  FireStationInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => FireStation.t;
}

class FireStationIncludeList extends _is.IncludeList {
  FireStationIncludeList._({
    _is.WhereExpressionBuilder<FireStationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(FireStation.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => FireStation.t;
}

class FireStationRepository {
  const FireStationRepository._();

  /// Returns a list of [FireStation]s matching the given query parameters.
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
  Future<List<FireStation>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FireStationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FireStationTable>? orderBy,
    _is.OrderByListBuilder<FireStationTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<FireStation>(
      where: where?.call(FireStation.t),
      orderBy: orderBy?.call(FireStation.t),
      orderByList: orderByList?.call(FireStation.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [FireStation] matching the given query parameters.
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
  Future<FireStation?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FireStationTable>? where,
    int? offset,
    _is.OrderByBuilder<FireStationTable>? orderBy,
    _is.OrderByListBuilder<FireStationTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<FireStation>(
      where: where?.call(FireStation.t),
      orderBy: orderBy?.call(FireStation.t),
      orderByList: orderByList?.call(FireStation.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [FireStation] by its [id] or null if no such row exists.
  Future<FireStation?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<FireStation>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [FireStation]s in the list and returns the inserted rows.
  ///
  /// The returned [FireStation]s will have their `id` fields set.
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
  Future<List<FireStation>> insert(
    _is.DatabaseSession session,
    List<FireStation> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<FireStation>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [FireStation] and returns the inserted row.
  ///
  /// The returned [FireStation] will have its `id` field set.
  Future<FireStation> insertRow(
    _is.DatabaseSession session,
    FireStation row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<FireStation>(row, transaction: transaction);
  }

  /// Upserts all [FireStation]s in the list and returns the resulting rows.
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
  /// The returned [FireStation]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FireStation>> upsert(
    _is.DatabaseSession session,
    List<FireStation> rows, {
    required _is.ColumnSelections<FireStationTable> conflictColumns,
    _is.ColumnSelections<FireStationTable>? updateColumns,
    _is.WhereExpressionBuilder<FireStationTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<FireStation>(
      rows,
      conflictColumns: conflictColumns(FireStation.t),
      updateColumns: updateColumns?.call(FireStation.t),
      updateWhere: updateWhere?.call(FireStation.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [FireStation] and returns the resulting row.
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
  /// The returned [FireStation] will have its `id` field set.
  Future<FireStation?> upsertRow(
    _is.DatabaseSession session,
    FireStation row, {
    required _is.ColumnSelections<FireStationTable> conflictColumns,
    _is.ColumnSelections<FireStationTable>? updateColumns,
    _is.WhereExpressionBuilder<FireStationTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<FireStation>(
      row,
      conflictColumns: conflictColumns(FireStation.t),
      updateColumns: updateColumns?.call(FireStation.t),
      updateWhere: updateWhere?.call(FireStation.t),
      transaction: transaction,
    );
  }

  /// Updates all [FireStation]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FireStation>> update(
    _is.DatabaseSession session,
    List<FireStation> rows, {
    _is.ColumnSelections<FireStationTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<FireStation>(
      rows,
      columns: columns?.call(FireStation.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [FireStation]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<FireStation> updateRow(
    _is.DatabaseSession session,
    FireStation row, {
    _is.ColumnSelections<FireStationTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<FireStation>(
      row,
      columns: columns?.call(FireStation.t),
      transaction: transaction,
    );
  }

  /// Updates a single [FireStation] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<FireStation?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<FireStationUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<FireStation>(
      id,
      columnValues: columnValues(FireStation.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [FireStation]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FireStation>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<FireStationUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<FireStationTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FireStationTable>? orderBy,
    _is.OrderByListBuilder<FireStationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<FireStation>(
      columnValues: columnValues(FireStation.t.updateTable),
      where: where(FireStation.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FireStation.t),
      orderByList: orderByList?.call(FireStation.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [FireStation]s in the list and returns the deleted rows.
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
  Future<List<FireStation>> delete(
    _is.DatabaseSession session,
    List<FireStation> rows, {
    _is.OrderByBuilder<FireStationTable>? orderBy,
    _is.OrderByListBuilder<FireStationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<FireStation>(
      rows,
      orderBy: orderBy?.call(FireStation.t),
      orderByList: orderByList?.call(FireStation.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [FireStation].
  Future<FireStation> deleteRow(
    _is.DatabaseSession session,
    FireStation row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<FireStation>(row, transaction: transaction);
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FireStation>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<FireStationTable> where,
    _is.OrderByBuilder<FireStationTable>? orderBy,
    _is.OrderByListBuilder<FireStationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<FireStation>(
      where: where(FireStation.t),
      orderBy: orderBy?.call(FireStation.t),
      orderByList: orderByList?.call(FireStation.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FireStationTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<FireStation>(
      where: where?.call(FireStation.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [FireStation] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<FireStationTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<FireStation>(
      where: where(FireStation.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
