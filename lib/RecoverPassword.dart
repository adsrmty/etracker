import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class RecoverPassword extends StatefulWidget {
  const RecoverPassword({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<RecoverPassword> createState() => _RecoverPasswordState();
}

class _RecoverPasswordState extends State<RecoverPassword> {
  final emailCtrl = TextEditingController();
  final String RECOVER_PASSWORD_MSG = 'Usted recibira instrucciones vía correo'
      ' electronico para poder recuperar su contraseña de eTracker Schools.';

  _launchURL() async {
    const url = 'https://flutter.dev';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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
                padding: const EdgeInsets.all(80.0),
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
                      padding: const EdgeInsets.only(left: 40.0),
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
                margin: const EdgeInsets.only(
                    left: 40.0, right: 40.0, top: 0.0, bottom: 25.0),
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
              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                      child: Text(
                        RECOVER_PASSWORD_MSG,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
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
                margin: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 30.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextButton(
                        onPressed: (){
                          _launchURL();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20.0,
                            horizontal: 20.0,
                          ),
                          child: const Text(
                            "Recuperar Contraseña",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
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



