import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:untitled/screens/noteDetail.dart';
import 'dart:async';
import 'package:untitled/models/note.dart';
import 'package:untitled/utils/databaseHelper.dart';





class noteList extends StatefulWidget {
   noteList({Key? key}) : super(key: key);

  @override
  State<noteList> createState() => _noteListState();
}

class _noteListState extends State<noteList> {

  databaseHelper DatabaseHelper = databaseHelper();
  List<Note> NoteList = [];
  int count = 0;

  @override
  Widget build(BuildContext context) {

    if (NoteList == null){
      NoteList = <Note>[];
     }

    return Scaffold(
      appBar: AppBar(
        title: Text('Note'),
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            debugPrint('fab click');
            navigateToDetail(Note('','',2), 'Add Note');
          },
          tooltip: 'addote',
          child: const Icon(Icons.add),

    ),

    );
  }

  ListView getNoteListView() {
    TextStyle? titleStyle = Theme.of(context).textTheme.subtitle1;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return  Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(

            leading: CircleAvatar(
              backgroundColor: getPriorityColor(this.NoteList[position].priority),
              child: getPriorityIcon(this.NoteList[position].priority),
            ),
            title: Text(this.NoteList[position].title),
            subtitle: Text(this.NoteList[position].date),
            trailing: GestureDetector(
            child: Icon(Icons.delete, color: Colors.grey,),
            onTap: (){
              _delete(context, NoteList[position]);
            },
            ),
              onTap: (){
              navigateToDetail(this.NoteList[position] ,'Edit Note');
              },
          ),
        );
      },
    );
  }


  //get priority color
  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;
      default:
        return Colors.yellow;
    }
  }

  //get priority icon
    Icon getPriorityIcon(int priority){

      switch(priority){
        case 1:
          return Icon(Icons.play_arrow);
          break;
        case 2:
          return Icon(Icons.keyboard_arrow_right);
          break;
        default:
          return Icon(Icons.keyboard_arrow_right);
      }
    }

    void _delete(BuildContext context, Note note) async {
    
    int result = await DatabaseHelper.deleteNote(note.id);
    if(result != 0){
      _showSnackBar(context, 'Note Delete Succesfully');
      updatListView();
    }
   }

   void _showSnackBar(BuildContext context, String message){

    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
   }

  void navigateToDetail(Note note, String title) async{
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context){
      return noteDetail(note, title);
    }));

    if(result==true){
      updatListView();
    }
  }

  void updatListView(){

    final Future<Database> dbFuture = DatabaseHelper.initializeDatabase();
    dbFuture.then((database){
      Future<List<Note>> noteListFuture = DatabaseHelper.getNoteList();
      noteListFuture.then((NoteList){
        setState(() {
          this.NoteList = NoteList;
          this.count = NoteList.length;
        });
      });

    });
  }




}