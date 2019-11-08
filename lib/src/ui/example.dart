import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path_provider/path_provider.dart';

import 'package:path/path.dart';

class Example extends StatefulWidget {
  createState() => _ExampleSate();
}

class _ExampleSate extends State<Example> {
  File _image;
  createDir() async {
    // Directory baseDir = await getExternalStorageDirectory();

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path; //only for Android
    // Directory baseDir = await getApplicationDocumentsDirectory(); //works for both iOS and Android
    String dirToBeCreated = "img";
    String finalDir = join(appDocPath, dirToBeCreated);
    var dir = Directory(finalDir);
    bool dirExists = await dir.exists();
    if (!dirExists) {
      dir.create(
          /*recursive=true*/); //pass recursive as true if directory is recursive
    }
    //Now you can use this directory for saving file, etc.
    //In case you are using external storage, make sure you have storage permissions.
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.music_note),
                    title: new Text('Music'),
                    onTap: () => {
                      _choose('camera', context)
                    }),
                new ListTile(
                  leading: new Icon(Icons.videocam),
                  title: new Text('Video'),
                  onTap: () => {
                      _choose('galery', context)
                  },
                ),
              ],
            ),
          );
        });
  }

  void _choose(type, context) async {
    // file = await ImagePicker.pickImage(source: ImageSource.camera);
    // _image = await ImagePicker.pickImage(source: ImageSource.gallery);
    File selected;
    if (type == 'camera'){    
      selected = await ImagePicker.pickImage(source: ImageSource.camera);
    } else{
      selected = await ImagePicker.pickImage(source: ImageSource.gallery);
    }

    // using your method of getting an image

    await createDir();

    imageCache.clear();
    // return;
    // getting a directory path for saving
    // Directory appDocDir = await getApplicationDocumentsDirectory();
    // String appDocPath = appDocDir.path;
    // Directory tempDir = await getTemporaryDirectory();
    // String tempPath = tempDir.path;

    if(selected == null){
      return;
    }
    // copy the file to a new path
    // final File newImage = await selected.copy('$appDocPath/img/image1.png');
    setState(() {
      _image = null;
    });
    
      setState(() {
        _image = selected;
      });
      Navigator.pop(context);
    Timer(Duration(seconds: 3), () {
      // print("print after every 3 seconds");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("gb")),
      body: Center(
          child: SingleChildScrollView(
              child: Column(
        children: <Widget>[
          RaisedButton(
            color: Colors.red,
            child: Text("gambar"),
            onPressed: () {
              _settingModalBottomSheet(context);
            },
          ),
          Image.asset(
            'assets/img/kl.jpg',
            height: 50,
          ),
          Image.network(
            'https://github.com/flutter/plugins/raw/master/packages/video_player/doc/demo_ipod.gif?raw=true',
            height: 50,
          ),
          _image == null ? Text('No image selected.') : Image.file(_image),
        ],
      ))),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.blue,
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
        ),
      ),
    );
  }
}
