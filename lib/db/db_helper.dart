import 'dart:developer';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/task.dart';

class DBHelper {
  DBHelper._(); //singelton
  static DBHelper dbHelperObject = DBHelper._();
  static Database? database;
  static const int _version = 1;
  static const String _tableName = 'tasks';

  static Future<void> initDb() async {
    if (database != null) {
      debugPrint('not null db');
      return;
    } else {
      try {
        String databasePath = await getDatabasesPath();
        String databaseName = 'task.db';
        String fullPath = join(databasePath, databaseName);
        log('in database path');
        database = await openDatabase(fullPath, version: _version,
            onCreate: (Database db, int version) async {
          // await db.execute('CREATE TABLE $_tableName('
          //     'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          //     'title STRING, note STRING, date String '
          //     'startTime STRING, endTime STRING, '
          //     'remind INTEGER, repeat STRING, '
          //     'color INTEGER, '
          //     'isCompleted INTEGER)');

          await db.execute(
            'CREATE TABLE $_tableName (id INTEGER PRIMARY KEY AUTOINCREMENT, title STRING, note STRING, date String, startTime STRING, endTime STRING, remind INTEGER, repeat STRING, color INTEGER, isCompleted INTEGER)',
          );

          log('Hello, The Database has been Created');
        }, onOpen: (db) async {
          final tabels =
              await db.rawQuery('SELECT name From sqlite_master ORDER BY name');
          log(tabels.toString());
          log('Hello, The Database has been Opened');
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future<int> insert(Tasks task) async {
    log('insert function called');
    try {
      return await database!.insert(_tableName, task.toMap());
    } catch (e) {
      print('We are here');
      return 90000;
    }
  }

  Future<int> delete(Tasks? task) async {
    log('delete function called');
    return await database!
        .delete(_tableName, where: 'id = ?', whereArgs: [task!.id]);
  }

  Future<int> deleteAll() async {
    log('delete All function called');
    return await database!.delete(_tableName);
  }

  Future<List<Map<String, dynamic>>> query() async {
    log('query or select function called');
    List<Map<String, Object?>> rawIndex = await database!.query(_tableName);
    return rawIndex;
  }

  Future<int> update(int id) async {
    log('update function called');
    int rawIndex = await database!.rawUpdate(''' 
    UPDATE tasks
    SET isCompleted = ?
    WHERE id = ?
    ''', [1, id]);
    return rawIndex;
  }
}
