import 'package:flutter/material.dart';
import 'package:note_f/src/bloc/bloc_provider.dart';
import 'package:note_f/src/bloc/note_bloc.dart';
import 'package:note_f/src/helpers/dialog.dart';
import 'package:note_f/src/model/note.dart';
import 'package:note_f/src/ui/custome_widget.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _activemenu = 'Catatan';
  List _selectedNote = [];
  bool _selectedNoteActive = false;
  @override
  void initState() {
    super.initState();
  }
  void _setSelectedNote(id)async {
    var idx = _selectedNote.indexOf(id); 
    if (idx >-1){
      _selectedNote.removeAt(idx);
    }else{
      _selectedNote.add(id);
    }
    _selectedNoteActive = _selectedNote.length > 0 ? true : false;
    setState(() {
      _selectedNote = _selectedNote; 
      _selectedNoteActive = _selectedNoteActive;
    });
  }
  void _removeSelectedNote() async {
    setState(() {
      _selectedNote = []; 
      _selectedNoteActive = false;
    });
  }

  void _setActiveMenu(e) async{
    setState(() {
      _activemenu = e;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _selectedNoteActive ? null : Drawer(
          child: ListDrawer(
              activeMenu: _activemenu, setActiveMenu: _setActiveMenu
          )
      ),
      appBar: AppBar(
        title: _selectedNoteActive ? Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.close),
              onPressed: _removeSelectedNote,
            ),
            Text(_selectedNote.length.toString())
          ],
        ) : Text(widget.title),
        actions: _selectedNoteActive? 
          <Widget>[
            
            IconButton(
              icon: const Icon(Icons.alarm_add),
              tooltip: 'Alarm',
              onPressed: () {
            
              },
            ),
            IconButton(
              icon: new Icon(Icons.archive),
              tooltip: 'Archive',
              onPressed: () {
            
              },
            ),
            IconButton(
              icon: new Icon(Icons.delete),
              tooltip: 'Delete',
              onPressed: () {
            
              },
            ),
          ] : 
          <Widget>[
            IconButton(
              icon: Icon(Icons.add_circle),
              onPressed: () {
                dialogAddNote(context);
              },
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            )
          ],
      ),
      body: WidgetCatatan(
        setSelectedNote: _setSelectedNote,
        removeSelectedNote: _removeSelectedNote,
        selectedNoteActive: _selectedNoteActive,
        selectedNote: _selectedNote,
      )
    );
  }
}

class WidgetCatatan extends StatelessWidget {
  final setSelectedNote;
  final removeSelectedNote;

  final List selectedNote;
  final bool selectedNoteActive;
  
  WidgetCatatan(
    {this.selectedNote,this.selectedNoteActive, this.setSelectedNote, this.removeSelectedNote}
  );
  
  @override
  Widget build(BuildContext context) {
    NotesBloc _notesBloc = BlocProvider.of<NotesBloc>(context);
    return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              // The streambuilder allows us to make use of our streams and display
              // that data on our page. It automatically updates when the stream updates.
              // Whenever you want to display stream data, you'll use the StreamBuilder.
              child: StreamBuilder<List<NoteComp>>(
                stream: _notesBloc.notes,
                builder: (BuildContext context,
                    AsyncSnapshot<List<NoteComp>> snapshot) {
                  // Make sure data exists and is actually loaded
                  // print(snapshot.hasError);
                  if (snapshot.hasData) {
                    // If there are no notes (data), display this message.

                    if (snapshot.data.length == 0) {
                      return GridNoteEmptyWidget();
                    }

                    List<NoteComp> notes = snapshot.data;
                    return GridNoteListWidget(notes,
                        selectedNote: selectedNote,
                        setSelectedNote: setSelectedNote,
                        selectedNoteActive: selectedNoteActive,
                        removeSelectedNote: removeSelectedNote,
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      );
  }
}

class ListDrawer extends StatelessWidget {
  final activeMenu;
  final setActiveMenu;
  const ListDrawer({this.activeMenu, this.setActiveMenu});

  Widget _options(context, {menu, borderBottom}) {
    TextStyle menuTextStyle =
        new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400);
    BoxDecoration menuStyle = BoxDecoration();
    BoxDecoration activeMenuStyle = BoxDecoration(
        color: Colors.brown[200],
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(30.0),
            bottomRight: Radius.circular(30.0)));
    List<Widget> list = new List();
    for (var item in menu) {
      list.add(Container(
        margin: EdgeInsets.only(right: 10.0, bottom: 5.0),
        decoration: activeMenu.toString().toLowerCase() ==
                item["label"].toString().toLowerCase()
            ? activeMenuStyle
            : menuStyle,
        child: ListTile(
          leading: Icon(item["icon"]),
          title: Text(
            item["label"],
            style: menuTextStyle,
          ),
          // trailing: Icon(Icons.arrow_forward),
          onTap: () {
            setActiveMenu(item["label"].toString().toString());
            Navigator.pop(context);
            //
          },
        ),
      ));
    }

    return Container(
      padding: EdgeInsets.only(bottom: 20.0, top: 10.0),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: borderBottom == 1 ? Colors.grey : Colors.transparent,
        width: 1.0,
      ))),
      child: Column(
        children: list,
      ),
    );
  }

  List<Widget> listMyWidgets(context) {
    List<Widget> list = new List();
    list.add(Container(
      height: 90.0,
      padding: EdgeInsets.only(top: 30, left: 16.0),
      margin: EdgeInsets.all(0.0),
      color: ThemeData().primaryColor,
      child: Text(
        "Notepad",
        style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
      ),
    ));
    // activeMenu, menu,borderBottom
    var menu = [
      {"label": "Catatan", "icon": Icons.book},
      {"label": "Pengingat", "icon": Icons.notifications},
    ];

    var menu1 = [
      {"label": "Arsip", "icon": Icons.archive},
      {"label": "Sampah", "icon": Icons.delete},
    ];

    var menu2 = [
      {"label": "Setelan", "icon": Icons.settings},
      {"label": "Bantuan & Masukan", "icon": Icons.help_outline},
    ];
    list.add(_options(
      context,
      borderBottom: 1,
      menu: menu,
    ));
    list.add(_options(context, borderBottom: 1, menu: menu1));
    list.add(_options(context, borderBottom: 0, menu: menu2));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: listMyWidgets(context),
    );
  }
}
