import 'package:flutter/material.dart';
import 'package:note_f/src/bloc/bloc_provider.dart';
import 'package:note_f/src/bloc/note_bloc.dart';
import 'package:note_f/src/model/note.dart';
import 'package:note_f/src/ui/form_text.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  NotesBloc _notesBloc;

  @override
  void initState() {
    super.initState();
    _notesBloc = BlocProvider.of<NotesBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(child: ListDrawer()),
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
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
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              // The streambuilder allows us to make use of our streams and display
              // that data on our page. It automatically updates when the stream updates.
              // Whenever you want to display stream data, you'll use the StreamBuilder.
              child: StreamBuilder<List<Note>>(
                stream: _notesBloc.notes,
                builder:
                    (BuildContext context, AsyncSnapshot<List<Note>> snapshot) {
                  // Make sure data exists and is actually loaded
                  if (snapshot.hasData) {
                    // If there are no notes (data), display this message.

                    if (snapshot.data.length == 0) {
                      return GridNoteEmptyWidget();
                    }

                    List<Note> notes = snapshot.data;
                    return GridNoteListWidget(notes);
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future dialogAddNote(BuildContext c) => showDialog(
      context: c,
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
                onPressed: () {},
                child: const Text('Tambah Catatan', style: styleBtn),
              ),
              FlatButton.icon(
                icon: Icon(Icons.list), //`Icon` to display
                label: Text(
                  'Text',
                  style: styleBtn,
                ), //`Text` to display
                onPressed: () {
                  Navigator.pop(c, true);
                  Navigator.push(
                    c,
                    MaterialPageRoute(builder: (c) => new FormTextPage(id: 0)),
                  );
                },
              ),
              FlatButton.icon(
                icon: Icon(Icons.check_box), //`Icon` to display
                label: Text(
                  'Daftar Centang',
                  style: styleBtn,
                ), //`Text` to display
                onPressed: () {
                  Navigator.pop(c, true);
                  Navigator.popAndPushNamed(c, '/form_list');
                },
              ),
            ],
          ),
        );
      },
    );

class ListDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: Text('Drawer Header'),
          decoration: BoxDecoration(
            color: Colors.amber,
          ),
        ),
        ListTile(
          title: Text('Item 1'),
          onTap: () {
            // Update the state of the app
            // ...
            // Then close the drawer
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text('Item 2'),
          onTap: () {
            // Update the state of the app
            // ...
            // Then close the drawer
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class GridNoteListWidget extends StatelessWidget {
  final List datas;
  const GridNoteListWidget(this.datas);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      scrollDirection: Axis.vertical,
      controller: ScrollController(),
      crossAxisCount: 3,
      children: List.generate(datas.length, (index) {
        var data = datas[index];
        return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => new FormTextPage(id: data.id)),
              );
            },
            child: GridNoteItemWidget(data));
      }),
    );
  }
}

class GridNoteItemWidget extends StatelessWidget {
  final data;
  const GridNoteItemWidget(this.data);

  @override
  Widget build(BuildContext context) {
    Color newCl = new Color(data.color.toInt());
    return Container(
      padding: EdgeInsets.all(0.0),
      decoration: BoxDecoration(border: Border.all(color: newCl), color: newCl),
      child: Column(
        children: <Widget>[
          Text(data.title.toString()),
          Text(data.color.toString()),
        ],
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
          onTap: (){
            dialogAddNote(context);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Icon(Icons.book, size:180),
              new Text('Tambah Catatan', style: TextStyle(fontSize: 30),),
            ],
          ),
        )
      ),
    );
  }
}
