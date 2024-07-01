import 'package:flutter/material.dart';
import 'Status.dart';
import 'dart:math';
import 'DbHelperStudent.dart';
import 'Student.dart';
import 'package:http/http.dart';
import 'SharedPreferencesHelper.dart';

class Step3 extends StatefulWidget {
  const Step3({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<Step3> createState() => _Step3State();
}

class _Step3State extends State<Step3> {
  TextEditingController _schoolKeyCtrl1 = TextEditingController();
  TextEditingController _schoolKeyCtrl2 = TextEditingController();
  TextEditingController _pickupKeyCtrl1 = TextEditingController();
  TextEditingController _pickupKeyCtrl2 = TextEditingController();
  TextEditingController _pickupKeyCtrl3 = TextEditingController();
  final String REGISTER_MSG = 'Estos datos son proporcionados por la escuela,'
      ' contacte por favor a la escuela para más detalles.';
  Random _random = Random();
  DbHelperStudent _db = DbHelperStudent();

  //final String WEBPAGE2 = 'http://10.0.2.2:3000';
  final String WEBPAGE2 = 'https://etracker.mx/etsAppInterface/dbConnETS.php';
  final int RESULT_STATUS = 1;
  final int STUDENT_NAME = 2;
  final int SCHOOLE_NAME = 3;
  final int SCHEDULE = 4;
  final int EXPIRE = 5;
  late FocusNode pickupKeyF1;
  late FocusNode pickupKeyF2;
  late FocusNode pickupKeyF3;
  late FocusNode schoolKeyF1;
  late FocusNode schoolKeyF2;

  Future navigateToStatus(context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Status(title: "Status"),
          settings: const RouteSettings(name: "/Status"),
        ));
    //Navigator.pushNamedAndRemoveUntil(context, '/Status',  ModalRoute.withName('/Step1'));
  }

  @override
  void initState() {
    super.initState();
    schoolKeyF1 = FocusNode();
    schoolKeyF2 = FocusNode();
    pickupKeyF1 = FocusNode();
    pickupKeyF2 = FocusNode();
    pickupKeyF3 = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    schoolKeyF1.dispose();
    schoolKeyF2.dispose();
    pickupKeyF1.dispose();
    pickupKeyF2.dispose();
    pickupKeyF3.dispose();
    _schoolKeyCtrl1.dispose();
    _schoolKeyCtrl2.dispose();
    _pickupKeyCtrl1.dispose();
    _pickupKeyCtrl2.dispose();
    _pickupKeyCtrl1.dispose();
    super.dispose();
  }

  int next(int min, int max) => min + _random.nextInt(max - min);

  _getStudentInfo() {
    print("_getStudentInfo");
    List<String> data = [
      "null",
      "pass",
      "Alondra Sanchez",
      "Vicente",
      "12:00-13:15",
      "311224"
    ];
    _SaveStudentIntoDb(data);
    /*return ()
      async {
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
        Uri.parse(WEBPAGE2),
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
      else{
        String title = "Alerta!";
        String msg = "Ocurrio un error en el servidor, vuelva a intentar";
        _showMaterialDialog(title, msg);
      }
    };*/
  }

  Future<void> _SaveStudentIntoDb(var list) async {
    print("_SaveStudentsIntoDb");
    var now = DateTime.now();
    int year = int.parse("20" + list[EXPIRE].substring(0, 2));
    int month = int.parse(list[EXPIRE].substring(2, 4));
    int day = int.parse(list[EXPIRE].substring(4, 6));
    var newDate = DateTime(year, month, day, 23, 59, 00);

    // date received is greater than current day that means expiration date is in the future
    print("compare to= " + newDate.compareTo(now).toString());
    if (newDate.compareTo(now) > 0) {
      Student student = Student(
          _pickupKeyCtrl1.text + _pickupKeyCtrl2.text + _pickupKeyCtrl3.text,
          _schoolKeyCtrl1.text + _schoolKeyCtrl2.text,
          list[STUDENT_NAME],
          list[SCHOOLE_NAME],
          list[SCHEDULE],
          list[EXPIRE]);
      print("pickupKey= " + student.getPickupKey);
      await _db.saveStudent(student);
      //await _setPickupKeys();
      navigateToStatus(context);
    } else {
      String title = "Alerta!";
      String msg = "La llave es inválida o ha caducado";
      _showMaterialDialog(title, msg);
    }
  }

  _showMaterialDialog(String title, String msg) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text(title),
              content: Text(msg),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cerrar'),
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
    map['input2'] =
        _pickupKeyCtrl1.text + _pickupKeyCtrl2.text + _pickupKeyCtrl3.text;
    map['input3'] = _schoolKeyCtrl1.text + _schoolKeyCtrl2.text;
    Response response = await post(
      Uri.parse(WEBPAGE2),
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
    } else {
      print("Error = " + list[RESULT_STATUS + 1]);
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
                padding: const EdgeInsets.all(20.0),
                child: const Center(
                  child: Icon(
                    Icons.headset_mic,
                    color: Colors.redAccent,
                    size: 50.0,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
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
                margin: const EdgeInsets.only(bottom: 20.0),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
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
                    left: 50.0, right: 50.0, top: 0.0, bottom: 10.0),
                alignment: Alignment.center,
 /*               decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: Colors.black,
                        width: 0.5,
                        style: BorderStyle.solid),
                  ),
                ),*/
                padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        width: 140,
                        child: Text("Codigo de Escuela:")),
                    Container(
                        width: 40,
                        child: TextField(
                          controller: _schoolKeyCtrl1,
                          decoration: const InputDecoration(
                            counterText: "",
                          ),
                          keyboardType: TextInputType.number,
                          focusNode: schoolKeyF1,
                          maxLength: 4,
                          onChanged: (String newVal) {
                            if (newVal.length == 4) {
                              schoolKeyF1.unfocus();
                              FocusScope.of(context).requestFocus(schoolKeyF2);
                            }
                          },
                        )),
                    Text(" - "),
                    Container(
                        width: 45,
                        child: TextField(
                          controller: _schoolKeyCtrl2,
                          decoration: const InputDecoration(
                            counterText: "",
                          ),
                          keyboardType: TextInputType.number,
                          focusNode: schoolKeyF2,
                          maxLength: 4,
                          onChanged: (String newVal) {
                            if (newVal.length == 4) {
                              schoolKeyF2.unfocus();
                              FocusScope.of(context).requestFocus(pickupKeyF1);
                            }
                          },
                        )),
                  ],
                ),
                /* Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        obscureText: false,
                        controller: _pickupKeyCtrl,
                        maxLength: 9,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.left,
                        decoration: const InputDecoration(
                          hintText: 'Llave del alumno(a)',
                        ),
                      ),
                    ),
                  ],
                ),*/
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(
                    left: 50.0, right: 50.0, top: 0.0, bottom: 10.0),
                alignment: Alignment.center,
 /*               decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: Colors.black,
                        width: 0.5,
                        style: BorderStyle.solid),
                  ),
                ),*/
                padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          width: 140,
                          child: Text("Codigo de alumno:")),
                      Container(
                          width: 40,
                          child: TextField(
                            controller: _pickupKeyCtrl1,
                            decoration: const InputDecoration(
                              counterText: "",
                            ),
                            keyboardType: TextInputType.number,
                            focusNode: pickupKeyF1,
                            maxLength: 4,
                            onChanged: (String newVal) {
                              if (newVal.length == 4) {
                                pickupKeyF1.unfocus();
                                FocusScope.of(context)
                                    .requestFocus(pickupKeyF2);
                              }
                            },
                          )),
                      Text(" - "),
                      Container(
                          width: 45,
                          child: TextField(
                            controller: _pickupKeyCtrl2,
                            decoration: const InputDecoration(
                              counterText: "",
                            ),
                            keyboardType: TextInputType.number,
                            focusNode: pickupKeyF2,
                            maxLength: 4,
                            onChanged: (String newVal) {
                              if (newVal.length == 4) {
                                pickupKeyF2.unfocus();
                                FocusScope.of(context)
                                    .requestFocus(pickupKeyF3);
                              }
                            },
                          )),
                      Text(" - "),
                      Container(
                          width: 45,
                          child: TextField(
                            controller: _pickupKeyCtrl3,
                            decoration: const InputDecoration(
                              counterText: "",
                            ),
                            keyboardType: TextInputType.number,
                            focusNode: pickupKeyF3,
                            maxLength: 4,
                            onChanged: (String newVal) {},
                          )),
                    ] /*<Widget>[
                    Expanded(
                      child: TextField(
                        obscureText: false,
                        controller: _schoolKeyCtrl,
                        textAlign: TextAlign.left,
                        decoration: const InputDecoration(
                          hintText: 'Llave de la escuela',
                        ),
                      ),
                    ),
                  ],*/
                    ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 40.0, right: 40.0),
                      child: Text(
                        REGISTER_MSG,
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
                        onPressed: _schoolKeyCtrl1.text.isNotEmpty &&
                                _schoolKeyCtrl2.text.isNotEmpty &&
                                _pickupKeyCtrl1.text.isNotEmpty &&
                                _pickupKeyCtrl2.text.isNotEmpty &&
                                _pickupKeyCtrl3.text.isNotEmpty
                            ? () {
                                print("controllers are not empty");
                                _getStudentInfo();
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20.0,
                            horizontal: 20.0,
                          ),
                          child: const Text(
                            "Ingresar",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
/*              Container(
                margin: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 10.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        color: Colors.redAccent,
                        onPressed: (){
                          exit(0);
                        },
                        child: Container(
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
