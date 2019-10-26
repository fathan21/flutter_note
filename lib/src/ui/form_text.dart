import 'package:flutter/material.dart';
import 'package:note_f/src/bloc/bloc_provider.dart';
import 'package:note_f/src/bloc/note_bloc.dart';
import 'package:note_f/src/helpers/picker.dart';
import 'package:note_f/src/model/note.dart';

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
  @override
  void initState() {
    super.initState();
    _notesBloc = BlocProvider.of<NotesBloc>(context);
    _getNote(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InputHeaderWidget(_titleCtrl, 'Judul'),
        backgroundColor: _colorCtrl,
        actions: <Widget>[
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
            icon: new Icon(Icons.alarm),
            tooltip: 'Alarm',
            onPressed: () {
              selectedDate(context, initialDate: _alrmCtrl)
                  .then((DateTime alarmData) => {
                        if (alarmData != null)
                          {
                            selectedTime24Hour(context,
                                    initialTime:
                                        TimeOfDay.fromDateTime(_alrmCtrl))
                                .then((TimeOfDay od) => {
                                      if (od != null)
                                        {_setAlarmData(alarmData, od)}
                                    })
                          }
                      });
              // selectedTime24Hour(context);
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
        ],
      ),
      body: InputFullBodyWidget(_contentCtrl, 'Text'),
      bottomNavigationBar: BottomAppBar(
        
        child: Container(
          padding: EdgeInsets.all(13.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[Text("tgl buat"), Text("alarm")],
          ),
        ),
      ),
    );
  }

  Future _getNote(id) async {
    if (id == 0) {
    } else {
      var note = await _notesBloc.inGetNote(id);
      _titleCtrl.text = note.title;
      _contentCtrl.text = note.content;
      setState(() {
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
}

class InputHeaderWidget extends StatelessWidget {
  final _ctrl;
  final _placeholder;
  const InputHeaderWidget(this._ctrl, this._placeholder);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.all(Radius.circular(32)),
      ),
      child: TextField(
        controller: _ctrl,
        style: new TextStyle(color: Colors.black, fontSize: 20),
        cursorColor: Colors.black,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            border: InputBorder.none,
            // contentPadding: EdgeInsets.only(left: 16, right: 16),
            hintText: _placeholder == null ? 'Text' : _placeholder,
            hintStyle: TextStyle(color: Colors.grey[300])),
      ),
    );
  }
}

class InputFullBodyWidget extends StatelessWidget {
  final _ctrl;
  final _placeholder;
  const InputFullBodyWidget(this._ctrl, this._placeholder);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size) {
      TextSpan text = new TextSpan(
        text: _ctrl.text,
      );

      TextPainter tp = new TextPainter(
        text: text,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.left,
      );
      tp.layout(maxWidth: size.maxWidth);
      int lines = (tp.size.height / tp.preferredLineHeight).ceil();
      int maxLines = 6;
      return TextField(
        controller: _ctrl,
        maxLines: lines > maxLines ? null : maxLines,
        textInputAction: TextInputAction.newline,
        decoration: InputDecoration(
            hintText: _placeholder,
            contentPadding: EdgeInsets.all(16),
            // border: new OutlineInputBorder(borderSide: new BorderSide(color: Colors.teal)),
            // labelText: 'Life story',
            border: InputBorder.none),
      );
    });
  }
}
