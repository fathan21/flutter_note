import 'dart:io';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:note_f/src/model/note.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  // Create a singleton
  DBProvider._();

  static final DBProvider db = DBProvider._();
  Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await initDB();
    return _database;
  }

  initDB() async {
    // Get the location of our apps directory. This is where files for our app, and only our app, are stored.
    // Files in this directory are deleted when the app is deleted.
    /*
		Directory documentsDir = await getApplicationDocumentsDirectory();
		String path = join(documentsDir.path, 'app2.db');

		return await openDatabase(path, version: 1, onOpen: (db) async {
		}, onCreate: (Database db, int version) async {
			// Create the note table
			await db.execute('''
				CREATE TABLE note(
					id INTEGER PRIMARY KEY,
					content TEXT DEFAULT '',
					title TEXT DEFAULT ''
				)
			''');
		});
    */
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "note.db");

    // Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", "db", "db.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }
    // open the database
    var db = await openDatabase(path, readOnly: false);
    return db;
  }

  /*
	 * Note Table
	 */
  addNote(Note note) async {
    final db = await database;

    final newNote = note.toJson();

    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd H:m:s');
    String formatted = formatter.format(now);
    newNote['created_at'] = formatted;
    newNote['type'] = 'text';
    print(newNote);
    var res = await db.insert('note', newNote);

    return res;
  }

  getNotes() async {
    final db = await database;
    var res = await db.query('note');
    List<Note> notes =
        res.isNotEmpty ? res.map((note) => Note.fromJson(note)).toList() : [];

    return notes;
  }

  getNote(int id) async {
    final db = await database;
    var res = await db.query('note', where: 'id = ?', whereArgs: [id]);

    return res.isNotEmpty ? Note.fromJson(res.first) : null;
  }

  updateNote(Note note) async {
    final db = await database;

    final newNote = note.toJson();

    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd H:m:s');
    String formatted = formatter.format(now);
    newNote['updated_at'] = formatted;
    print(newNote);

    var res =
        await db.update('note', newNote, where: 'id = ?', whereArgs: [note.id]);

    return res;
  }

  deleteNote(int id) async {
    final db = await database;

    db.delete('note', where: 'id = ?', whereArgs: [id]);
  }
}
