import 'package:flutter/material.dart';

class Student {
  int _id;
  String _pickupKey;
  String _schoolKey;
  String _name;
  String _school;
  String _schedule;
  String _expire;
  bool _checkBox=false;

  Student(this._pickupKey, this._schoolKey, this._name, this._school, this._schedule, this._expire){
    print('El nombre= ' + this._name);
  }

  int get getId => _id;
  String get getPickupKey => _pickupKey;
  String get getSchoolKey => _schoolKey;
  String get getName => _name;
  String get getSchool => _school;
  String get getSchedule => _schedule;
  bool get getExpire => _checkBox;
  void set setExpire(String value) => _expire= value;
  bool get getCheckBox => _checkBox;
  void set setCheckBox(bool value) => _checkBox= value;

  Student.map(dynamic obj) {
    this._id = obj['id'];
    this._name = obj['pickupKey'];
    this._school = obj['schoolKey'];
    this._name = obj['name'];
    this._school = obj['school'];
    this._schedule = obj['schedule'];
    this._expire = obj['expire'];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['pickupKey'] = _name;
    map['schoolKey'] = _school;
    map['name'] = _name;
    map['school'] = _school;
    map['schedule'] = _schedule;
    map['expire'] = _expire;


    return map;
  }

  Student.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._pickupKey = map['pickupKey'];
    this._schoolKey = map['schoolKey'];
    this._name = map['name'];
    this._school = map['school'];
    this._schedule = map['schedule'];
    this._expire = map['expire'];
  }

}
