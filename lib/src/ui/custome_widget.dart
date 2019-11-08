import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  Widget _title() {
    var title = data.title;
    if(title == null || title == ''){
      return Text('', style: TextStyle(fontSize: 1.0));
    }
    return Container(
                margin: EdgeInsets.only(bottom: 10.0, right: 15),
                child: Text(
                  data.title.toString(),
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
    );
  }
  Widget _text() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _title(),
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
        _title(),
        Expanded(
          child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(top: 0.0, left: 1.0),
              itemCount: noteCheck.length,
              itemExtent: 20.0,
              itemBuilder: (BuildContext context, int index) {
                return _typeListItem(context, noteCheck[index], index);
              }
          ),
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
          padding: EdgeInsets.all(0.0),
          margin: EdgeInsets.all(0.0),
          child: Checkbox(
            value: noteCheck[i].isChecked == 1 ? true : false,
            onChanged: null,
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            noteCheck[i].content != null ? noteCheck[i].content : '',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 12.0,
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
    /*
    DateTime dob = DateTime.parse('1967-10-12');
    Duration dur =  DateTime.now().difference(dob);
    String differenceInYears = (dur.inDays/365).floor().toString();
    return new Text(differenceInYears + ' years');
    */
    // DateTime now = DateTime.now();
    DateTime alrmD = DateTime.parse(data.alarm);
    // int diffH = alrmD.difference(now).inHours;
    return Container(
      padding: EdgeInsets.only(right: 5.0, ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment:  MainAxisAlignment.end,
        children: <Widget>[
          Icon(Icons.alarm, size: 25.0,color: Colors.white,),
          Text(
            DateFormat("kk:mm, dd MMM").format(alrmD), 
            style: TextStyle(fontSize: 10.0, color: Colors.white)
          )
        ],
      )
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
      padding: EdgeInsets.only(top:5.0,left:5.0,bottom: 0.0),
      decoration: BoxDecoration(
          border: selectedNote.indexOf(data.id) > -1? Border.all(color: Colors.black,width: 2.0): Border.all(color: newCl),
          color: newCl,
          borderRadius: BorderRadius.all(Radius.circular(16.0))
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: data.alarm == null ? 158.0 : 132.0,
            padding: EdgeInsets.only(bottom: 0.0),
            child: Stack(
              children: <Widget>[
                _renderWidget(),
              ],
            ),
          ),
          data.alarm == null ? Text('', style: TextStyle(fontSize: 1.0)): _alarmWidget()
        ],
      ),
      // color: newCl,//new Color(data.color.toInt()),
      margin: EdgeInsets.all(5.0),
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
