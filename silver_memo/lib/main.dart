import 'package:flutter/material.dart';
import 'package:silver_memo/notes_list.dart';
import 'package:silver_memo/root_page.dart';


void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes:<String, WidgetBuilder>{
        '/notes_list':(BuildContext context) => new NotesList(),
      },
      title: '앗!나의계정',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: RootPage(),
    );
  }
}
