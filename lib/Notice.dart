import 'package:flutter/material.dart';
import 'Step2.dart';
import 'Step1.dart';

class Notice extends StatefulWidget {
  const Notice({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<Notice> createState() => _NoticeState();
}

class _NoticeState extends State<Notice> {
  final emailCtrl = TextEditingController();
  final String WELCOME_MSG1 = 'USTED NO REGISTRO LA PLACA DE SU AUTOMMOVIL.\n\n'
      'REGISTRAR LA PLACA DE SU AUTOMOVIL AUMENTA EL NIVEL DE SEGURIDAD PUES LOS MAESTROS VAN A PODER '
      'IDENTIFICAR VEHICULO QUE VA A RECOGER AL NIÑO(A).';


  Future navigateToStep1(context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const Step1(title: "Step1"),
      settings: const RouteSettings(name: "/Step1"),
    ));
  }

  Future navigateToStep2(context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const Step2(title: "Step2"),
      settings: const RouteSettings(name: "/Step2"),
    ));
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
                padding: const EdgeInsets.all(40.0),
                child: const Center(
                  child: Icon(
                    Icons.headset_mic,
                    color: Colors.redAccent,
                    size: 50.0,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'AVISO',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                        fontSize: 30.0,
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
                        WELCOME_MSG1,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 10.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: (){
                          navigateToStep1(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20.0,
                            horizontal: 20.0,
                          ),
                          child: const Text(
                            "Regresar",
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
              Container(
                margin: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 10.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: (){
                          navigateToStep2(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20.0,
                            horizontal: 20.0,
                          ),
                          child: const Text(
                            "Continuar",
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


