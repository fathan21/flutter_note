import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as dateformat;
import 'package:note_f/src/bloc/bloc_provider.dart';
import 'package:note_f/src/bloc/note_bloc.dart';
import 'package:note_f/src/helpers/input.dart';
import 'package:note_f/src/helpers/picker.dart';
import 'package:note_f/src/model/note.dart';
import 'package:flutter/cupertino.dart';
import 'package:note_f/src/model/note_check.dart';

class FormListPage extends StatefulWidget {
  FormListPage({Key key, @required this.id}) : super();

  final int id;

  @override
  _FormListState createState() => _FormListState();
}

class _FormListState extends State<FormListPage> {
  TextEditingController _titleCtrl = new TextEditingController();
  TextEditingController _contentCtrl = new TextEditingController();
  NotesBloc _notesBloc;
  Color _colorCtrl = ThemeData().primaryColor;
  DateTime _alrmCtrl = new DateTime.now().add(Duration(hours: 2));
  int setAlarm = 0;
  String _datePost = " ";

  Note _note = new Note();
  List<NoteCheck> _noteDetail = [new NoteCheck(), new NoteCheck(), new NoteCheck()];
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
      _titleCtrl.text = _note.title;
      _contentCtrl.text = _note.content;
      var formattedString =
          _note.updatedAt != null ? _note.updatedAt : _note.createdAt;
      setState(() {
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
        ? null
        : _titleCtrl.text;
    _note.title = title.toString();
    _note.color = _colorCtrl.value;
    _note.alarm = setAlarm == 1 ? _alrmCtrl.toString() : null;

    if (widget.id != 0) {
      _note.id = widget.id;
      _notesBloc.inSaveNote.add(_note);
    } else {
      _notesBloc.inAddNote.add(_note);
    }
    Navigator.pop(context);
  }
  Future _nodeDetailAdd() async {
    print('add');
    _noteDetail.add(new NoteCheck());
    setState(() {
     _noteDetail = _noteDetail; 
    });
  }
  Future _nodeDetailRemove(i) async {
    print("remove $i " );
    _noteDetail.removeAt(i);
    setState(() {
     _noteDetail = _noteDetail; 
    });
  }

  Future _deleteNote() async {
    _notesBloc.inDeleteNote.add(widget.id);
    Navigator.pop(context);
  }

  Future _dialogAlarm() async => showDialog(
        context: context,
        builder: (BuildContext c) {
          // return object of type Dialog
          const styleBtn = TextStyle(fontSize: 20);
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              // verticalDirection: VerticalDirection.down,
              children: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.pop(c, true);
                    showAlaramDialog(context, initialDate: _alrmCtrl)
                        .then((newAlarm) => {
                              if (newAlarm != null)
                                {
                                  setState(() {
                                    setAlarm = 1;
                                    _alrmCtrl = newAlarm;
                                  })
                                }
                            });
                  },
                  child: const Text('Ubah', style: styleBtn),
                ),
                FlatButton(
                  onPressed: () {
                    setState(() {
                      setAlarm = 0;
                    });
                    Navigator.pop(c, true);
                  },
                  child: const Text('Hapus', style: styleBtn),
                ),
              ],
            ),
          );
        },
      );
  
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
          showAlaramDialog(context, initialDate: _alrmCtrl).then((newAlarm) => {
                if (newAlarm != null)
                  {
                    setState(() {
                      setAlarm = 1;
                      _alrmCtrl = newAlarm;
                    })
                  }
              });
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
                  dialogAlarm: _dialogAlarm),
              InputContainer(
                ctrl: _titleCtrl,
                color: _colorCtrl,
                placeholder: "Judul",
                fontSize: 30.0,
              ),
              InputContainer(
                  type: 'list',
                  color: _colorCtrl,
                  maxline: null,
                  listItem: _noteDetail,
                  listItemAdd: _nodeDetailAdd,
                  listItemRemove: _nodeDetailRemove,
                  hightFromScreen: 1.5),
            ],
          ),
        ));
  }
}
