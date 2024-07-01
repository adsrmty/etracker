import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'Student.dart';

class DbHelperStudent {
  static final DbHelperStudent _instance = DbHelperStudent.internal();

  factory DbHelperStudent() => _instance;

  final String databaseName = 'etracker.db';
  final String tableStudent = 'studentTable';
  final String columnPickupKey = 'pickupKey';
  final String columnSchoolKey = 'schoolKey';
  final String columnName = 'name';
  final String columnSchool = 'school';
  final String columnSchedule = 'schedule';
  final String columnExpire = 'expire';
  DbHelperStudent.internal();

  static Database? _db;
  Future<Database> get getDb async =>
      _db ??= await _initDb();

  _initDb() async {
    print('initDb()');
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, databaseName);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    await db.execute(
        'CREATE TABLE IF NOT EXISTS $tableStudent($columnPickupKey TEXT PRIMARY KEY, $columnSchoolKey TEXT, $columnName TEXT, $columnSchool TEXT deded, $columnSchedule TEXT, $columnExpire TEXT)');
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    print('_onCreate Student Table');
    await db.execute(
        'CREATE TABLE $tableStudent($columnPickupKey TEXT, $columnSchoolKey TEXT, $columnName TEXT, $columnSchool TEXT, $columnSchedule TEXT, $columnExpire TEXT)');
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
    var result = await dbClient.query(tableStudent, columns: [columnPickupKey, columnSchoolKey, columnName, columnSchool, columnSchedule, columnExpire]);
    return result.toList();
  }

  Future<int?> getCount() async {
    var dbClient = await getDb;
    return Sqflite.firstIntValue(await dbClient.rawQuery('SELECT COUNT(*) FROM $tableStudent'));
  }

  Future<Student> getStudent(String pickupKey) async {
    var dbClient = await getDb;
    List<Map<String, dynamic>> result = await dbClient.query(tableStudent,
        columns: [columnPickupKey, columnSchoolKey, columnName, columnSchool, columnSchedule, columnExpire],
        where: '$columnPickupKey = ?',
        whereArgs: [pickupKey]);

    if (result.isNotEmpty) {
      return Student.fromMap(result.first);
    }
    else {
      return Student ("Default","Default","Default","Default","Default","Default");
    }

  }

  Future<int> deleteStudent(String pickupKey) async {
    var dbClient = await getDb;
    return await dbClient.delete(tableStudent, where: '$columnPickupKey = ?', whereArgs: [pickupKey]);
  }

  Future<int> updateStudent(Student student) async {
    var dbClient = await getDb;
    return await dbClient.update(tableStudent, student.toMap(), where: "$columnPickupKey = ?", whereArgs: [student.getPickupKey]);
  }

  Future<void> clearTableContents() async {
    await _db?.execute(
        'DELETE FROM ${tableStudent!}');
  }

  Future<void> deleteTable() async {
    await _db?.execute(
        'DROP TABLE IF EXISTS ${tableStudent!}');
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



