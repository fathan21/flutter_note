import 'package:flutter/material.dart';
import 'package:note_f/src/bloc/bloc_provider.dart';
import 'package:note_f/src/bloc/note_bloc.dart';
import 'package:note_f/src/model/note.dart';
import 'package:note_f/src/ui/form_text.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

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

    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    // If you have skipped STEP 3 then change app_icon to @mipmap/ic_launcher
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

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
            onPressed: _showNotificationSchedule,
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

  Future onSelectNotification(String payload) async {
    showDialog(
      context: context,
      builder: (_) {
        return new AlertDialog(
          title: Text("PayLoad"),
          content: Text("Payload : $payload"),
        );
      },
    );
  }
}

// Method 1
Future _showNotificationWithSound() async {
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'your channel id', 'your channel name', 'your channel description',
      sound: 'slow_spring_board',
      importance: Importance.Max,
      priority: Priority.High);
  var iOSPlatformChannelSpecifics =
      new IOSNotificationDetails(sound: "slow_spring_board.aiff");
  var platformChannelSpecifics = new NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    0,
    'New Post',
    'How to Show Notification in Flutter',
    platformChannelSpecifics,
    payload: 'Custom_Sound',
  );
}

// Method 2
Future _showNotificationWithDefaultSound() async {
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'your channel id', 'your channel name', 'your channel description',
      importance: Importance.Max, priority: Priority.High);
  var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
  var platformChannelSpecifics = new NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    0,
    'New Post',
    'How to Show Notification in Flutter',
    platformChannelSpecifics,
    payload: 'Default_Sound',
  );
}

// Method 3
Future _showNotificationWithoutSound() async {
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'your channel id', 'your channel name', 'your channel description',
      playSound: false, importance: Importance.Max, priority: Priority.High);
  var iOSPlatformChannelSpecifics =
      new IOSNotificationDetails(presentSound: false);
  var platformChannelSpecifics = new NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    0,
    'New Post',
    'How to Show Notification in Flutter',
    platformChannelSpecifics,
    payload: 'No_Sound',
  );
}

// Method 4 schedulue
Future _showNotificationSchedule() async {
  var scheduledNotificationDateTime =
      new DateTime.now().add(new Duration(seconds: 15));
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'your other channel id',
      'your other channel name',
      'your other channel description');
  var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
  NotificationDetails platformChannelSpecifics = new NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
      
  await flutterLocalNotificationsPlugin.schedule(
      0,
      'scheduled kukuk',
      'scheduled body',
      scheduledNotificationDateTime,
      platformChannelSpecifics,
      payload: 'Default_Sound');
  
  print('sceduelu notif ' + scheduledNotificationDateTime.toString());
  
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
                  Navigator.pop(c, true);
                  Navigator.push(
                    c,
                    MaterialPageRoute(
                        builder: (c) => new FormTextPage(note: note)),
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

class GridNoteListWidget extends StatelessWidget {
  final List datas;
  const GridNoteListWidget(this.datas);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      scrollDirection: Axis.vertical,
      controller: ScrollController(),
      crossAxisCount: 4,
      children: List.generate(datas.length, (index) {
        var data = datas[index];
        return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => new FormTextPage(note: data)),
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
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Center(
        child: GridTile(
          footer: Text(
            data.title.toString(),
            textAlign: TextAlign.center,
          ),
          header: Text(
            data.created_at.toString(),
            textAlign: TextAlign.center,
          ),
          child: Icon(Icons.access_alarm, size: 40.0, color: Colors.white30),
        ),
      ),
      color: Colors.blue[400],
      margin: EdgeInsets.all(10.0),
    );
  }
}
