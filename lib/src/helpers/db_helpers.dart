import 'dart:io';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:note_f/src/model/note.dart';
import 'package:note_f/src/model/note_check.dart';
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
    // exists = false;
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

  addNoteComp(NoteComp noteComp) async {
    final db = await database;
    final newNote = noteComp.note.toJson();
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd HH:mm:ss');
    String formatted = formatter.format(now);
    newNote['created_at'] = formatted;
    newNote['type'] =  noteComp.noteCheck.length > 0 ? 'check' :'text';

    var batch = db.batch();
    var note_id = await db.insert('note', newNote);
    for (var item in noteComp.noteCheck) {
          if (item.content == null || item.content == ''){
            continue;
          }
          item.noteId = note_id;
          var newCheck = item.toJson();
          newCheck['created_at'] = formatted;
          db.insert('note_check', newCheck);
    }
    var results = await batch.commit();
    
    return results;
  }
  
  getNoteComp(int id) async {
    final db = await database;
    var noteRes = await db.query('note', where: 'id = ?', whereArgs: [id]);
    var note = noteRes.isNotEmpty ? Note.fromJson(noteRes.first) : null;
    
    var res_check =  await db.rawQuery('SELECT * FROM note_check WHERE note_id = ?',[note.id]);
    List<NoteCheck> noteCheck =res_check.isNotEmpty ? res_check.map((note) => NoteCheck.fromJson(note)).toList() : [];
    NoteComp noteComp = new NoteComp(note: note,noteCheck: noteCheck );

    return noteComp;
  }

  updateNoteComp(NoteComp noteComp) async {
    final db = await database;

    final newNote = noteComp.note.toJson();

    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd HH:mm:ss');
    String formatted = formatter.format(now);
    newNote['updated_at'] = formatted;
    newNote['type'] =  noteComp.noteCheck.length > 0 ? 'check' :'text';
    
    var batch = db.batch();
    var note_id = newNote['id'];
    var res = await db.update('note', newNote, where: 'id = ?', whereArgs: [newNote['id']]);
    await db.rawDelete(" DELETE FROM note_check WHERE note_id =? ", [newNote['id']]);
    for (var item in noteComp.noteCheck) {
          if (item.content == null || item.content == ''){
            continue;
          }
          item.noteId = note_id;
          var newCheck = item.toJson();
          newCheck['created_at'] = formatted;
          db.insert('note_check', newCheck);
    }
    var results = await batch.commit();
    
    return results;
  }

  /*
	 * Note Table
	 */
  addNote(Note note) async {
    final db = await database;

    final newNote = note.toJson();

    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd HH:mm:ss');
    String formatted = formatter.format(now);
    newNote['created_at'] = formatted;
    newNote['type'] = 'text';
    var res = await db.insert('note', newNote);
    
    print(res);
    return res;
  }

  getNotes() async {
    final db = await database;
    var res = await db.query('note');
    List<Note> notes =res.isNotEmpty ? res.map((note) => Note.fromJson(note)).toList() : [];
    List<NoteComp> noteComps =  [];
    for (var item in res) {
      Note nt = Note.fromJson(item);
      var res_check =  await db.rawQuery('SELECT * FROM note_check WHERE note_id = ?',[nt.id]);
      List<NoteCheck> noteCheck =res_check.isNotEmpty ? res_check.map((note) => NoteCheck.fromJson(note)).toList() : [];
      NoteComp noteComp = new NoteComp(note: nt,noteCheck: noteCheck );
      noteComps.add(noteComp);
    } 
    return noteComps.toList();
    // return notes;
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
    var formatter = new DateFormat('yyyy-MM-dd HH:mm:ss');
    String formatted = formatter.format(now);
    newNote['updated_at'] = formatted;
    newNote['type'] = 'text';
    var res =
        await db.update('note', newNote, where: 'id = ?', whereArgs: [note.id]);

    return res;
  }

  deleteNote(int id) async {
    final db = await database;

    db.delete('note', where: 'id = ?', whereArgs: [id]);
  }
}
