
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled/models/note.dart';
import 'package:untitled/utils/databaseHelper.dart';






class noteDetail extends StatefulWidget {

 final String appBarTitle;
 final Note note;

  noteDetail(this.note, this.appBarTitle, {Key? key}) : super(key: key);

  @override
  State<noteDetail> createState() => _noteDetailState(this.note, this.appBarTitle);
}

class _noteDetailState extends State<noteDetail> {

  static var _priorities = ['High', 'Low'];
  databaseHelper helper = databaseHelper();
  String appBarTitle;
  Note note;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  _noteDetailState(this.note, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme
        .of(context)
        .textTheme
        .subtitle1;

    titleController.text = note.title;
    descriptionController.text = note.description;
    return WillPopScope(
        onWillPop: () async {
          moveToLastScreen();
         return true; },
        child: Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
            leading: IconButton(icon: Icon(
                Icons.arrow_back
            ),
              onPressed: () {
                moveToLastScreen();
              },
            ),
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: DropdownButton(
                    items: _priorities.map((String dropDownStringItem) {
                      return DropdownMenuItem<String>(
                        value: dropDownStringItem,
                        child: Text(dropDownStringItem),
                      );
                    }).toList(),
                    style: textStyle,
                    value: getPriorityAsString(note.priority),
                    onChanged: (valueSelectedByUser) {
                      setState(() {
                        debugPrint('User Selected $valueSelectedByUser');
                        updatePriorityAsInt(valueSelectedByUser.toString());
                      });
                    },
                  ),
                ),

                //Second Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: titleController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Somthing chng in title');
                      updateTitle();
                    },
                    decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                  ),
                ),

                //3rd Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: descriptionController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Somthing chng in Description');
                      updateDescription();
                    },
                    decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                  ),
                ),

                //fourthElement
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _save();
                            });
                          },
                          child: Text(
                            'Save',
                          ),
                        ),
                      ),

                      SizedBox(width: 5.0,),

                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _delete();
                            });
                          },
                          child: Text(
                            'Delete',
                          ),
                        ),
                      ),
                    ],
                  ),
                )

              ],
            ),
          ),
        )
    );
  }

    void moveToLastScreen() {
      Navigator.pop(this.context, true);
    }
    //convert string to int
    void updatePriorityAsInt(String value) {
      switch (value) {
        case 'High':
          note.priority = 1;
          break;
        case 'Low':
          note.priority = 2;
          break;
      }
    }

//convert int priority to string
    String getPriorityAsString(int value) {
      String? priority;
      switch (value) {
        case 1:
          priority = _priorities[0];
          break;
        case 2:
          priority = _priorities[1];
          break;
      }
      return priority!;
    }

    void updateTitle() {
      note.title = titleController.text;
    }

    void updateDescription() {
      note.description = descriptionController.text;
    }

//SAVE BUTTON
    void _save() async {
      note.date = DateFormat.yMMMd().format(DateTime.now());
      int result;
      if (note.id != null) {
        result = await helper.updateNote(note);
      } else {
        result = await helper.insertNote(note);
      }
      if (result != 0) {
        _showAlertDialog('Status', 'Note Saved Succesfully');
      }
      else {
        _showAlertDialog('Status', 'Problem saving Note');
      }
    }

    //Delete button
    void _delete() async {
      if (note.id == null) {
        _showAlertDialog('Status', 'No Note Delete ');
        return;
      }


      int result = await helper.deleteNote(note.id);
      if (result != 0) {
        _showAlertDialog('Status', 'Note Delete Succsec');
      } else {
        _showAlertDialog('Status', 'Erororr occured');
      }
    }

    void _showAlertDialog(String title, String message) {
      AlertDialog alertDialog = AlertDialog(
        title: Text(title),
        content: Text(message),
      );
      showDialog(
          context: this.context,
          builder: (_) => alertDialog
      );
    }
  }


