import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_login_screens/students.dart';
import 'package:flutter_login_screens/VehicleSettings.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart';
import 'SignUp.dart';
import 'Welcome.dart';
import 'RecoverPassword.dart';


/*class Login extends StatelessWidget {
  String screenFrom;
  Login ({this.screenFrom});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => SubLogin(screenFrom: this.screenFrom),
        '/Students': (context) => Students(),
      },
    );
  }
}*/

class Login extends StatefulWidget {
  String screenToGo;

  Login ({this.screenToGo});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final String WEBPAGE='https://etracker.mx/etsAppInterface/dbConnETS.php';

  final String TERMS_MSG='Al utilizar nuestros servicios, nos confías tus datos. '
      'Entendemos que es una gran responsabilidad y nos esforzamos al máximo para '
      'proteger tu información y permitirte controlarla. El objetivo de esta Política'
      ' de Privacidad es informarte sobre qué datos recogemos, por qué los recogemos'
      ' y cómo puedes actualizarlos, gestionarlos, exportarlos y eliminarlos.';

  Future navigateToWelcome(context) async {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => Welcome(),
      settings: RouteSettings(name: "/Welcome"),
    ));
  }

  Future navigateToStudents(context) async {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => Students(),
      settings: RouteSettings(name: "/Students"),
    ));
  }

  Future navigateToVehicleSettings(context) async {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => VehicleSettings(),
      settings: RouteSettings(name: "/VehicleSettings"),
    ));
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _login(String screenFrom) async{
    print('User=' + emailCtrl.text + ' password=' + passwordCtrl.text);
    var map = Map<String, dynamic>();
    map['action'] = 'login' ;
    map['input1'] = emailCtrl.text ;
    map['input2'] = passwordCtrl.text;
    Response response = await post(WEBPAGE, body: map);
    print("Response: " + response.body);
    if (!response.body.contains("Error")) {
      print("Login Success!!!");
      print("screen= " + screenFrom);
      if (screenFrom == '/Welcome'){
        navigateToWelcome(context);
      }
      else if (screenFrom == '/Students'){
        navigateToStudents(context);
      }
      else if (screenFrom == '/VehicleSettings'){
        navigateToVehicleSettings(context);
      }
    } else {
      var list = response.body.split(",");
      print("response.body= " + response.body );
      print("list[1]= " +list[1] );
      _showDialog('Error', list[1] );
      print("Error" );
    }
  }

  void _showDialog(String title, String msg) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
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
    Navigator.push(context, MaterialPageRoute(builder: (context) => RecoverPassword()));
  }

  Future navigateToSignUp(context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.1), BlendMode.dstATop),
              image: AssetImage('assets/images/ninos2.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: new Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(60.0),
                child: Center(
                  child: Icon(
                    Icons.headset_mic,
                    color: Colors.redAccent,
                    size: 50.0,
                  ),
                ),
              ),
              new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: new Text(
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
              new Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: Colors.redAccent,
                        width: 2,
                        style: BorderStyle.solid),
                  ),
                ),
                padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Expanded(
                      child: TextField(
                        obscureText: false,
                        textAlign: TextAlign.left,
                        controller: emailCtrl,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'JuanGozalez@cambridgecollege.com',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 24.0,
              ),
              new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: new Text(
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
              new Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: Colors.redAccent,
                        width: 2,
                        style: BorderStyle.solid),
                  ),
                ),
                padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Expanded(
                      child: TextField(
                        controller: passwordCtrl,
                        obscureText: true,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '*********',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    height: 50.0,
                    padding: const EdgeInsets.only(right: 20.0, top:0, bottom:0),
                    child: new FlatButton(
                      child: new Text(
                        "Olvidaste tu contraseña?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                          fontSize: 15.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () => {
                        navigateToRecoverPassword(context)
                      },
                    ),
                  ),
                ],
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    height: 50.0,
                    padding: const EdgeInsets.only(right: 20.0),
                    child: new FlatButton(
                      child: new Text(
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
                margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                child: new RichText(
                  textAlign: TextAlign.center,
                  text: new TextSpan(
                    children: [
                      new TextSpan(
                        text: 'Al ingresar, aceptas nuestros ',
                        style: new TextStyle(color: Colors.black),
                      ),
                      new TextSpan(
                        text: 'Términos y Politica de Privacidad',
                        style: new TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                        recognizer: new TapGestureRecognizer()
                          ..onTap = () {
                            //launch('https://www.gmail.com ');
                            _showDialog('Términos y Políticas de Privacidad', TERMS_MSG);
                          },
                      ),
                    ],
                  ),
                ),
              ),
              new Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 40.0),
                alignment: Alignment.center,
                child: new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new FlatButton(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        color: Colors.redAccent,
                        onPressed: (){
                          _login(widget.screenToGo);
                        },
                        child: new Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20.0,
                            horizontal: 20.0,
                          ),
                          child: Text(
                            "Ingresar",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold),
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

