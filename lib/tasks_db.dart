import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'package:todo_tasks/models/task_model.dart';

class TasksDatabase {
  static final TasksDatabase instance = TasksDatabase._init();
  static Database? _database;
  TasksDatabase._init();

  Future<Database> get database async {
    sqfliteFfiInit();
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    var databaseFactory = databaseFactoryFfi;
    var databasePath = await getApplicationDocumentsDirectory();
    final path = join(databasePath.path, filePath);
    return await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: _createDB,
        onOpen: (db) {
          print(
              'TasksDatabase: Database opened at ${databasePath.path}/$filePath');
        },
        singleInstance: true,
        onConfigure: (db) {
          print('TasksDatabase: Database configured');
        },
        onDowngrade: (db, oldVersion, newVersion) {
          print('TasksDatabase: Database downgraded');
        },
        onUpgrade: (db, oldVersion, newVersion) {
          print('TasksDatabase: Database upgraded');
        },
        readOnly: false,
      ),
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute(
      '''
        CREATE TABLE $tableQrResults (
          ${TasksFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${TasksFields.name} TEXT NOT NULL,
          ${TasksFields.description} TEXT NOT NULL,
          ${TasksFields.completed} INTEGER NOT NULL,
          ${TasksFields.date} TEXT NOT NULL,
          ${TasksFields.starred} INTEGER NOT NULL)''',
    );
  }

  Future<Task> create(Task task) async {
    final db = await instance.database;
    final id = await db.insert(
      tableQrResults,
      task.toMap(),
    );
    return task.copy(id: id);
  }

  Future<Task> readTask(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableQrResults,
      columns: TasksFields.values,
      where: '${TasksFields.id} = ?',
      whereArgs: [id],
    );
    return maps.isNotEmpty
        ? Task.fromMap(maps.first)
        : throw Exception('No results found');
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableQrResults,
      where: '${TasksFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<List<Task>> readAllTasks() async {
    final db = await instance.database;
    final results =
        await db.query(tableQrResults, orderBy: '${TasksFields.date} ASC');
    return results.map((json) => Task.fromMap(json)).toList();
  }

  Future close() async {
    var db = await instance.database;
    return db.close();
  }

  Future<int> update(Task task) async {
    final db = await instance.database;
    return await db.update(
      tableQrResults,
      task.toMap(),
      where: '${TasksFields.id} = ?',
      whereArgs: [task.id],
    );
  }
}
