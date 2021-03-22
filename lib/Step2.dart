import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'Notice2.dart';
import 'Step3.dart';
import 'Status.dart';
import 'SecureStorage.dart';

class Step2 extends StatefulWidget {
  @override
  _Step2State createState() => _Step2State();
}

class _Step2State extends State<Step2> {
  final plateCtrl = TextEditingController();
  bool photo = false;
  final String ADD_PHOTO_MSG =
      'De click aquí para agregar su fotografía tipo pasaporte. Esta fotografía será la que verán los maestros cuando usted recoja al alumno(a).';
  File file;
  final SecureStorage secureStorage = SecureStorage();
  final String VALID_STS='valid';
  final String INVALID_STS='invalid';

  Future navigateToNotice2(context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Notice2(),
          settings: RouteSettings(name: "/Notice2"),
        ));
  }

  Future navigateToStep3(context) async {
    if (photo == true) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Step3()));
    } else {
      navigateToNotice2(context);
    }
  }

  Future navigateToStatus(context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Status(),
          settings: RouteSettings(name: "/Status"),
        ));
    //Navigator.pushNamedAndRemoveUntil(context, '/Status',  ModalRoute.withName('/Step1'));
  }
  Future <void> _defineNextScreen(){
    var userStatus = secureStorage.readSecureData('userStatus');
    userStatus.then((value) {
      print("userStatus= "   + value);
      if (value == VALID_STS){
        navigateToStatus(context);
      }
      else{
        navigateToStep3(context);
      }
    });

  }
  void _getPicture() async {
    print("_getPicture");
    file = await FilePicker.getFile();
    setState(() {
      if (!photo) photo = !photo;
    });
  }

  Image showPicture() {
    Image image;
    if (file != null && file.exists() == true)
      image = Image.asset(
        '',
        fit: BoxFit.fill,
      );
    else
      image = Image.asset(
        'assets/images/Han.jpg',
        fit: BoxFit.fill,
      );
    return image;
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
                margin: EdgeInsets.only(bottom: 20.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text(
                      'PASO 2',
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
                margin: EdgeInsets.only(bottom: 0.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text(
                      'Fotografía del conductor',
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
                padding: photo
                    ? EdgeInsets.all(0)
                    : EdgeInsets.only(left: 10.0, right: 10.0),
                margin: EdgeInsets.only(
                    left: 90.0, right: 90.0, top: 20.0, bottom: 20.0),
                decoration: BoxDecoration(
                  border: Border.all(),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 240,
                  child: InkWell(
                    onTap: _getPicture,
                    child: photo
                        ? showPicture()
                        : Center(child: Text(ADD_PHOTO_MSG)),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(30.0, 10, 30.0, 20.0),
                child: new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new FlatButton(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        color: Colors.redAccent,
                        onPressed: () {_defineNextScreen();
                          //navigateToStep3(context);
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
