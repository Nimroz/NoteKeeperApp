import 'package:flutter/material.dart';


class Note{

  int? _id;
  String? _title;
  String? _description;
  String? _date;
  int? _priority;

  Note(this._title, this._date, this._priority,[this._description]);

  Note.withId(this._id,this._title, this._date, this._priority,this._description);

  int get id => _id!;
  String get title => _title!;
  String get description => _description!;
  String get date => _date!;
  int get priority => _priority!;


  set title(String newTitle) {
    if (newTitle.length <= 255) {
      _title = newTitle;
    }
  }
    set description(String newdescription) {
      if (newdescription.length <= 255) {
        _description = newdescription;
      }
    }

  set priority(int newPriority) {
    if (newPriority >= 1 && newPriority <= 2) {
      _priority = newPriority;
    }
  }

  set date(String newDate) {
      _date = newDate;
  }
    
    //Convert Note object into Map object
    Map<String, dynamic> toMap(){
     var map = <String, dynamic>{};

     if(id != null ){
       map['id'] = _id;
     }

     map['title'] = _title;
     map['description'] = _description;
     map['priority'] = _priority;
     map['date'] = _date;

     return map;
    }

    //Extract a Note Objext From Map objext

    Note.fromMapObject(Map<String, dynamic> map){
      _id = map['id'];
      _title = map['titile'];
      _description = map['description'];
      _priority = map['priority'];
      _date = map['date'];

    }

  }
