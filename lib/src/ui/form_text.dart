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
    if(widget.note.id != null) {
      _note.id = widget.note.id;
      _notesBloc.inSaveNote.add(_note);
    } else{    
      _notesBloc.inAddNote.add(_note);
    }
    Navigator.pop(context);
	}

	Future _deleteNote() async{
		_notesBloc.inDeleteNote.add(widget.note.id);
    Navigator.pop(context);
	}

  @override
  Widget build(BuildContext context) {
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
              selectedDate(context).then((onValue)=>{
                if (onValue != null) {  
                  selectedTime24Hour(context).then((od)=>{
                    if (od != null) {
                      print(od.toString() + onValue.toString() )
                    }
                  })
                }
              });
              // selectedTime24Hour(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.color_lens),
            tooltip: 'Warna',
            onPressed: () {
              colorPicker(context).then((dt)=>{
                hexToColor(dt)
              });
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        color: Colors.grey[100],
        child: Column(
          children: <Widget>[
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
                decoration: InputDecoration(
                  hintText: 'Judul',
                  border: InputBorder.none, 
                  hintStyle: new TextStyle(color: Colors.grey),
                  contentPadding: EdgeInsets.all(16),
                  
                ),
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
                decoration: InputDecoration(
                  border: InputBorder.none, 
                  hintText: 'Text',
                  hintStyle: new TextStyle(color: Colors.grey, fontSize: 20),
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}
Color hexToColor(String code) {
  return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

