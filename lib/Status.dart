import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'Login.dart';
import 'NavDrawer.dart';
import 'package:move_to_background/move_to_background.dart';

class Status extends StatefulWidget {
  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<Status> {
  final emailCtrl = TextEditingController();

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
                  child: Icon(
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
                colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(0.1), BlendMode.dstATop),
                image: AssetImage('assets/images/ninos2.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(0),
                  margin: EdgeInsets.only(
                      left: 30.0, right: 30.0, top: 30.0),
                  decoration: BoxDecoration(
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: 20.0),
                                child: Text(
                                  'Destino',
                                  style: TextStyle(
                                    fontSize: 30.0,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10.0),
                                child: Text(
                                  'Escuela Vicente Gerrero',
                                  style: TextStyle(
                                    fontSize: 30.0,
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
                  padding: EdgeInsets.all(0),
                  margin: EdgeInsets.only(left: 30.0, right: 30.0),
                  decoration: BoxDecoration(
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: 20.0),
                                child: Text(
                                  'Horario de salida',
                                  style: TextStyle(
                                    fontSize: 30.0,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10.0),
                                child: Text(
                                  '12:00 a 12:20',
                                  style: TextStyle(
                                    fontSize: 30.0,
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
                  padding: EdgeInsets.all(0),
                  margin: EdgeInsets.only(
                      left: 30.0, right: 30.0),
                  decoration: BoxDecoration(
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
                                child: Text(
                                  'Tiempo de espera',
                                  style: TextStyle(
                                    fontSize: 30.0,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10.0),
                                child: Text(
                                  '8 mins',
                                  style: TextStyle(
                                    fontSize: 30.0,
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
                  padding: EdgeInsets.all(0),
                  margin: EdgeInsets.only(
                      left: 30.0, right: 30.0, bottom: 30.0),
                  decoration: BoxDecoration(
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
                                child: Text(
                                  'Vehículos en fila',
                                  style: TextStyle(
                                    fontSize: 30.0,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10.0),
                                child: Text(
                                  '8',
                                  style: TextStyle(
                                    fontSize: 30.0,
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
