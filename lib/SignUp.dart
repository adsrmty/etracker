import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'Login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final String WEBPAGE =
      'https://estructurasmexicanas.com/location/dbConnETS.php';

  final String SIGNUP_MSG='En breve usted recibirá un correo electrónico con '
      'una liga, por favor abra su correo y de click en la liga para activar '
      'su cuenta de eTracker Schools. Si usted no recibe correo por favor revise'
      ' en su folder correo no deseado.';

  /*
  Future<void> _signup() async {
    var map = Map<String, dynamic>();
    map['action'] = 'register';
    map['input1'] = emailCtrl.text;
    map['input2'] = passwordCtrl.text;
    map['input3'] = nameCtrl.text;
    map['input4'] = lastNameCtrl.text;
    //map['action'] = 'login' ;
    //map['input1'] = 'AAAA-AAAA';
    http.Response response = await http.post(WEBPAGE, body: map);
    print("Response: " + response.body);
    if (!response.body.contains("Error")) {
      print("Signup Success!!!");
      _showDialog('Confirma tu correo', SIGNUP_MSG);
    } else {
      var list = response.body.split(",");
      print("response.body= " + response.body );
      print("list[1]= " +list[1] );
      _showDialog('Error', list[1] );
      print("Error");
    }
  }
*/
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
                if(title == 'Confirma tu correo'){
                  navigateToLogin(context);
                }
                else{
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future navigateToLogin(context) async {
    //Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.1), BlendMode.dstATop),
              image: const AssetImage('assets/images/ninos2.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(40.0),
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
                margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 0.0, bottom:25.0),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: Colors.redAccent,
                        width: 0.5,
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
                        controller: emailCtrl,
                        textAlign: TextAlign.left,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'JuanGonzalez@cambridgecollege.com',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 40.0),
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
                margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 0.0, bottom:25.0),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: Colors.redAccent,
                        width: 0.8,
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
                        obscureText: true,
                        controller: passwordCtrl,
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
              const Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: Text(
                        "Nombre",
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
                margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 0.0, bottom:25.0),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: Colors.redAccent,
                        width: 0.5,
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
                        controller: nameCtrl,
                        textAlign: TextAlign.left,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: Text(
                        "Apellido",
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
                margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 0.0, bottom:10.0),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: Colors.redAccent,
                        width: 0.5,
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
                        controller: lastNameCtrl,
                        textAlign: TextAlign.left,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
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
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: TextButton(
                      child: const Text(
                        "Ya tienes una cuenta?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                          fontSize: 15.0,
                        ),
                        textAlign: TextAlign.end,
                      ),
                      onPressed: () => {
                        navigateToLogin(context),
                      },
                    ),
                  ),
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
                alignment: Alignment.center,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextButton(
                        onPressed: null,//_signup,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20.0,
                            horizontal: 20.0,
                          ),
                          child: const Text(
                            "Registrarse",
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

