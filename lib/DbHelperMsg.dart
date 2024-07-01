import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'Message.dart';

class DbHelperMsg {
  static final DbHelperMsg _instance = new DbHelperMsg.internal();

  factory DbHelperMsg() => _instance;

  final String databaseName = 'etracker.db';
  final String tableMsg = 'msgTable';
  final String columnId = 'id';
  final String columnDate = 'date';
  final String columnMsg = 'msg';

  DbHelperMsg.internal();
  static Database? _db;
  Future<Database> get getDb async =>
      _db ??= await _initDb();

  _initDb() async {
    print('initDb()');
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, databaseName);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    await db.execute(
        'CREATE TABLE IF NOT EXISTS $tableMsg($columnId INTEGER PRIMARY KEY, $columnDate TEXT, $columnMsg TEXT)');
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $tableMsg($columnId INTEGER PRIMARY KEY, $columnDate TEXT, $columnMsg TEXT)');
  }

  Future<int> saveMsg(Message msg) async {
    var dbClient = await getDb;
    var result = await dbClient.insert(tableMsg, msg.toMap());
    return result;
  }

  Future<List> getAllMsgs() async {
    var dbClient = await getDb;
    var result = await dbClient.query(tableMsg, columns: [columnId, columnDate, columnMsg]);
    return result.toList();
  }

  Future<int?> getCount() async {
    var dbClient = await getDb;
    return Sqflite.firstIntValue(await dbClient.rawQuery('SELECT COUNT(*) FROM $tableMsg'));
  }

  Future<Message> getMsg(int id) async {
    var dbClient = await getDb;
    List<Map<String, dynamic>> result = await dbClient.query(tableMsg,
        columns: [columnId, columnDate, columnMsg],
        where: '$columnId = ?',
        whereArgs: [id]);

    if (result.isNotEmpty) {
      return Message.fromMap(result.first);
    }
    else {
      return Message ("Default","Default");
    }
  }

  Future<int> deleteMsg(int id) async {
    var dbClient = await getDb;
    return await dbClient.delete(tableMsg, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> updateMsg(Message msg) async {
    var dbClient = await getDb;
    return await dbClient.update(tableMsg, msg.toMap(), where: "$columnId = ?", whereArgs: [msg.getId]);
  }

  Future<void> clearTableContents() async {
    await _db?.execute(
        'DELETE FROM $tableMsg');
  }

  Future<void> deleteDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, databaseName);
    await deleteDatabase(path);
  }

  Future close() async {
    var dbClient = await getDb;
    return dbClient.close();
  }
}