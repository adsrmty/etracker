import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dart:async';
import 'NavDrawer.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'dart:ui';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

class Status extends StatefulWidget {
  const Status({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<Status> createState() => _StatusState();
}

class _StatusState extends State<Status> with WidgetsBindingObserver {
  final emailCtrl = TextEditingController();
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  final int _interval = 5;
  int _newInterval = 5;
  double _distance = 0;
  var _position;

  Future<void> initializeForegroundService() async {
    final service = FlutterBackgroundService();

    /// OPTIONAL, using custom notification channel id
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'my_foreground', // id
      'MY FOREGROUND SERVICE', // title
      description:
      'This channel is used for important notifications.', // description
      importance: Importance.low, // importance must be at low or higher level
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    if (Platform.isIOS || Platform.isAndroid) {
      await flutterLocalNotificationsPlugin.initialize(
        const InitializationSettings(
          iOS: DarwinInitializationSettings(),
          android: AndroidInitializationSettings('ic_bg_service_small'),
        ),
      );
    }

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        // this will be executed when app is in foreground or background in separated isolate
        onStart: onStart,

        // auto start service
        autoStart: true,
        isForegroundMode: true,

        notificationChannelId: 'my_foreground',
        initialNotificationTitle: 'AWESOME SERVICE',
        initialNotificationContent: 'Initializing',
        foregroundServiceNotificationId: 888,
      ),
      iosConfiguration: IosConfiguration(
        // auto start service
        autoStart: true,

        // this will be executed when app is in foreground in separated isolate
        onForeground: onStart,

        // you have to enable background fetch capability on xcode project
        onBackground: onIosBackground,
      ),
    );
  }

// to ensure this is executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch

  @pragma('vm:entry-point')
  Future<bool> onIosBackground(ServiceInstance service) async {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.reload();
    final log = preferences.getStringList('log') ?? <String>[];
    log.add(DateTime.now().toIso8601String());
    await preferences.setStringList('log', log);

    return true;
  }

  @pragma('vm:entry-point')
  void onStart(ServiceInstance service) async {
    // Only available for flutter 3.0.0 and later
    DartPluginRegistrant.ensureInitialized();

    // For flutter prior to version 3.0.0
    // We have to register the plugin manually

    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString("hello", "world");

    /// OPTIONAL when use custom notification
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    if (service is AndroidServiceInstance) {
      service.on('setAsForeground').listen((event) {
        service.setAsForegroundService();
      });

      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService();
      });
    }

    service.on('stopService').listen((event) {
      print("stopService . . . . . . . ");
      service.stopSelf();
    });

    // bring to foreground
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (service is AndroidServiceInstance) {
        print("service is AndroidServiceInstance");
        if (await service.isForegroundService()) {
          print("isForegroundService");

          /// OPTIONAL for use custom notification
          /// the notification id must be equals with AndroidConfiguration when you call configure() method.
          flutterLocalNotificationsPlugin.show(
            888,
            'COOL SERVICE',
            'Awesome ${DateTime.now()}',
            const NotificationDetails(
              android: AndroidNotificationDetails(
                'my_foreground',
                'MY FOREGROUND SERVICE',
                icon: 'ic_bg_service_small',
                ongoing: true,
              ),
            ),
          );

          // if you don't using custom notification, uncomment this
          service.setForegroundNotificationInfo(
            title: "etracker APP",
            content:
            "Using the GPS from your phone to know when you arrive to the school}",
          );
        }
      }

      /// you can see this log in logcat
      print('FLUTTER SERVICE: ${DateTime.now()}');

      // test using external plugin
      final deviceInfo = DeviceInfoPlugin();
      String? device;
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        device = androidInfo.model;
      }

      if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        device = iosInfo.model;
      }

      service.invoke(
        'update',
        {
          "current_date": DateTime.now().toIso8601String(),
          "device": device,
        },
      );
    });
  }

  @pragma('vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
  void callbackDispatcher() {
    Workmanager().executeTask((task, inputData) async {
      Timer.periodic(const Duration(seconds: 1), (timer) {
        print("Backgorund task using callbackDispatcher");
      });
      return Future.value(true);
    });
  }

  @override
  initState() {
    //getLocation();
    //initForegroundService();
    //startForegroundService();

    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  Future<void> initForegroundService() async {
    await initializeForegroundService();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("didChangeAppLifecycleState");
    print(state);
  }

  Future<void> startForegroundService() async {
    final service = FlutterBackgroundService();
    var isRunning = await service.isRunning();
    if (!isRunning) {
      service.invoke("setAsForeground");
      service.startService();
    }
  }

  Future<void> stopForegroundService() async {
    print("stopForegroundService");
    final service = FlutterBackgroundService();
    var isRunning = await service.isRunning();
    if (isRunning) {
      print("Stopping the Foreground service");
      service.invoke("stopService");
    }
  }

  Future<void> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    bool hasPermission = false;
    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();

    if (!serviceEnabled) {
      print("Services are not enable");
      return;
    }
    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      print("LocationPermission.denied requesting Permission");
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }
    createPeriodicTask(_interval);
  }

  void createPeriodicTask(int interval) {
    Timer.periodic(Duration(seconds: interval), (Timer timer) async {
      _newInterval = interval;
      _position = await _geolocatorPlatform.getCurrentPosition(
          locationSettings:
          const LocationSettings(accuracy: LocationAccuracy.best));
      _distance = _geolocatorPlatform.distanceBetween(
          _position.latitude, _position.longitude, 25.763156, -100.132755);
      print(
          "latitude= ${_position.latitude} - longitud= ${_position.longitude} - altitude = ${_position.altitude} - distance= $_distance");

      DocumentReference doc =
      FirebaseFirestore.instance.collection("users").doc("0000-0000-0001");

      doc.update({
        'currentPosition': _position.toString(),
        'distance': _distance
      }).then((value) {
        print("currentPosition Updated");
      }).catchError((onError) {
        print("Failed to update user: $onError");
      });

      if (_distance <= 100) {
        _newInterval = 5;
      } else if (_distance > 100 && _distance <= 200) {
        _newInterval = 20;
      } else if (_distance > 200 && _distance <= 300) {
        _newInterval = 30;
      } else if (_distance > 300 && _distance <= 400) {
        _newInterval = 40;
      } else if (_distance > 400 && _distance <= 500) {
        _newInterval = 50;
      } else if (_distance > 500 && _distance <= 600) {
        _newInterval = 60;
      } else if (_distance > 600 && _distance <= 700) {
        _newInterval = 70;
      } else if (_distance > 700 && _distance <= 800) {
        _newInterval = 80;
      } else if (_distance > 800 && _distance <= 900) {
        _newInterval = 90;
      } else {
        _newInterval = 600;
      }

      setState(() {});
      if (interval != _newInterval) {
        print(
            "Timer has changed due distance changed - interval= $interval - newInterval= $_newInterval");
        timer.cancel();
        createPeriodicTask(_newInterval);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print('HIIIIIIII');
        MoveToBackground.moveTaskToBack();
        return false;
      },
      child: Scaffold(
        drawer: NavDrawer(),
        appBar: AppBar(
          title: Text("Hello Appbar"),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {},
                  child: const Icon(
                    Icons.search,
                    size: 26.0,
                  ),
                )),
          ],
        ),
        body: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.1), BlendMode.dstATop),
                image: AssetImage('assets/images/ninos2.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(0),
                  margin:
                  const EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      image: DecorationImage(
                        image: AssetImage('assets/images/background.jpg'),
                        fit: BoxFit.fill,
                      )),
                  child: SizedBox(
                    width: double.infinity,
                    height: 160,
                    child: Stack(
                      children: <Widget>[
                        SizedBox.expand(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: 20.0),
                                child: const Text(
                                  'Current Position',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10.0),
                                child: Position != null
                                    ? Text(
                                  _position.toString(),
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                                    : const Text(
                                  "0",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(0),
                  margin: const EdgeInsets.only(left: 30.0, right: 30.0),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      image: DecorationImage(
                        image: AssetImage('assets/images/background.jpg'),
                        fit: BoxFit.fill,
                      )),
                  child: SizedBox(
                    width: double.infinity,
                    height: 160,
                    child: Stack(
                      children: <Widget>[
                        SizedBox.expand(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: 20.0),
                                child: const Text(
                                  'Target Position',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10.0),
                                child: const Text(
                                  "Latitude: 25.76315612\n"
                                      "Longitude: -100.132755",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(0),
                  margin: const EdgeInsets.only(left: 30.0, right: 30.0),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      image: DecorationImage(
                        image: AssetImage('assets/images/background.jpg'),
                        fit: BoxFit.fill,
                      )),
                  child: SizedBox(
                    width: double.infinity,
                    height: 110,
                    child: Stack(
                      children: <Widget>[
                        SizedBox.expand(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: const Text(
                                  'New Interval',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10.0),
                                child: _newInterval != null
                                    ? Text(
                                  _newInterval.toString(),
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                                    : const Text(
                                  "0",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(0),
                  margin: const EdgeInsets.only(
                      left: 30.0, right: 30.0, bottom: 30.0),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      image: DecorationImage(
                        image: AssetImage('assets/images/background.jpg'),
                        fit: BoxFit.fill,
                      )),
                  child: SizedBox(
                    width: double.infinity,
                    height: 110,
                    child: Stack(
                      children: <Widget>[
                        SizedBox.expand(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: const Text(
                                  'Distance',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10.0),
                                child: _distance != null
                                    ? Text(
                                  _distance.toString(),
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                                    : const Text(
                                  "0",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                /* Container(
                padding: EdgeInsets.all(0),
                margin: EdgeInsets.only(left: 30.0, right: 30.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: EdgeInsets.only(left: 10.0, right: 5.0),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            image: DecorationImage(
                              image: AssetImage('assets/images/background.jpg'),
                              fit: BoxFit.fill,
                            )),
                        child: SizedBox(
                          width: double.infinity,
                          height: 210,
                          child: InkWell(
                            onTap: () => print('Hello World'),
                            child: Stack(
                              children: <Widget>[
                                SizedBox.expand(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(top: 20.0),
                                        child: Text(
                                          'Mensajes',
                                          style: TextStyle(
                                            fontSize: 30.0,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 0.0),
                                        child: Text(
                                          'por leer',
                                          style: TextStyle(
                                            fontSize: 30.0,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        //color: Colors.redAccent,
                                        margin: EdgeInsets.only(
                                            top: 0.0, bottom: 0.0),
                                        padding: EdgeInsets.all(0.0),
                                        child: Text(
                                          '5',
                                          style: TextStyle(
                                            fontSize: 60.0,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Container(
                                          //margin: EdgeInsets.only(top: 10.0),
                                          padding: EdgeInsets.all(0.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              Icon(
                                                Icons.navigate_next,
                                                size: 40,
                                              ),
                                            ],
                                          ))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: EdgeInsets.only(left: 10.0, right: 5.0),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            image: DecorationImage(
                              image: AssetImage('assets/images/background.jpg'),
                              fit: BoxFit.fill,
                            )),
                        child: SizedBox(
                          width: double.infinity,
                          height: 210,
                          child: InkWell(
                            onTap: () {
                              navigateToLogin(context);
                            },
                            child: Stack(
                              children: <Widget>[
                                SizedBox.expand(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(top: 20.0),
                                        child: Text(
                                          'Alumnos',
                                          style: TextStyle(
                                            fontSize: 30.0,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 0.0),
                                        child: Text(
                                          'registrados',
                                          style: TextStyle(
                                            fontSize: 30.0,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        //color: Colors.redAccent,
                                        margin: EdgeInsets.only(
                                            top: 0.0, bottom: 0.0),
                                        padding: EdgeInsets.all(0.0),
                                        child: Text(
                                          '3',
                                          style: TextStyle(
                                            fontSize: 60.0,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Container(
                                          //margin: EdgeInsets.only(top: 10.0),
                                          padding: EdgeInsets.all(0.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              Icon(
                                                Icons.navigate_next,
                                                size: 40,
                                              ),
                                            ],
                                          ))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
