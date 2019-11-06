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
  DateTime _alrmCtrl; // = new DateTime.now().add(Duration(hours: 2));
  int setAlarm = 0;
  String _datePost = " ";
  int _alaramTypeCtrl;

  Note _note = new Note();
  List<NoteCheck> _noteDetail = [new NoteCheck()];

  List textEditingListCtrl = [];
  @override
  void initState() {
    super.initState();
    textEditingListCtrl = [];
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
      NoteComp noteComp = await _notesBloc.inGetNoteCom(id);
      _note = noteComp.note;
      _titleCtrl.text = _note.title;
      _contentCtrl.text = _note.content;
      var formattedString =
          _note.updatedAt != null ? _note.updatedAt : _note.createdAt;

      if (_note.type == 'check') {
        noteComp.noteCheck.add(new NoteCheck());
      }
      setState(() {
        _alaramTypeCtrl = _note.alarmType;
        _noteDetail = noteComp.noteCheck;
        _datePost = dateformat.DateFormat("kk:mm, dd MMM yy ")
            .format(DateTime.parse(formattedString));
        _colorCtrl = new Color(_note.color.toInt());
        if (_note.alarm != null) {
          _alrmCtrl = DateTime.parse(_note.alarm);
          setAlarm = 1;
        }
        
        noteComp.noteCheck.forEach((item) {
          var textEditingController = new TextEditingController(text: item.content);
          textEditingListCtrl.add(textEditingController);
        });
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
    
    for (var i = 0; i < _noteDetail.length; i++) {
        _noteDetail[i].content = textEditingListCtrl[i].text; 
    }
    var noteComp = new NoteComp();
    noteComp.note = _note;
    noteComp.noteCheck = _noteDetail;
    if (widget.id != 0) {
      _note.id = widget.id;
      _notesBloc.inSaveNoteComp.add(noteComp);
    } else {
      _notesBloc.inAddNoteComp.add(noteComp);
    }
    Navigator.pop(context);
  }

  Future _nodeDetailAdd() async {
    _noteDetail.add(new NoteCheck());
    setState(() {
      _noteDetail = _noteDetail;
      var textEditingController = new TextEditingController(text: '');
      textEditingListCtrl.add(textEditingController);
    });
  }

  Future _noteDetailChange(type, i, val) async {
    if (type == 'content') {
      _noteDetail[i].content = val;
    }
    if (type == 'isChecked') {
      _noteDetail[i].isChecked = val == true ? 1 : 0;
    }
    setState(() {
      _noteDetail = _noteDetail;
    });
  }

  Future _nodeDetailRemove(i) async {
    _noteDetail.removeAt(i);
    // print(textEditingListCtrl.length);
    var d = textEditingListCtrl.removeAt(i);
      // textEditingListCtrl = d;
    
    setState(() {
      _noteDetail = _noteDetail;
    });
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
          showAlaramDialog(context,initialDate: _alrmCtrl, setAlaram: _setAlaram, alaramType: _alaramTypeCtrl);
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
                    showAlaramDialog(context,initialDate: _alrmCtrl, setAlaram: _setAlaram,alaramType: _alaramTypeCtrl);
                  }),
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
                  listItemChange: _noteDetailChange,
                  listItemAdd: _nodeDetailAdd,
                  listItemRemove: _nodeDetailRemove,
                  textEditingListCtrl:textEditingListCtrl,
                  hightFromScreen: 1.5),
            ],
          ),
        ));
  }
}
