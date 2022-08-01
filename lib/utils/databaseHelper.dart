
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:untitled/models/note.dart';



class databaseHelper {
  static databaseHelper? _DatabaseHelper; //Singlton databasehelpr
  static Database? _database;

  String noteTable = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colPriority = 'priority';
  String colDate = 'date';

  databaseHelper._createInstance();

  factory databaseHelper() {
    if (_DatabaseHelper == null) {
      _DatabaseHelper = databaseHelper._createInstance();
    }
    return _DatabaseHelper!;
  }

  Future<Database?> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }


  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.db';

    var notesDatabase = await openDatabase(
        path, version: 1, onCreate: _creatDb);
    return notesDatabase;
  }


  void _creatDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colDescription TEXT, $colPriority INTEGER, $colDate TEXT )');
  }

//fetch all operations
  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database? db = await this.database;
    var result = await db!.query(noteTable, orderBy: '$colPriority ASC');
    return result;
  }

//insert operation

  Future<int> insertNote(Note note) async {
    Database? db = await this.database;
    var result = await db!.insert(noteTable, note.toMap());
    return result;
  }

//update nopertation

  Future<int> updateNote(Note note) async {
    Database? db = await this.database;
    var result = await db!.update(
        noteTable, note.toMap(), where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

  //delete operations

  Future<int> deleteNote(int id) async {
    Database? db = await this.database;
    int result = await db!.rawDelete(
        'DELETE FROM $noteTable WHERE $colId = $id');
    return result;
  }

  //Get numbr of note object in dtabase

  Future<int> getCount() async {
    Database? db = await this.database;
    List<Map<String, dynamic>> x = await db!.rawQuery(
        'SELECT COUNT (*) from $noteTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Note>> getNoteList() async {
    var noteMapList = await getNoteMapList();
    int count = noteMapList.length;

    List<Note> noteList = <Note>[];
    for(int i = 0; i < count; i++){
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }
  return noteList;
  }



}

