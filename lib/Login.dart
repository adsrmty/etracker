import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:etracker/students.dart';
import 'package:etracker/VehicleSettings.dart';
import 'package:http/http.dart';
import 'SignUp.dart';
import 'Welcome.dart';
import 'RecoverPassword.dart';
import 'SecureStorage.dart';
import 'SharedPreferencesHelper.dart';
import 'DbHelperStudent.dart';
import 'student.dart';
import 'Status.dart';

class Login extends StatefulWidget {
  const Login({super.key, required this.title, required this.screenToGo});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final String screenToGo;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final String WEBPAGE = 'https://etracker.mx/etsAppInterface/dbConnETS.php';
  final String WEBPAGE2 = 'http://10.0.2.2:3000';
  final String TERMS_MSG =
      'Al utilizar nuestros servicios, nos confías tus datos. '
      'Entendemos que es una gran responsabilidad y nos esforzamos al máximo para '
      'proteger tu información y permitirte controlarla. El objetivo de esta Política'
      ' de Privacidad es informarte sobre qué datos recogemos, por qué los recogemos'
      ' y cómo puedes actualizarlos, gestionarlos, exportarlos y eliminarlos.';
  final int RESULT_STATUS = 1;
  final int ADMIN_STATUS = 2;
  DbHelperStudent _db = DbHelperStudent();
  final SecureStorage secureStorage = SecureStorage();
  bool _isButtonDisabled = true;

  Future navigateToWelcome(context) async {
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Welcome(title: "Welcome"),
          settings: RouteSettings(name: "/Welcome"),
        ));
  }

  Future navigateToStudents(context) async {
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Students(title: "Students"),
          settings: RouteSettings(name: "/Students"),
        ));
  }

  Future navigateToStatus(context) async {
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Status(title: "Status"),
          settings: RouteSettings(name: "/Status"),
        ));
  }

  Future navigateToVehicleSettings(context) async {
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const VehicleSettings(title: "VehicleSettings"),
          settings: RouteSettings(name: "/VehicleSettings"),
        ));
  }

  Future navigateToSetReferencePoint(context) async {
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const VehicleSettings(title: "VehicleSettings"),
          settings: RouteSettings(name: "/SetReferencePoint"),
        ));
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _login(String screenToGo) async {
    DbHelperStudent _db = DbHelperStudent();
    // Debug, remove below row.
    _db.deleteDb();
    navigateToWelcome(context);
    /*
    print('User=' + emailCtrl.text + ' password=' + passwordCtrl.text);
    var map = Map<String, dynamic>();
    map['action'] = 'login';
    map['input1'] = emailCtrl.text;
    map['input2'] = passwordCtrl.text;
    Response response = await post(Uri.parse(WEBPAGE), body: map);
    print("Response: " + response.body);
    var list = response.body.split(",");
    if (response.body.contains("Error")) {
      print("Login Success!!!");

      DbHelperStudent _db = DbHelperStudent();

      // Debug, remove below row.
      _db.deleteDb();

      //print("response.body= " + response.body);
      //print("list[$RESULT_STATUS]= " + list[RESULT_STATUS]);
      //print("list[$ADMIN_STATUS]= " + list[ADMIN_STATUS]);
      //print("screen= " + screenToGo);

      //if (list[ADMIN_STATUS] == 'admin') {
      secureStorage.writeSecureData('admin', '2tr1ck2r');
      //} else {
      //  secureStorage.writeSecureData('admin', 'false');
      //}

      SharedPreferencesHelper.setEmail(emailCtrl.text);

      if (screenToGo == '/Status') {
        navigateToStatus(context);
      } else if (screenToGo == '/Welcome') {
        navigateToWelcome(context);
      } else if (screenToGo == '/Students') {
        navigateToStudents(context);
      } else if (screenToGo == '/VehicleSettings') {
        navigateToVehicleSettings(context);
      } else if (screenToGo == '/SetReferencePoint') {
        navigateToVehicleSettings(context);
      }
    } else {
      print("RESULT_STATUS = $RESULT_STATUS");
      print("Error = " + list[RESULT_STATUS]);
      _showDialog('Error', list[RESULT_STATUS]);
    }
    */

  }

  Future<int> _checkPickupKeys() async {
    List<Student> students = List<Student>.empty();
    List list = await _db.getAllStudents();
    list.forEach((item) {
      print('printing item map');
      print(item['id']);
      print(item['name']);
      print(item['school']);
      print(item['schedule']);
      print(item['expire']);

      var now = DateTime.now();

      int year = int.parse("20" + item['expire'].substring(0, 2));
      int month = int.parse(item['expire'].substring(2, 4));
      int day = int.parse(item['expire'].substring(4, 6));
      var newDate = DateTime(year, month, day, 23, 59, 00);

      // date received is greater than current day that means expiration date is in the future
      print("compare to= " + newDate.compareTo(now).toString());
      if (newDate.compareTo(now) > 0) {
        students.add(Student.fromMap(item));
      } else {
        _db.deleteStudent(item['id']);
      }
    });
    print("_students length= ${students.length}");
    return students.length;
  }

  void _showDialog(String title, String msg) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(title),
          content: Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            TextButton(
              child: const Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future navigateToRecoverPassword(context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const RecoverPassword(title: "RecoverPassword")));
  }

  Future navigateToSignUp(context) async {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const SignUp(title: "SignUp")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.1), BlendMode.dstATop),
              image: AssetImage('assets/images/ninos2.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(60.0),
                child: const Center(
                  child: Icon(
                    Icons.headset_mic,
                    color: Colors.redAccent,
                    size: 50.0,
                  ),
                ),
              ),
              const Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 40.0),
                      child: Text(
                        "Correo electrónico",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin:
                    const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: Colors.redAccent,
                        width: 2,
                        style: BorderStyle.solid),
                  ),
                ),
                padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        obscureText: false,
                        textAlign: TextAlign.left,
                        controller: emailCtrl,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'JuanGozalez@cambridgecollege.com',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 24.0,
              ),
              const Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 40.0),
                      child: Text(
                        "Contraseña",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin:
                    const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: Colors.redAccent,
                        width: 2,
                        style: BorderStyle.solid),
                  ),
                ),
                padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: passwordCtrl,
                        obscureText: true,
                        textAlign: TextAlign.left,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '*********',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    height: 50.0,
                    padding:
                        const EdgeInsets.only(right: 20.0, top: 0, bottom: 0),
                    child: TextButton(
                      child: const Text(
                        "Olvidaste tu contraseña?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                          fontSize: 15.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () => {navigateToRecoverPassword(context)},
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    height: 50.0,
                    padding: const EdgeInsets.only(right: 20.0),
                    child: TextButton(
                      child: const Text(
                        "No tienes cuenta?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                          fontSize: 15.0,
                        ),
                        textAlign: TextAlign.end,
                      ),
                      onPressed: () => {
                        navigateToSignUp(context),
                      },
                    ),
                  ),
                ],
              ),
              Container(
                margin:
                    const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Al ingresar, aceptas nuestros ',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: 'Términos y Politica de Privacidad',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            //launch('https://www.gmail.com ');
                            _showDialog('Términos y Políticas de Privacidad',
                                TERMS_MSG);
                          },
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin:
                    const EdgeInsets.only(left: 30.0, right: 30.0, top: 40.0),
                alignment: Alignment.center,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: passwordCtrl.text.isNotEmpty &&
                                passwordCtrl.text.isNotEmpty
                            ? () {
                                _login(widget.screenToGo);
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20.0,
                            horizontal: 20.0,
                          ),
                          child: const Text(
                            "Ingresar",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
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
    );
  }
}
