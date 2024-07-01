import 'package:flutter/material.dart';

class Message {
  var _date;
  int _id = 0;
  String _msg = "_msg";
  bool _checkBox=false;

  Message(this._date, this._msg);

  Message.map(dynamic obj) {
    this._id = obj['id'];
    this._date = obj['date'];
    this._msg = obj['msg'];
  }

  int get getId => _id;
  String get getDate => _date;
  String get getMsg => _msg;
  bool get getCheckBox => _checkBox;
  void set setCheckBox(bool value) => _checkBox= value;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['date'] = _date;
    map['msg'] = _msg;

    return map;
  }

  Message.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._date = map['date'];
    this._msg = map['msg'];
  }

  static List<Message> loadMsgs() {
    return <Message>[
      Message("8:00", "Mañana traer plastilinas"),
      Message("9:00", "Mañana no hay clases"),
      Message("10:00", "Mañana salida temprano"),
      Message("11:00", "Se suspenden clases por covid"),
      Message("12:00", "Examen final, estudien!"),
    ];
  }
}
