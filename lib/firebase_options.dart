// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB0OwEfy367plRCXH7VNiS8fNdRaKSBv6M',
    appId: '1:1055814486964:web:78a2397148c230bc8a80e1',
    messagingSenderId: '1055814486964',
    projectId: 'etracker-c62ce',
    authDomain: 'etracker-c62ce.firebaseapp.com',
    storageBucket: 'etracker-c62ce.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAcDxKxmgs2ovhm_Ykfhg3A-oriy-NEcrA',
    appId: '1:1055814486964:android:171ebc22a75d968a8a80e1',
    messagingSenderId: '1055814486964',
    projectId: 'etracker-c62ce',
    storageBucket: 'etracker-c62ce.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBPwoOthNqrWezQtjmz6JuMQq7ck2M06WE',
    appId: '1:1055814486964:ios:f8fa61db675f4ae08a80e1',
    messagingSenderId: '1055814486964',
    projectId: 'etracker-c62ce',
    storageBucket: 'etracker-c62ce.appspot.com',
    iosBundleId: 'com.wisol.mx.etracker',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBPwoOthNqrWezQtjmz6JuMQq7ck2M06WE',
    appId: '1:1055814486964:ios:73534be47c7d76628a80e1',
    messagingSenderId: '1055814486964',
    projectId: 'etracker-c62ce',
    storageBucket: 'etracker-c62ce.appspot.com',
    iosBundleId: 'com.wisol.mx.etracker.RunnerTests',
  );
}
