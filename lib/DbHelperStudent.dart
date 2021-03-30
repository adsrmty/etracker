import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'student.dart';

class DbHelperStudent {
  static final DbHelperStudent _instance = new DbHelperStudent.internal();

  factory DbHelperStudent() => _instance;

  final String databaseName = 'etracker.db';
  final String tableStudent = 'studentTable';
  final String columnId = 'id';
  final String columnPickupKey = 'pickupKey';
  final String columnSchoolKey = 'schoolKey';
  final String columnName = 'name';
  final String columnSchool = 'school';
  final String columnSchedule = 'schedule';
  final String columnExpire = 'expire';

  static Database _db;

  DbHelperStudent.internal();

  Future<Database> get getDb async {
    if (_db == null) {
      _db = await _initDb();
      _createDbTable();
    }
    return _db;
  }

  Future<void> _createDbTable() async{
    await _db.execute(
        'CREATE TABLE IF NOT EXISTS $tableStudent($columnId INTEGER PRIMARY KEY, $columnPickupKey TEXT, $columnSchoolKey TEXT, $columnName TEXT, $columnSchool TEXT deded, $columnSchedule TEXT, $columnExpire TEXT)');
  }

  _initDb() async {
    print('initDb()');
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, databaseName);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    print('_onCreate Student Table');
    await db.execute(
        'CREATE TABLE $tableStudent($columnId INTEGER PRIMARY KEY, $columnPickupKey TEXT, $columnSchoolKey TEXT, $columnName TEXT, $columnSchool TEXT, $columnSchedule TEXT, $columnExpire TEXT)');
  }

  Future<int> saveStudent(Student student) async {
    print('saveStudent()');
    var dbClient = await getDb;
    var result = await dbClient.insert(tableStudent, student.toMap());
    return result;
  }

  Future<List> getAllStudents() async {
    print('getAllStudents()');
    var dbClient = await getDb;
    var result = await dbClient.query(tableStudent, columns: [columnId, columnPickupKey, columnSchoolKey, columnName, columnSchool, columnSchedule, columnExpire]);
    return result.toList();
  }

  Future<int> getCount() async {
    var dbClient = await getDb;
    return Sqflite.firstIntValue(await dbClient.rawQuery('SELECT COUNT(*) FROM $tableStudent'));
  }

  Future<Student> getStudent(int id) async {
    var dbClient = await getDb;
    List<Map> result = await dbClient.query(tableStudent,
        columns: [columnId, columnPickupKey, columnSchoolKey, columnName, columnSchool, columnSchedule, columnExpire],
        where: '$columnId = ?',
        whereArgs: [id]);

    if (result.length > 0) {
      return new Student.fromMap(result.first);
    }
    return null;
  }

  Future<int> deleteStudent(int id) async {
    var dbClient = await getDb;
    return await dbClient.delete(tableStudent, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> updateStudent(Student msg) async {
    var dbClient = await getDb;
    return await dbClient.update(tableStudent, msg.toMap(), where: "$columnId = ?", whereArgs: [msg.getId]);
  }

  Future<void> clearTableContents() async {
    await _db.execute(
        'DELETE FROM ${tableStudent}');
  }

  Future<void> deleteTable() async {
    await _db.execute(
        'DROP TABLE IF EXISTS ${tableStudent}');
  }

  Future<void> deleteDb() async {
    String databasesPath = await getDatabasesPath();
    //deleteDatabase("/data/data/mx.etracker.flutterapp/databases/etracker.db");
    String path = join(databasesPath, databaseName);
    await deleteDatabase(path);
  }

  /**/
  Future close() async {
    var dbClient = await getDb;
    return dbClient.close();
  }
}