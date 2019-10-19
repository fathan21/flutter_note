import 'package:flutter/material.dart';


class FormTextPage extends StatefulWidget {
  FormTextPage({Key key}) : super();

  @override
  _FormTextState createState() => _FormTextState();
}

class _FormTextState extends State<FormTextPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form List'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Form Text',
            ),
          ],
        ),
      ), 
    );
  }
}
