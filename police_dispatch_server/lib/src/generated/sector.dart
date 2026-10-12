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

/// Sector model
/// Represents a geographic patrol zone within the city.
abstract class Sector implements _is.TableRow<int?>, _is.ProtocolSerialization {
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

  static final t = SectorTable();

  static const db = SectorRepository._();

  @override
  int? id;

  String name;

  String sectorCode;

  double centerLatitude;

  double centerLongitude;

  int minimumVehicles;

  String boundaryGeoJson;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Sector]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
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

  static SectorInclude include() {
    return SectorInclude._();
  }

  static SectorIncludeList includeList({
    _is.WhereExpressionBuilder<SectorTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SectorTable>? orderBy,
    _is.OrderByListBuilder<SectorTable>? orderByList,
    SectorInclude? include,
  }) {
    return SectorIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Sector.t),
      orderByList: orderByList?.call(Sector.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
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
  @_is.useResult
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

class SectorUpdateTable extends _is.UpdateTable<SectorTable> {
  SectorUpdateTable(super.table);

  _is.ColumnValue<String, String> name(String value) =>
      _is.ColumnValue(table.name, value);

  _is.ColumnValue<String, String> sectorCode(String value) =>
      _is.ColumnValue(table.sectorCode, value);

  _is.ColumnValue<double, double> centerLatitude(double value) =>
      _is.ColumnValue(table.centerLatitude, value);

  _is.ColumnValue<double, double> centerLongitude(double value) =>
      _is.ColumnValue(table.centerLongitude, value);

  _is.ColumnValue<int, int> minimumVehicles(int value) =>
      _is.ColumnValue(table.minimumVehicles, value);

  _is.ColumnValue<String, String> boundaryGeoJson(String value) =>
      _is.ColumnValue(table.boundaryGeoJson, value);
}

class SectorTable extends _is.Table<int?> {
  SectorTable({super.tableRelation}) : super(tableName: 'sector') {
    updateTable = SectorUpdateTable(this);
    name = _is.ColumnString('name', this);
    sectorCode = _is.ColumnString('sectorCode', this);
    centerLatitude = _is.ColumnDouble('centerLatitude', this);
    centerLongitude = _is.ColumnDouble('centerLongitude', this);
    minimumVehicles = _is.ColumnInt('minimumVehicles', this);
    boundaryGeoJson = _is.ColumnString('boundaryGeoJson', this);
  }

  late final SectorUpdateTable updateTable;

  late final _is.ColumnString name;

  late final _is.ColumnString sectorCode;

  late final _is.ColumnDouble centerLatitude;

  late final _is.ColumnDouble centerLongitude;

  late final _is.ColumnInt minimumVehicles;

  late final _is.ColumnString boundaryGeoJson;

  @override
  List<_is.Column> get columns => [
    id,
    name,
    sectorCode,
    centerLatitude,
    centerLongitude,
    minimumVehicles,
    boundaryGeoJson,
  ];
}

class SectorInclude extends _is.IncludeObject {
  SectorInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Sector.t;
}

class SectorIncludeList extends _is.IncludeList {
  SectorIncludeList._({
    _is.WhereExpressionBuilder<SectorTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Sector.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Sector.t;
}

class SectorRepository {
  const SectorRepository._();

  /// Returns a list of [Sector]s matching the given query parameters.
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
  Future<List<Sector>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SectorTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SectorTable>? orderBy,
    _is.OrderByListBuilder<SectorTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Sector>(
      where: where?.call(Sector.t),
      orderBy: orderBy?.call(Sector.t),
      orderByList: orderByList?.call(Sector.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Sector] matching the given query parameters.
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
  Future<Sector?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SectorTable>? where,
    int? offset,
    _is.OrderByBuilder<SectorTable>? orderBy,
    _is.OrderByListBuilder<SectorTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Sector>(
      where: where?.call(Sector.t),
      orderBy: orderBy?.call(Sector.t),
      orderByList: orderByList?.call(Sector.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Sector] by its [id] or null if no such row exists.
  Future<Sector?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Sector>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Sector]s in the list and returns the inserted rows.
  ///
  /// The returned [Sector]s will have their `id` fields set.
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
  Future<List<Sector>> insert(
    _is.DatabaseSession session,
    List<Sector> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Sector>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Sector] and returns the inserted row.
  ///
  /// The returned [Sector] will have its `id` field set.
  Future<Sector> insertRow(
    _is.DatabaseSession session,
    Sector row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Sector>(row, transaction: transaction);
  }

  /// Upserts all [Sector]s in the list and returns the resulting rows.
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
  /// The returned [Sector]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Sector>> upsert(
    _is.DatabaseSession session,
    List<Sector> rows, {
    required _is.ColumnSelections<SectorTable> conflictColumns,
    _is.ColumnSelections<SectorTable>? updateColumns,
    _is.WhereExpressionBuilder<SectorTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Sector>(
      rows,
      conflictColumns: conflictColumns(Sector.t),
      updateColumns: updateColumns?.call(Sector.t),
      updateWhere: updateWhere?.call(Sector.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Sector] and returns the resulting row.
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
  /// The returned [Sector] will have its `id` field set.
  Future<Sector?> upsertRow(
    _is.DatabaseSession session,
    Sector row, {
    required _is.ColumnSelections<SectorTable> conflictColumns,
    _is.ColumnSelections<SectorTable>? updateColumns,
    _is.WhereExpressionBuilder<SectorTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Sector>(
      row,
      conflictColumns: conflictColumns(Sector.t),
      updateColumns: updateColumns?.call(Sector.t),
      updateWhere: updateWhere?.call(Sector.t),
      transaction: transaction,
    );
  }

  /// Updates all [Sector]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Sector>> update(
    _is.DatabaseSession session,
    List<Sector> rows, {
    _is.ColumnSelections<SectorTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Sector>(
      rows,
      columns: columns?.call(Sector.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Sector]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Sector> updateRow(
    _is.DatabaseSession session,
    Sector row, {
    _is.ColumnSelections<SectorTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Sector>(
      row,
      columns: columns?.call(Sector.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Sector] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Sector?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<SectorUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Sector>(
      id,
      columnValues: columnValues(Sector.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Sector]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Sector>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<SectorUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<SectorTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SectorTable>? orderBy,
    _is.OrderByListBuilder<SectorTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Sector>(
      columnValues: columnValues(Sector.t.updateTable),
      where: where(Sector.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Sector.t),
      orderByList: orderByList?.call(Sector.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Sector]s in the list and returns the deleted rows.
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
  Future<List<Sector>> delete(
    _is.DatabaseSession session,
    List<Sector> rows, {
    _is.OrderByBuilder<SectorTable>? orderBy,
    _is.OrderByListBuilder<SectorTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Sector>(
      rows,
      orderBy: orderBy?.call(Sector.t),
      orderByList: orderByList?.call(Sector.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Sector].
  Future<Sector> deleteRow(
    _is.DatabaseSession session,
    Sector row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Sector>(row, transaction: transaction);
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Sector>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SectorTable> where,
    _is.OrderByBuilder<SectorTable>? orderBy,
    _is.OrderByListBuilder<SectorTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Sector>(
      where: where(Sector.t),
      orderBy: orderBy?.call(Sector.t),
      orderByList: orderByList?.call(Sector.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SectorTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Sector>(
      where: where?.call(Sector.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Sector] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SectorTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Sector>(
      where: where(Sector.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
