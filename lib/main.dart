import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Login.dart';
import 'SignUp.dart';
import 'Welcome.dart';
import 'DbHelperStudent.dart';
import 'student.dart';
import 'package:workmanager/workmanager.dart';
import 'firebase_options.dart';
import 'dart:async';

@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print(task);
    switch (task) {
      case "simpleTask":
        print("simpleTask case!!!!!!");
        Timer.periodic(const Duration(seconds: 1), (timer) {
          print("Workmanager Background task");
        });
        print("HELLO WORLD");
        break;
    }
    return Future.value(true);
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) {
    Workmanager().initialize(
        callbackDispatcher, // The top level function, aka callbackDispatcher
        isInDebugMode:
            true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
        );
    Workmanager().registerOneOffTask("task-identifier", "simpleTask");

    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    getUsers();
    listenUser();
    super.initState();
  }

  void getUsers() async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection("users");
    QuerySnapshot users = await collection.get();
    if (users.docs.isNotEmpty) {
      for (var doc in users.docs) {
        print(doc.data());
      }
    }
  }

  void listenUser() {
    DocumentReference doc =
        FirebaseFirestore.instance.collection("users").doc("mascota1");
    doc.snapshots().listen((event) {
      Map<String, dynamic> data = event.data()! as Map<String, dynamic>;
      print("Name = ${data['name']}");
      print("raza = ${data['raza']}");
    });
  }

  void updateUser() {
    DocumentReference doc =
        FirebaseFirestore.instance.collection("users").doc("mascota1");
    doc.update({'name': 'Han'}).then((value) {
      print("User Updated");
    }).catchError((onError) {
      print("Failed to update user: $onError");
    });
  }

  Future navigateToLogin(context, String screen) async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Login(title: "Login", screenToGo: screen),
          settings: RouteSettings(name: screen),
        ));
  }

  Future navigateToSignUp(context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SignUp(title: "SignUp"),
          settings: const RouteSettings(name: "/SignUp"),
        ));
  }

  Future navigateToWelcome(context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Welcome(title: "Welcome"),
          settings: const RouteSettings(name: "/Welcome"),
        ));
  }

  Future<void> _defineNextScreen() async {
    String screenToGo;
    /*int pickupKeys = await _checkPickupKeys();
    print("pickupKeys= $pickupKeys");
    if (pickupKeys > 0) {
      screenToGo = "/Status";
    } else {
      screenToGo = "/Welcome";
    }*/
    screenToGo = "/Welcome";
    navigateToLogin(context, screenToGo);
  }

  Future<int> _checkPickupKeys() async {
    DbHelperStudent _db = new DbHelperStudent();
    List<Student> _students = List<Student>.empty();
    List list = await _db.getAllStudents();
    list.forEach((item) {
      print('printing item map');
      print(item['id']);
      print(item['name']);
      print(item['school']);
      print(item['schedule']);
      print(item['expire']);

      var now = new DateTime.now();

      int year = int.parse("20" + item['expire'].substring(0, 2));
      int month = int.parse(item['expire'].substring(2, 4));
      int day = int.parse(item['expire'].substring(4, 6));
      var newDate = new DateTime(year, month, day, 23, 59, 00);

      // date received is greater than current day that means expiration date is in the future
      print("compare to= " + newDate.compareTo(now).toString());
      if (newDate.compareTo(now) > 0) {
        _students.add(Student.fromMap(item));
      } else {
        _db.deleteStudent(item['id']);
      }
    });
    print("_students length= ${_students.length}");
    return _students.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.redAccent,
            image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.15), BlendMode.dstATop),
              image: const AssetImage('assets/images/ninos2.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(top: 250.0),
                          child: const Center(
                            child: Icon(
                              Icons.headset_mic,
                              color: Colors.white,
                              size: 40.0,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "eTracker",
                                style: TextStyle(
                                  fontFamily: 'GloriaHallelujah',
                                  color: Colors.white,
                                  fontSize: 30.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.only(
                              left: 30.0, right: 30.0, top: 100.0),
                          alignment: Alignment.center,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Center(
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                            width: 3.0, color: Colors.black)),
                                    onPressed: () => navigateToSignUp(context),
                                    //navigateToSignUp(context),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 20.0,
                                        horizontal: 20.0,
                                      ),
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              "Crear cuenta",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.only(
                              left: 30.0, right: 30.0, top: 30.0),
                          alignment: Alignment.center,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                          width: 3.0, color: Colors.black)),
                                  //onPressed: () => updateUser(),
                                  onPressed: () => _defineNextScreen(),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 20.0,
                                      horizontal: 20.0,
                                    ),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            "Ingresar",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
