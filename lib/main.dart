import 'package:flutter/material.dart';
import 'package:note_f/src/ui/form_list.dart';
import 'package:note_f/src/ui/form_text.dart';
import 'package:note_f/src/ui/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(title: 'note'),
        '/form_list': (context) => FormListPage(),
        '/form_text': (context) => FormTextPage(),
      },
    );
  }
}
