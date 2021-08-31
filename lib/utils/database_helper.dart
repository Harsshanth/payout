import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:taskkeeper/models/note.dart';
import 'package:taskkeeper/screens/upload_form.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;

  DatabaseHelper._createInstance();

  String noteTable = 'note_table';
  String colId = 'id';
  String colAmount = 'amount';
  String colDescription = 'description';
  String colDate = 'date';

  factory DatabaseHelper() {
    return _databaseHelper ?? DatabaseHelper._createInstance();
  }

  Future<Database> get database async {
    return _database ?? await initializeDatabase();
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.db';

    // Open/create the database at a given path
    var notesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colAmount TEXT, '
        '$colDescription TEXT,  $colDate TEXT)');
  }

  // Fetch operation
  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;
    //		var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result = await db.query(noteTable, orderBy: '$colDate ASC');

    return result;
  }

// Insert
  Future<int> insertNote(Note note) async {
    Database db = await this.database;
    var result = await db.insert(noteTable, note.toMap());
    return result;
  }

  // Update
  Future<int> updateNote(Note note) async {
    Database db = await this.database;
    var result = await db.update(noteTable, note.toMap(),
        where: '$colId=?', whereArgs: [note.id]);
    return result;
  }

  Future<int?> deleteNote(int? id) async {
    if (id != null) {
      var db = await this.database;
      int result =
          await db.rawDelete('DELETE FROM $noteTable WHERE $colId = $id');
      return result;
    }
    return null;
  }

  // Get the mapList and convert to Note list
  Future<List<Note>> getNoteList() async {
    var noteMapList = await getNoteMapList();
    int count = noteMapList.length;

    // ignore: deprecated_member_use
    List<Note> noteList = <Note>[];

    for (int i = 0; i < count; i++) {
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }

    return noteList;
  }
}
