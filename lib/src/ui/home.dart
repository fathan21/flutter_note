import 'package:flutter/material.dart';
import 'package:note_f/src/helpers/dialog.dart';
import 'package:note_f/src/helpers/toast.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_circle),
            onPressed: (){
              Toast.show("login success", context, type: Toast.NORMAL, gravity: Toast.TOP);
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: (){
              showAlert(context,title:'yakin');
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Home',
            ),
          ],
        ),
      ),
    );
  }
}
