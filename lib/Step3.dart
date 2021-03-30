import 'package:flutter/material.dart';
import 'Status.dart';
import 'dart:math';
import 'DbHelperStudent.dart';
import 'student.dart';
import 'package:http/http.dart';
import 'SharedPreferencesHelper.dart';

class Step3 extends StatefulWidget {
  @override
  _Step3State createState() => _Step3State();
}

class _Step3State extends State<Step3> {
  final _schoolKeyCtrl = TextEditingController();
  final _pickupKeyCtrl = TextEditingController();
  final String REGISTER_MSG = 'Estos datos son proporcionados por la escuela,'
      ' contacte por favor a la escuela para más detalles.';
  Random _random = new Random();
  DbHelperStudent _db = new DbHelperStudent();
  final String WEBPAGE2 = 'http://10.0.2.2:3000';
  final int RESULT_STATUS = 1;
  final int STUDENT_NAME = 1;
  final int SCHOOLE_NAME = 2;
  final int SCHEDULE = 3;
  final int EXPIRE = 4;

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
    super.initState();
  }

  int next(int min, int max) => min + _random.nextInt(max - min);

  _getStudentInfo() {
    print("_getStudentInfo");
    return () async {
      print("async");
      if (_pickupKeyCtrl.text.isEmpty || _schoolKeyCtrl.text.isEmpty) {
        print("_pickupKeyCtrl and _schoolKeyCtrl field are empty");
      }

      print("NOT NULL");
      var map = Map<String, dynamic>();
      map['action'] = 'getStudentInfo';
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
      var list = response.body.split(",");
      if (!response.body.contains("Error")) {
        print("response.body= " + response.body);
        print("list[$STUDENT_NAME]= " + list[STUDENT_NAME]);
        print("list[$SCHOOLE_NAME]= " + list[SCHOOLE_NAME]);
        print("list[$SCHEDULE]= " + list[SCHEDULE]);
        print("list[$EXPIRE]= " + list[EXPIRE]);
        _addStudent(list);

      }
    };
  }

  _addStudent(var list) {
    print("_addStudent");

    var now = new DateTime.now();

    int year = int.parse("20" + list[EXPIRE].substring(0, 2));
    int month = int.parse(list[EXPIRE].substring(2, 4));
    int day = int.parse(list[EXPIRE].substring(4, 6));
    var newDate = new DateTime(year, month, day, 23, 59, 00);

    // date received is greater than current day that means expiration date is in the future
    print("compare to= "  + newDate.compareTo(now).toString());
    if(newDate.compareTo(now) > 0){
      Student student = new Student(_pickupKeyCtrl.text, _schoolKeyCtrl.text,
          list[STUDENT_NAME], list[SCHOOLE_NAME], list[SCHEDULE], list[EXPIRE]);
      _db.saveStudent(student);
      _setPickupKeys();
      navigateToStatus(context);
    }
    else{
      _showMaterialDialog();
    }
  }
  _showMaterialDialog() {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
          title: new Text("Alerta!"),
          content: new Text("La llave es invalida o ha caducado"),
          actions: <Widget>[
            TextButton(
              child: Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ));
  }
  Future<void> _setPickupKeys() async {
    print("_setPickupKeys");
    String email = await SharedPreferencesHelper.getEmail();
    var map = Map<String, dynamic>();
    map['action'] = 'setPickupKeys';
    map['input1'] = email;
    map['input2'] = _pickupKeyCtrl.text;
    map['input3'] = _schoolKeyCtrl.text;
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
    var list = response.body.split(",");
    if (!response.body.contains("Error")) {
      print("result = " + list[RESULT_STATUS]);
    }
    else{
      print("Error = " + list[RESULT_STATUS+1]);
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
                        onPressed: _getStudentInfo(),
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
