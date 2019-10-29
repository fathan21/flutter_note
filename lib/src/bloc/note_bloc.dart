import 'dart:async';

import 'package:note_f/src/bloc/bloc_provider.dart';
import 'package:note_f/src/helpers/db_helpers.dart';
import 'package:note_f/src/model/note.dart';

class NotesBloc implements BlocBase {
  // Create a broadcast controller that allows this stream to be listened
  // to multiple times. This is the primary, if not only, type of stream you'll be using.
  final _notesController = StreamController<List<Note>>.broadcast();

  // Input stream. We add our notes to the stream using this variable.
  StreamSink<List<Note>> get _inNotes => _notesController.sink;

  // Output stream. This one will be used within our pages to display the notes.
  Stream<List<Note>> get notes => _notesController.stream;

  // Input stream for adding new notes. We'll call this from our pages.
  final _addNoteController = StreamController<Note>.broadcast();
  StreamSink<Note> get inAddNote => _addNoteController.sink;

  final _saveNoteController = StreamController<Note>.broadcast();
  StreamSink<Note> get inSaveNote => _saveNoteController.sink;

  final _deleteNoteController = StreamController<int>.broadcast();
  StreamSink<int> get inDeleteNote => _deleteNoteController.sink;

  
  final _addNoteCompController = StreamController<NoteComp>.broadcast();
  StreamSink<NoteComp> get inAddNoteComp => _addNoteCompController.sink;
  
  get inGetNote => (id) async{
    var d = await DBProvider.db.getNote(id);
    return d;
  };
  

  NotesBloc() {
    // Retrieve all the notes on initialization
    getNotes();


    // Listens for changes to the addNoteController and calls _handleAddNote on change
    _addNoteController.stream.listen(_handleAddNote);
    // Listen for changes to the stream, and execute a function when a change is made
    _saveNoteController.stream.listen(_handleSaveNote);
    _deleteNoteController.stream.listen(_handleDeleteNote);

    _addNoteCompController.stream.listen(_handleAddNoteComp);

  }

  // All stream controllers you create should be closed within this function
  @override
  void dispose() {
    _notesController.close();
    _addNoteController.close();

    _saveNoteController.close();
    _deleteNoteController.close();

    _addNoteCompController.close();
  }

  void getNotes() async {
    // Retrieve all the notes from the database
    List<Note> notes = await DBProvider.db.getNotes();
    // Add all of the notes to the stream so we can grab them later from our pages
    _inNotes.add(notes);
  }

  void _handleAddNote(Note note) async {
    // Create the note in the database
    await DBProvider.db.addNote(note);
    
    return getNotes();
  }

  _handleSaveNote(Note note) async {
    await DBProvider.db.updateNote(note);
    return getNotes();
  }

  void _handleDeleteNote(int id) async {
    await DBProvider.db.deleteNote(id);
    return getNotes();
  }

  
  void _handleAddNoteComp(NoteComp note) async {
    // Create the note in the database
    await DBProvider.db.addNoteComp(note);
    
    return getNotes();
  }
}

