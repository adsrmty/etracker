import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';


class SharedPreferencesHelper {
  static final String _carType = "car";
  static String _carColor = "color";
  static final String _carPlate = "plate";

  /// ------------------------------------------------------------
  ///
  /// ------------------------------------------------------------
  static Future <String> getCarType(){
    final EncryptedSharedPreferences prefs = EncryptedSharedPreferences();
    return prefs.getString(_carType) ?? 'Sedan';
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
  static Future<Color> getCarColor() async {
    print('getCarColor()');
    final EncryptedSharedPreferences prefs = EncryptedSharedPreferences();
    String colorString= await prefs.getString(_carColor) ?? 'FFFFFFFF';
    int value = int.parse(colorString, radix: 16);
    return new Color(value);
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
  static Future<String> getCarPlate(){
    final EncryptedSharedPreferences prefs = EncryptedSharedPreferences();
    return prefs.getString(_carPlate) ?? 'Sedan';
  }

  /// ----------------------------------------------------------
  ///
  /// ----------------------------------------------------------
  static Future <bool> setCarPlate(String value){
    final EncryptedSharedPreferences prefs =  EncryptedSharedPreferences();
    return prefs.setString(_carPlate, value);
  }
}