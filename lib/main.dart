// @dart=2.9
import 'package:flutter/material.dart';
import 'package:untitled/screens/noteDetail.dart';
import 'package:untitled/screens/noteList.dart';

void main() {
  runApp(MyAppp());
}

class MyAppp extends StatelessWidget {
  const MyAppp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NoteKeeper',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home:  noteList(),
    );
  }
}

