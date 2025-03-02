import 'package:flutter_application_2/model/todomodel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TodoDatabase {
  static final TodoDatabase instance = TodoDatabase._init();

  static Database? _database;

  TodoDatabase._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'sqltutorial.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    return await db.execute('''
        CREATE TABLE todo (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          text TEXT NOT NULL,
          datetime TEXT NOT NULL,
          done INTEGER NOT NULL
        )
      ''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future<int> create(Todomodel todo) async {
    final db = await instance.database;
    final id = await db.insert('todo', todo.toMap());
    return id;
  }

  Future<List<Todomodel>> readAllTodo(bool done) async {
    final db = await instance.database;
    //const orderBy = 'datetime ASC';
    //final where = 'done = ${done ? 1 : 0}';
    //final result = await db.query('todo', where: where, orderBy: orderBy);
    final result = await db.query('todo',
        where: 'done = ?', orderBy: 'datetime ASC', whereArgs: [done ? 1 : 0]);
    return result.map((map) => Todomodel.fromMap(map)).toList();
  }

  /*
  Future<List<Map>> todoList(bool done, String descendingOrder) async {
    final db = await instance.database;
    final orderBy = 'datetime $descendingOrder';
    final where = 'done = ${done ? 1 : 0}';
    List<Map> result = await db.query('todo', where: where, orderBy: orderBy);
    return result;
  }
  */

  Future<int> update(Todomodel todo) async {
    final db = await instance.database;
    return db
        .update('todo', todo.toMap(), where: 'id = ?', whereArgs: [todo.id]);
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return db.delete('todo', where: 'id = ?', whereArgs: [id]);
  }
}
