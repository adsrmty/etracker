import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'Notice2.dart';
import 'Step3.dart';
import 'Status.dart';
import 'SecureStorage.dart';

class Step2 extends StatefulWidget {
  const Step2({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<Step2> createState() => _Step2State();
}

class _Step2State extends State<Step2> {
  final plateCtrl = TextEditingController();
  bool photo = false;
  final String ADD_PHOTO_MSG =
      'De click aquí para agregar su fotografía tipo pasaporte. Esta fotografía será la que verán los maestros cuando usted recoja al alumno(a).';

  //File file = File("");
  File? file;
  final SecureStorage secureStorage = SecureStorage();

  Future navigateToNotice2(context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Notice2(title: ""),
          settings: const RouteSettings(name: "/Notice2"),
        ));
  }

  Future navigateToStep3(context) async {
    if (photo == true) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const Step3(title: "Step3")));
    } else {
      navigateToNotice2(context);
    }
  }

  Future navigateToStatus(context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Status(title: "Status"),
          settings: const RouteSettings(name: "/Status"),
        ));
    //Navigator.pushNamedAndRemoveUntil(context, '/Status',  ModalRoute.withName('/Step1'));
  }

  void _getPicture() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
    }
    setState(() {
      if (!photo) photo = !photo;
    });
  }

  Image showPicture() {
    Image? image;
    if (file != null) {
      if (file!.exists() == Future.value(true)) {
        image = Image.asset('', fit: BoxFit.fill);
      }
    } else {
      image = Image.asset('assets/images/Han.jpg',fit: BoxFit.fill);
    }
    return image!;
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
                margin: const EdgeInsets.only(bottom: 20.0),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
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
                margin: const EdgeInsets.only(bottom: 0.0),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
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
                    ? const EdgeInsets.all(0)
                    : const EdgeInsets.only(left: 10.0, right: 10.0),
                margin: const EdgeInsets.only(
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
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          navigateToStep3(context);
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
