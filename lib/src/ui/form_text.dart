import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as dateformat;
import 'package:note_f/src/bloc/bloc_provider.dart';
import 'package:note_f/src/bloc/note_bloc.dart';
import 'package:note_f/src/helpers/input.dart';
import 'package:note_f/src/helpers/picker.dart';
import 'package:note_f/src/model/note.dart';
import 'package:flutter/cupertino.dart';

class FormTextPage extends StatefulWidget {
  FormTextPage({Key key, @required this.id}) : super();

  final int id;

  @override
  _FormTextState createState() => _FormTextState();
}

class _FormTextState extends State<FormTextPage> {
  TextEditingController _titleCtrl = new TextEditingController();
  TextEditingController _contentCtrl = new TextEditingController();
  NotesBloc _notesBloc;
  Color _colorCtrl = ThemeData().primaryColor;
  DateTime _alrmCtrl;
  int setAlarm = 0;
  String _datePost = " ";
  int _alaramTypeCtrl;

  Note _note = new Note();
  @override
  void initState() {
    super.initState();
    _notesBloc = BlocProvider.of<NotesBloc>(context);
    _getNote(widget.id);
  }

  Future _getNote(id) async {
    if (id == 0) {
      setState(() {
        _datePost =
            dateformat.DateFormat("kk:mm, dd MMM yy  ").format(DateTime.now());
      });
    } else {
      _note = await _notesBloc.inGetNote(id);
      
      // print(_note.toJson());
      // print("type");
      _titleCtrl.text = _note.title;
      _contentCtrl.text = _note.content;
      var formattedString =
          _note.updatedAt != null ? _note.updatedAt : _note.createdAt;
      setState(() {
        _alaramTypeCtrl = _note.alarmType;
        _datePost = dateformat.DateFormat("kk:mm, dd MMM yy ")
            .format(DateTime.parse(formattedString));
        _colorCtrl = new Color(_note.color.toInt());
        if (_note.alarm != null) {
          _alrmCtrl = DateTime.parse(_note.alarm);
          setAlarm = 1;
        }
      });
    }
  }

  Future _saveNote() async {
    _note.content = _contentCtrl.text.toString();
    var title = _titleCtrl.text == '' || _titleCtrl.text == null
        ? ''
        : _titleCtrl.text;
    _note.title = title.toString();
    _note.color = _colorCtrl.value;
    _note.alarmType = _alaramTypeCtrl;
    _note.alarm = setAlarm == 1 ? _alrmCtrl.toString() : null;

    if (widget.id != 0) {
      _note.id = widget.id;
      _notesBloc.inSaveNote.add(_note);
    } else {
      _notesBloc.inAddNote.add(_note);
    }
    Navigator.pop(context);
  }

  Future _deleteNote() async {
    _notesBloc.inDeleteNote.add(widget.id);
    Navigator.pop(context);
  }
   _setAlaram(newAlarm, alaramType){
    if(newAlarm != null){
      setState(() {
        setAlarm = 1;
        _alrmCtrl = newAlarm;
        _alaramTypeCtrl = alaramType;
      });
    }else{
      setState(() {
        setAlarm = 0;
        _alrmCtrl = null;
        _alaramTypeCtrl = null;
      });
    }
  }
  List<Widget> actionList() {
    return [
      IconButton(
        icon: const Icon(Icons.save),
        tooltip: 'Alarm',
        onPressed: () {
          this._saveNote();
        },
      ),
      IconButton(
        icon: new Icon(Icons.delete),
        tooltip: 'Delete',
        onPressed: () {
          this._deleteNote();
        },
      ),
      IconButton(
        icon: new Icon(Icons.alarm_add),
        tooltip: 'Alarm',
        onPressed: () {
          showAlaramDialog(context, initialDate: _alrmCtrl,setAlaram: _setAlaram, alaramType: _alaramTypeCtrl);
        },
      ),
      IconButton(
        icon: new Icon(Icons.color_lens),
        tooltip: 'Warna',
        onPressed: () {
          colorPicker(context, currentColor: _colorCtrl)
              .then((newColor) => setState(() {
                    _colorCtrl = newColor;
                  }));
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: _colorCtrl,
          actions: actionList(),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              InputHead(
                  datePost: _datePost,
                  colorCtrl: _colorCtrl,
                  setAlarm: setAlarm,
                  alrmCtrl: _alrmCtrl,
                  dialogAlarm: (){
                    showAlaramDialog(context,initialDate: _alrmCtrl, setAlaram: _setAlaram, alaramType: _alaramTypeCtrl);
                  }),
              InputContainer(
                ctrl: _titleCtrl,
                color: _colorCtrl,
                placeholder: "Judul",
                fontSize: 30.0,
              ),
              InputContainer(
                  ctrl: _contentCtrl,
                  color: _colorCtrl,
                  placeholder: "Text",
                  maxline: null,
                  hightFromScreen: 1.5),
            ],
          ),
        ));
  }
}
