import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'modelo.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), 'my_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE $table (
            ${ModelDataBase.id} INTEGER PRIMARY KEY AUTOINCREMENT,
            ${ModelDataBase.ruta} TEXT,
            ${ModelDataBase.startLng} REAL,
            ${ModelDataBase.startLat} REAL,
            ${ModelDataBase.endLng} REAL,
            ${ModelDataBase.endLat} REAL
          )
        ''');
      },
    );
  }

  Future<void> insertModel(Model model) async {
    final db = await database;
    await db.insert(table, model.toJson());
  }

  Future<List<Model>> getModels() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(table);

    return List.generate(maps.length, (i) {
      return Model(
        id: maps[i][ModelDataBase.id],
        ruta: maps[i][ModelDataBase.ruta],
        startLng: maps[i][ModelDataBase.startLng],
        startLat: maps[i][ModelDataBase.startLat],
        endLng: maps[i][ModelDataBase.endLng],
        endLat: maps[i][ModelDataBase.endLat],
      );
    });
  }

  Future<void> deleteAllModels() async {
    final db = await database;
    await db.delete(table);
  }

  Future<void> updateModel(Model model) async {
    final db = await database;
    await db.update(
      table,
      model.toJson(),
      where: '${ModelDataBase.id} = ?',
      whereArgs: [model.id],
    );
  }

  Future<void> deleteModel(int id) async {
    final db = await database;
    await db.delete(
      table,
      where: '${ModelDataBase.id} = ?',
      whereArgs: [id],
    );
  }
}
