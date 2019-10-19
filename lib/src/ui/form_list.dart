import 'package:flutter/material.dart';


class FormListPage extends StatefulWidget {
  FormListPage({Key key}) : super();

  @override
  _FormListState createState() => _FormListState();
}

class _FormListState extends State<FormListPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form Text'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Form List',
            ),
          ],
        ),
      ), 
    );
  }
}
