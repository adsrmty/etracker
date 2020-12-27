import 'package:flutter/material.dart';
import 'Login.dart';
import 'SignUp.dart';
import 'Welcome.dart';
import 'Step1.dart';
import 'Step2.dart';
import 'Notice2.dart';
import 'Step3.dart';
import 'students.dart';
import 'Status.dart';
import 'AddStudent.dart';
import 'VehicleSettings.dart';

void main() => runApp(
      new MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => Home(),
          '/Login': (context) => Login(),
          '/SignUp': (context) => SignUp(),
          '/Welcome': (context) => Welcome(),
          '/Step1': (context) => Step1(),
          '/Step2': (context) => Step2(),
          '/Notice2': (context) => Notice2(),
          '/Step3': (context) => Step3(),
          '/Status': (context) => Status(),
          '/Students': (context) => Students(),
          '/AddStudents': (context) => AddStudent(),
          '/VehicleSettings': (context) => VehicleSettings(),
        },
      ),
    );

class Home extends StatefulWidget {
  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  Future navigateToLogin(context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Login(screenToGo: '/Welcome'),
          settings: RouteSettings(name: "/Home"),
        ));
  }

  Future navigateToSignUp(context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignUp(),
          settings: RouteSettings(name: "/SignUp"),
        ));
  }

  Future navigateToWelcome(context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Welcome(),
          settings: RouteSettings(name: "/Welcome"),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: new Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.redAccent,
            image: DecorationImage(
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.15), BlendMode.dstATop),
              image: AssetImage('assets/images/ninos4.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: new Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 250.0),
                child: Center(
                  child: Icon(
                    Icons.headset_mic,
                    color: Colors.white,
                    size: 40.0,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20.0),
                child: new Row(
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
              new Container(
                width: MediaQuery.of(context).size.width,
                margin:
                    const EdgeInsets.only(left: 30.0, right: 30.0, top: 100.0),
                alignment: Alignment.center,
                child: new Row(
                  children: <Widget>[
                    new Expanded(
                      child: Center(
                        child: new OutlineButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          color: Colors.redAccent,
                          borderSide: BorderSide(
                            color: Colors.white, //Color of the border
                            style: BorderStyle.solid, //Style of the border
                            width: 1, //width of the border
                          ),
                          highlightedBorderColor: Colors.black,
                          onPressed: () => navigateToSignUp(context),
                          child: new Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 20.0,
                              horizontal: 20.0,
                            ),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Expanded(
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
              new Container(
                width: MediaQuery.of(context).size.width,
                margin:
                    const EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
                alignment: Alignment.center,
                child: new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new FlatButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        color: Colors.white,
                        onPressed: () => navigateToWelcome(context),
                        child: new Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20.0,
                            horizontal: 20.0,
                          ),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Expanded(
                                child: Text(
                                  "Ingresar",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.redAccent,
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
    );
  }

  gotoLogin() {
    //controller_0To1.forward(from: 0.0);
    _controller.animateToPage(
      0,
      duration: Duration(milliseconds: 800),
      curve: Curves.bounceOut,
    );
  }

  gotoSignup() {
    //controller_minus1To0.reverse(from: 0.0);
    _controller.animateToPage(
      2,
      duration: Duration(milliseconds: 800),
      curve: Curves.bounceOut,
    );
  }

  PageController _controller =
      new PageController(initialPage: 1, viewportFraction: 1.0);
}
