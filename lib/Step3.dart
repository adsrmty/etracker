import 'package:flutter/material.dart';
import 'Status.dart';
import 'dart:math';
import 'DbHelperStudent.dart';
import 'student.dart';
import 'package:http/http.dart';

class Step3 extends StatefulWidget {
  @override
  _Step3State createState() => _Step3State();
}

class _Step3State extends State<Step3> {
  final _schoolKeyCtrl = TextEditingController();
  final _pickupKeyCtrl = TextEditingController();
  final String REGISTER_MSG = 'Estos datos son proporcionados por la escuela,'
      ' contacte por favor a la escuela para más detalles.';
  var _name = new List(5);// creates an empty array of length 5
  var _school = new List(5);// creates an empty array of length 5
  var _time = new List(5);// creates an empty array of length 5
  Random _random = new Random();
  DbHelperStudent _db = new DbHelperStudent();
  final String WEBPAGE2 = 'http://10.0.2.2:3000';
  final int STUDENT_NAME = 1;
  final int STUDENT_LAST_NAME = 2;
  final int CAR = 3;
  final int COLOR = 4;
  final int PLATES = 5;
  final int STATUS = 6;
  final String ACTIVE = 'Active';
  final String INACTIVE = 'Inactive';
  var list;

  Future navigateToStatus(context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Status(),
          settings: RouteSettings(name: "/Status"),
        ));
    //Navigator.pushNamedAndRemoveUntil(context, '/Status',  ModalRoute.withName('/Step1'));
  }

  @override
  void initState() {
    // assigning values to all the indices
    _name[0] = 'Alondra Maya';
    _name[1] = 'Erendira Garcia';
    _name[2] = 'Elia Valentina';
    _name[3] = 'Oliver Atom';
    _name[4] = 'Ikaru Tatsumura';

    // assigning values to all the indices
    _school[0] = 'Vicente Guerrero';
    _school[1] = 'Tec de Monterrey';
    _school[2] = 'Egade Bussiness Schools';
    _school[3] = 'UDEM';
    _school[4] = 'Montesori';

    // assigning values to all the indices
    _time[0] = '12:00 PM';
    _time[1] = '13:00 PM';
    _time[2] = '14:00 PM';
    _time[3] = '15:00 PM';
    _time[4] = '16:00 PM';

    super.initState();
  }

  int next(int min, int max) => min + _random.nextInt(max - min);

   _getUserInfo() {
    return () async {

      print('_getUserInfo()');
      var map = Map<String, dynamic>();
      map['action'] = 'getUserInfo';
      map['input1'] = _schoolKeyCtrl.text;
      map['input2'] = _pickupKeyCtrl.text;
      Response response = await post(
        WEBPAGE2,
        /*headers: <String, String>{
        //'Content-Type': 'application/json; charset=UTF-8',
        'Content-Type': 'application/text; charset=UTF-8',
      },
      body: json.encode(<String, String>{
        'title': 'dedede',
      }),*/
        body: map,
      );
      print("Response: " + response.body);
      list = response.body.split(",");
      print("response.body= " + response.body);
      print("list[1]= " + list[STUDENT_NAME]);
      print("list[2]= " + list[STUDENT_LAST_NAME]);
      print("list[3]= " + list[CAR]);
      print("list[4]= " + list[COLOR]);
      print("list[5]= " + list[PLATES]);
      print("list[6]= " + list[STATUS]);
      print("AEEEEEE");
      if (list[STATUS] == 'Active'){
        print("ACTIVE");
        _addStudent();
      }
    };
  }
   _addStudent() {
    if (_pickupKeyCtrl.text.isEmpty || _schoolKeyCtrl.text.isEmpty) {
      print("Returning NULLLLL");
    }
    else {
        print("_addStudent");
        int random= next(0, 4);
        // Function to get _name, _school and _time from remote server will be here
        // Call the function here
        //
        Student student = new Student(_pickupKeyCtrl.text, _schoolKeyCtrl.text, _name[random], _school[random], _time[random]);
        _db.saveStudent(student);
        navigateToStatus(context);
      }
  }

  @override
  void dispose() {
    _pickupKeyCtrl.dispose();
    _schoolKeyCtrl.dispose();
    super.dispose();
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
                padding: EdgeInsets.all(20.0),
                child: Center(
                  child: Icon(
                    Icons.headset_mic,
                    color: Colors.redAccent,
                    size: 50.0,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10.0, bottom: 20.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text(
                      'PASO 3',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                        fontSize: 30.0,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text(
                      'Registrar alumno',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(
                    left: 40.0, right: 40.0, top: 0.0, bottom: 10.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: Colors.black,
                        width: 0.5,
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
                        controller: _pickupKeyCtrl,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          hintText: 'Llave del alumno(a)',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(
                    left: 40.0, right: 40.0, top: 0.0, bottom: 10.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: Colors.black,
                        width: 0.5,
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
                        controller: _schoolKeyCtrl,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          hintText: 'Llave de la escuela',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 40.0, right: 40.0),
                      child: new Text(
                        REGISTER_MSG,
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
                margin: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 10.0),
                child: new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new FlatButton(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        color: Colors.redAccent,
                        disabledColor: Colors.grey,
                        onPressed: _getUserInfo(),
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
/*              Container(
                margin: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 10.0),
                child: new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new FlatButton(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        color: Colors.redAccent,
                        onPressed: (){
                          exit(0);
                        },
                        child: new Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20.0,
                            horizontal: 20.0,
                          ),
                          child: Text(
                            "Salir",
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
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
