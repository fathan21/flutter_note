import 'package:flutter/material.dart';
import 'package:note_f/src/helpers/dialog.dart';
import 'package:note_f/src/ui/form_list.dart';
import 'package:note_f/src/ui/form_text.dart';

class GridNoteListWidget extends StatelessWidget {
  final List datas;
  final setSelectedNote;
  final removeSelectedNote;
  final List selectedNote;
  final bool selectedNoteActive;
  
  GridNoteListWidget(
      this.datas,
      {this.selectedNote,this.selectedNoteActive, this.setSelectedNote, this.removeSelectedNote}
  );

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      scrollDirection: Axis.vertical,
      controller: ScrollController(),
      crossAxisCount: 2,
      children: List.generate(datas.length, (index) {
        var data = datas[index];
        return GestureDetector(
            onTap: () {
              if (selectedNoteActive) {              
                setSelectedNote(data.note.id);
              }else{
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => data.noteCheck.length > 0
                          ? new FormListPage(id: data.note.id)
                          : new FormTextPage(id: data.note.id)),
                );
              }
            },
            onLongPress: (){
              setSelectedNote(data.note.id);
            },
            child: GridNoteItemWidget(data.note, data.noteCheck,
              selectedNote: selectedNote,
              setSelectedNote: setSelectedNote,
              selectedNoteActive: selectedNoteActive,
              removeSelectedNote: removeSelectedNote,
            ));
      }),
    );
  }
}

class GridNoteItemWidget extends StatelessWidget {
  final data;
  final noteCheck;
  
  final setSelectedNote;
  final removeSelectedNote;
  final List selectedNote;
  final bool selectedNoteActive;

  GridNoteItemWidget(this.data, this.noteCheck,
    {this.selectedNote,this.selectedNoteActive, this.setSelectedNote, this.removeSelectedNote}
  );

  Widget _text() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        (data.title == '' || data.title == null
            ? Text(" ")
            : Container(
                margin: EdgeInsets.only(bottom: 0, right: 15),
                child: Text(
                  data.title.toString(),
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              )),
        Flexible(
          child: new Text(
            data.content.toString(),
            maxLines: 13,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            style: new TextStyle(
              fontSize: 14.0,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
            ),
          )
        ),
      ],
    );
  }

  Widget _chceked() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        (data.title == '' || data.title == null
            ? Text(" ")
            : Container(
                margin: EdgeInsets.only(bottom: 0, right: 15),
                child: Text(
                  data.title.toString(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              )),
        Expanded(
          child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(top: 0.0, left: 1.0),
              itemCount: noteCheck.length,
              itemBuilder: (BuildContext context, int index) {
                return _typeListItem(context, noteCheck[index], index);
              }),
        )
      ],
    );
  }

  Widget _typeListItem(context, data, i) {
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.topCenter,
          child: Checkbox(
            value: noteCheck[i].isChecked == 1 ? true : false,
            onChanged: null,
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            noteCheck[i].content != null ? noteCheck[i].content : '',
            style: TextStyle(
                decorationStyle: TextDecorationStyle.double,
                decoration: noteCheck[i].isChecked == 1
                    ? TextDecoration.lineThrough
                    : TextDecoration.none),
          ),
        ),
      ],
    );
  }

  Widget _alarmWidget() {
    if (data.alarm == null) {
      return Positioned(
        top: -5,
        right: 0,
        child: Text(" "),
      );
    }
    /*
    DateTime dob = DateTime.parse('1967-10-12');
    Duration dur =  DateTime.now().difference(dob);
    String differenceInYears = (dur.inDays/365).floor().toString();
    return new Text(differenceInYears + ' years');
    */
    DateTime now = DateTime.now();
    DateTime alrmD = DateTime.parse(data.alarm);
    int diffH = alrmD.difference(now).inHours;
    var L = Icon(Icons.alarm, size: 30);
    if (diffH < 0) {
      L = Icon(Icons.alarm_off, size: 30);
    }
    return Positioned(
      top: -5,
      right: 0,
      child: L,
    );
  }

  _renderWidget() {
    if (data.type == null || data.type == 'text') {
      return _text();
    } else {
      return _chceked();
    }
  }

  @override
  Widget build(BuildContext context) {
    Color newCl = new Color(data.color.toInt());
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          border: selectedNote.indexOf(data.id) > -1? Border.all(color: ThemeData().textSelectionHandleColor,width: 5.0): Border.all(color: newCl),
          color: newCl,
          borderRadius: BorderRadius.all(Radius.circular(16.0))),
      child: Stack(
        children: <Widget>[_renderWidget(), _alarmWidget()],
      ),

      // color: newCl,//new Color(data.color.toInt()),
      margin: EdgeInsets.all(10.0),
    );
  }
}

class GridNoteEmptyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: () {
              dialogAddNote(context);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Icon(Icons.book, size: 180),
                new Text(
                  'Tambah Catatan',
                  style: TextStyle(fontSize: 30),
                ),
              ],
            ),
          )),
    );
  }
}
