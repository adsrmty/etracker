import 'package:flutter/material.dart';
import 'Step1.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final String WELCOME_MSG1 =
      'Usted está a punto de experimentar la manera más eficiente de recoger a los niños de la escuela.\n '
      'El servicio de eTracker Schools fué pagado por la escuela de tus hijos y ofrece los siguientes beneficios para ti:\n\n'
      '\u2022  Una reducción significativa en los tiempos de espera a la hora de salida.\n\n'
      '\u2022  Podrás saber cuáles son los tiempos de espera y la cantidad de autos en fila.\n\n'
      '\u2022  Incremento en el nivel de seguridad de tu hijo(a).\n\n'
      '\u2022  Entre otros beneficios para ti, los alumnos, los maestros y la comunidad.\n\n';

  Future navigateToStep1(context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Step1(title: "Step1"),
          settings: const RouteSettings(name: "/Step1"),
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
              image: AssetImage('assets/images/ninos2.jpg'),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Bienvendido a eTracker Schools.\n\n',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                      fontSize: 15.0,
                    ),
                  ),
                ],
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
                margin: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
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



