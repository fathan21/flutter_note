import 'package:flutter/material.dart';
import 'package:note_f/src/bloc/bloc_provider.dart';
import 'package:note_f/src/bloc/note_bloc.dart';
import 'package:note_f/src/helpers/picker.dart';
import 'package:note_f/src/model/note.dart';

class FormTextPage extends StatefulWidget {
  FormTextPage({Key key, @required this.note}) : super();

  final Note note;

  @override
  _FormTextState createState() => _FormTextState();
}

class _FormTextState extends State<FormTextPage> {
  TextEditingController _titleCtrl = new TextEditingController();
  TextEditingController _contentCtrl = new TextEditingController();
  NotesBloc _notesBloc;
  Color _colorCtrl = Colors.blue;
  DateTime _alrmCtrl = new DateTime.now().add(Duration(hours: 2));
  @override
  void initState() {
    super.initState();
    _notesBloc = BlocProvider.of<NotesBloc>(context);
    _contentCtrl.text = widget.note.content;
    _titleCtrl.text = widget.note.title;
  }

  Future _saveNote() async {
    Note _note = Note();
    _note.content = _contentCtrl.text;
    _note.title = _titleCtrl.text;
    _note.color = _colorCtrl.value;
    _note.alarm = _alrmCtrl.toString();
    
    if (widget.note.id != null) {
      _note.id = widget.note.id;
      _notesBloc.inSaveNote.add(_note);
    } else {
      _notesBloc.inAddNote.add(_note);
    }
    Navigator.pop(context);
  }

  Future _deleteNote() async {
    _notesBloc.inDeleteNote.add(widget.note.id);
    Navigator.pop(context);
  }
  
  Future _setAlarmData(DateTime dateTime, TimeOfDay time) async {
    var newDatetime = dateTime.add(Duration(hours: time.hour, minutes: time.minute, seconds: 0));
    setState(() {
     _alrmCtrl = newDatetime; 
    });
  }

  @override
  Widget build(BuildContext context) {
    InputDecoration _styleInput = InputDecoration(
      fillColor: _colorCtrl,
      filled: true,
      border: InputBorder.none,
      hintText: 'Text',
      hintStyle: new TextStyle(color: Colors.grey, fontSize: 20),
      contentPadding: EdgeInsets.all(16),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Text'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Alarm',
            onPressed: () {
              this._saveNote();
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Delete',
            onPressed: () {
              this._deleteNote();
            },
          ),
          IconButton(
            icon: const Icon(Icons.alarm),
            tooltip: 'Alarm',
            onPressed: () {
              selectedDate(context, initialDate: _alrmCtrl).then((DateTime alarmData) => {
                    if (alarmData != null)
                      {
                        selectedTime24Hour(context, initialTime: TimeOfDay.fromDateTime(_alrmCtrl))
                            .then((TimeOfDay od) => {if (od != null) {
                                _setAlarmData(alarmData, od)
                            }})
                      }
                  });
              // selectedTime24Hour(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.color_lens),
            tooltip: 'Warna',
            onPressed: () {
              colorPicker(context, currentColor: _colorCtrl)
                  .then((newColor) => setState(() {
                        _colorCtrl = newColor;
                      }));
            },
          ),
        ],
      ),
      body: Container(
          padding: EdgeInsets.all(16.0),
          color: Colors.grey[100],
          child: Column(
            children: <Widget>[
              Text( 'Alaram: ' + _alrmCtrl.toString()),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  // borderRadius: BorderRadius.all(Radius.circular(32)),
                ),
                margin: EdgeInsets.only(bottom: 20),
                child: TextField(
                  style: new TextStyle(color: Colors.black, fontSize: 20),
                  controller: _titleCtrl,
                  cursorColor: Colors.black,
                  decoration: _styleInput,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  // borderRadius: BorderRadius.all(Radius.circular(32)),
                ),
                child: TextField(
                  controller: _contentCtrl,
                  style: new TextStyle(color: Colors.black, fontSize: 20),
                  cursorColor: Colors.black,
                  maxLines: 20,
                  keyboardType: TextInputType.multiline,
                  minLines: 20,
                  decoration: _styleInput,
                ),
              ),
            ],
          )),
    );
  }
}
