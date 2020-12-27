import 'package:flutter/material.dart';
import 'Step1.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
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
          builder: (context) => Step1(),
          settings: RouteSettings(name: "/Step1"),
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
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.1), BlendMode.dstATop),
              image: AssetImage('assets/images/ninos2.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: new Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(40.0),
                child: Center(
                  child: Icon(
                    Icons.headset_mic,
                    color: Colors.redAccent,
                    size: 50.0,
                  ),
                ),
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text(
                    'Bienvendido a eTracker Schools.\n\n',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                      fontSize: 15.0,
                    ),
                  ),
                ],
              ),
              new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Padding(
                      padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                      child: new Text(
                        WELCOME_MSG1,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                child: new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new FlatButton(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        color: Colors.redAccent,
                        onPressed: () {
                          navigateToStep1(context);
                        },
                        child: new Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20.0,
                            horizontal: 20.0,
                          ),
                          child: Text(
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
