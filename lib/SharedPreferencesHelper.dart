import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SharedPreferencesHelper {
  static final String _carType = "car";
  static String _carColor = "color";
  static final String _carPlate = "plate";
  static final String _email = "status";

  /// ------------------------------------------------------------
  ///
  /// ------------------------------------------------------------
  static Future<String> getCarType () async{
    final EncryptedSharedPreferences prefs = EncryptedSharedPreferences();
    return await prefs.getString(_carType) ?? 'Sedan';
  }

  /// ----------------------------------------------------------
  ///
  /// ----------------------------------------------------------
  static Future<bool> setCarType(String value) {
    final EncryptedSharedPreferences prefs =  EncryptedSharedPreferences();
    return prefs.setString(_carType, value);
  }

  /// ------------------------------------------------------------
  ///
  /// ------------------------------------------------------------
  static Future<String> getEmail() async{
    final EncryptedSharedPreferences prefs = EncryptedSharedPreferences();
    Future <SharedPreferences> pref= prefs.getInstance();
    return await prefs.getString(_email) ?? 'Error';
  }

  /// ----------------------------------------------------------
  ///
  /// ----------------------------------------------------------
  static Future<bool> setEmail(String value) {
    final EncryptedSharedPreferences prefs =  EncryptedSharedPreferences();
    return prefs.setString(_email, value);
  }

  /// ------------------------------------------------------------
  ///
  /// ------------------------------------------------------------
  static Future<Color> getCarColor() async {
    print('getCarColor()');
    final EncryptedSharedPreferences prefs = EncryptedSharedPreferences();
    String colorString= await prefs.getString(_carColor) ?? 'FFFFFFFF';
    int value = int.parse(colorString, radix: 16);
    return Color(value);
  }

  /// ----------------------------------------------------------
  ///
  /// ----------------------------------------------------------
  static Future<bool> setCarColor(Color color) {
    print('setCarColor()');
    String colorString = color.toString(); // Color(0x12345678)
    String valueString = colorString.split('(0x')[1].split(')')[0];
    final EncryptedSharedPreferences prefs= EncryptedSharedPreferences();
    return prefs.setString(_carColor, valueString);
  }

  /// ------------------------------------------------------------
  ///
  /// ------------------------------------------------------------
  static Future<String> getCarPlate() async{
    final EncryptedSharedPreferences prefs = EncryptedSharedPreferences();
    return await prefs.getString(_carPlate) ?? 'Sedan';
  }

  /// ----------------------------------------------------------
  ///
  /// ----------------------------------------------------------
  static Future <bool> setCarPlate(String value){
    final EncryptedSharedPreferences prefs =  EncryptedSharedPreferences();
    return prefs.setString(_carPlate, value);
  }
}