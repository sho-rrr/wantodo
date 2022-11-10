import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wantodo/model/entity/wantodo.dart';

class AppDatabase {
  final String _tableName = 'Wantodo';
  final String _columnId = 'id';
  final String _columnTitle = 'title';
  final String _columnDetail = 'detail';
  final String _columnStatus = 'status';
  final String _columnCreatedAt = 'created_at';
  final String _columnDoneAt = 'done_at';

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'wantodo.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTable,
    );
  }

  Future<void> _createTable(Database db, int version) async {
    String sql = '''
      CREATE TABLE $_tableName(
        $_columnId TEXT PRIMARY KEY,
        $_columnTitle TEXT,
        $_columnDetail TEXT,
        $_columnStatus TEXT,
        $_columnCreatedAt TEXT,
        $_columnDoneAt TEXT
      )
    ''';

    return await db.execute(sql);
  }

  Future<List<Wantodo>> loadAllWantodo() async {
    final db = await database;
    var maps = await db.query(
      _tableName,
      orderBy: '$_columnCreatedAt DESC',
    );

    if (maps.isEmpty) return [];

    return maps.map((map) => fromMap(map)).toList();
  }

  Future<List<Wantodo>> search(String keyword) async {
    final db = await database;
    var maps = await db.query(
      _tableName,
      orderBy: '$_columnCreatedAt DESC',
      where: '$_columnTitle LIKE ?',
      whereArgs: ['%$keyword%'],
    );

    if (maps.isEmpty) return [];

    return maps.map((map) => fromMap(map)).toList();
  }

  Future insert(Wantodo wantodo) async {
    final db = await database;
    return await db.insert(_tableName, toMap(wantodo));
  }

  Future update(Wantodo wantodo) async {
    final db = await database;
    return await db.update(
      _tableName,
      toMap(wantodo),
      where: '$_columnId = ?',
      whereArgs: [wantodo.id],
    );
  }

  Future delete(Wantodo wantodo) async {
    final db = await database;
    return await db.delete(
      _tableName,
      where: '$_columnId = ?',
      whereArgs: [wantodo.id],
    );
  }

  Map<String, dynamic> toMap(Wantodo wantodo) {
    return {
      _columnId: wantodo.id,
      _columnTitle: wantodo.title,
      _columnDetail: wantodo.detail,
      _columnStatus: wantodo.status,
      _columnCreatedAt: wantodo.createdAt.toUtc().toIso8601String(),
      _columnDoneAt: wantodo.doneAt?.toUtc().toIso8601String()
    };
  }

  Wantodo fromMap(Map<String, dynamic> json) {
    return Wantodo(
      id: json[_columnId],
      title: json[_columnTitle],
      detail: json[_columnDetail],
      status: json[_columnStatus],
      createdAt: DateTime.parse(json[_columnCreatedAt]).toLocal(),
      doneAt: json[_columnDoneAt] != null ? DateTime.parse(json[_columnDoneAt]).toLocal() : null
    );
  }
}