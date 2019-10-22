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
                    Note note = new Note(title: '', content: '');
                    Navigator.pop(context, true);
                    Navigator.push(
                      c,
                      MaterialPageRoute(
                          builder: (context) => new FormTextPage(note: note)),
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
                    Navigator.pop(context, true);
                    Navigator.popAndPushNamed(c, '/form_list');
                  },
                ),
              ],
            ),
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      return Text('No notes');
                    }

                    List<Note> notes = snapshot.data;

                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        Note note = notes[index];
                        print(note.title + ' = dari list');
                        return GestureDetector(
                          onTap: () {
                            /*
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                  bloc: NotesBloc(),
                                  child: new FormTextPage(note: note)),
                                ),
                            );
                            */
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => new FormTextPage(note: note)) ,
                              );
                          },
                          child: Container(
                            height: 40,
                            child: Text(
                              'Note => ' + note.title.toString(),
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        );
                      },
                    );
                  }

                  // If the data is loading in, display a progress indicator
                  // to indicate that. You don't have to use a progress
                  // indicator, but the StreamBuilder has to return a widget.
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
