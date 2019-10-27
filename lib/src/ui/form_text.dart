import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as prefix0;
import 'package:note_f/src/bloc/bloc_provider.dart';
import 'package:note_f/src/bloc/note_bloc.dart';
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
  DateTime _alrmCtrl = new DateTime.now().add(Duration(hours: 2));
  int setAlarm = 0;

  String _datePost = " ";
  @override
  void initState() {
    super.initState();
    _notesBloc = BlocProvider.of<NotesBloc>(context);
    _getNote(widget.id);
  }

  Future _getNote(id) async {
    if (id == 0) {
      setState(() {        
        _datePost = prefix0.DateFormat("kk:mm, dd MMM yy  ").format(DateTime.now());
      });
    } else {
      var note = await _notesBloc.inGetNote(id);
      _titleCtrl.text = note.title;
      _contentCtrl.text = note.content;
      var formattedString = note.updatedAt !=null?note.updatedAt:note.createdAt;
      // print(note.createdAt);
      print(note.updatedAt);
      setState(() {
        // _datePost = prefix0.DateFormat("kk:mm, dd MMM yy ").format(DateTime.parse(formattedString));
        _colorCtrl = new Color(note.color.toInt());
        if (note.alarm != null) {
          _alrmCtrl = DateTime.parse(note.alarm);
          setAlarm = 1;
        }
      });
    }
  }

  Future _saveNote() async {
    Note _note = Note();
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

  Future _deleteNote() async {
    _notesBloc.inDeleteNote.add(widget.id);
    Navigator.pop(context);
  }

  Future _setAlarmData(DateTime dateTime, TimeOfDay time) async {
    var newDatetime = dateTime
        .add(Duration(hours: time.hour, minutes: time.minute, seconds: 0));
    setState(() {
      _alrmCtrl = newDatetime;
      setAlarm = 1;
    });
  }

  Future _showAlaram() async {
    selectedDate(context, initialDate: _alrmCtrl).then((DateTime alarmData) => {
          if (alarmData != null)
            {
              selectedTime24Hour(context,
                      initialTime: TimeOfDay.fromDateTime(_alrmCtrl))
                  .then((TimeOfDay od) => {
                        if (od != null) {_setAlarmData(alarmData, od)}
                      })
            }
        });
    // selectedTime24Hour(context);
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
                    _showAlaram();
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
          _showAlaram();
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

  Widget _getAlaramBox() {
    if (setAlarm == 0) {
      return Text(" ");
    }
    return FlatButton.icon(
        color: Colors.white,
        // textColor: _colorCtrl,
        icon: Icon(Icons.alarm), //`Icon` to display
        label: Text(prefix0.DateFormat("kk:mm, dd MMM yy  ").format(_alrmCtrl)),
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(18.0),
            side: BorderSide(color: _colorCtrl)), //`Text` to display
        onPressed: () {
          _dialogAlarm();
        });
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
                Container(
                  margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(_datePost),
                      Container(
                        child: _getAlaramBox(),
                      ),
                    ],
                  ),
                ),
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
          )
        );
  }
}

class InputContainer extends StatelessWidget {
  final ctrl;
  final maxline;
  final placeholder;
  final color;
  final fontSize;
  final hightFromScreen;
  final type;
  const InputContainer({
    this.ctrl,
    this.maxline = 1,
    this.placeholder = " Text",
    this.color = Colors.amber,
    this.fontSize = 16.0,
    this.hightFromScreen = null,
    this.type = 'text',
  });

  Widget _typeText() {
    return TextField(
      controller: ctrl,
      style: TextStyle(fontSize: fontSize),
      maxLines: maxline,
      textInputAction: TextInputAction.newline,
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: placeholder,
          contentPadding:
              EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5)),
    );
  }

  _getchildWidget() {
    if (type == 'text') {
      return _typeText();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          border: Border.all(color: color),
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          boxShadow: [
            BoxShadow(
              color: color,
              blurRadius: 1.0, // has the effect of softening the shadow
              spreadRadius: 1.0, // has the effect of extending the shadow
              offset: Offset(
                1.0, // horizontal, move right 10
                1.0, // vertical, move down 10
              ),
            )
          ],
        ),
        margin: EdgeInsets.only(top: 5, left: 16, right: 16, bottom: 5),
        height: hightFromScreen == null
            ? fontSize + 15
            : MediaQuery.of(context).size.height / hightFromScreen, // / 1.5,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(left: 5.0),
        child: _getchildWidget());
  }
}
