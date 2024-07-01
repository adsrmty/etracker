import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'SharedPreferencesHelper.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'Step2.dart';
import 'Notice.dart';
import 'CarList.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Step1 extends StatefulWidget {
  const Step1({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<Step1> createState() => _Step1State();
}

class _Step1State extends State<Step1> {
  final plateCtrl = TextEditingController();
  final String WEBPAGE2 = 'http://10.0.2.2:3000';
  final int RESULT_STATUS = 1;

  List _cars = [
    "Mini",
    "Convertible",
    "Sport",
    "Sedan",
    "Suv",
    "Minivan",
    "Pickup"
  ];

  List _colors = [
    'Negro',
    'Azul',
    'Cafe',
    'Gris',
    'Verde',
    'Naranja',
    'Morado',
    'Rojo',
    'Blanco',
    'Amarillo'
  ];

  List<DropdownMenuItem<String>> _dropDownCarItems =
      List<DropdownMenuItem<String>>.empty();
  String _selectedCar = "Sedan";

  bool _isButtonDisabled = true;
  var _map = Map<String, Picture>();

  // Use temp variable to only update color when press dialog 'submit' button
  ColorSwatch _tempMainColor = Colors.blue;
  ColorSwatch _selectedColor = Colors.green;

  @override
  void initState() {
    _dropDownCarItems = _getDropDownCarItems();
    for (var i = 0; i < _dropDownCarItems.length; i++) {
      print("value= ${_dropDownCarItems[i].value}");
      print("key= ${_dropDownCarItems[i].key}");
    }
    //print(_dropDownCarItems.fir);
    if (_selectedCar != null && _selectedColor != null) {
      _isButtonDisabled = false;
    } else {
      _isButtonDisabled = true;
    }
    super.initState();
  }

  Future navigateToNotice(context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Notice(title: "Notice"),
          settings: const RouteSettings(name: "/Notice"),
        ));
  }

  Future navigateToStep2(context) async {
    print("navigateToStep2");
    if (plateCtrl.text.isEmpty || plateCtrl.text.length != 3) {
      navigateToNotice(context);
    } else {
      _setUserInfo();
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Step2(title: "Step2"),
            settings: RouteSettings(name: "/Step2"),
          ));
    }
  }

  Future<void> _setUserInfo() async {
    print('_setUserInfo()');
    String email = await SharedPreferencesHelper.getEmail();

    var map = Map<String, dynamic>();
    map['action'] = 'setUserInfo';
    map['input1'] = email;
    map['input2'] = _selectedCar;
    map['input3'] = _selectedColor!.value.toRadixString(16);
    map['input4'] = plateCtrl.text;

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
    var list = response.body.split(",");
    if (!response.body.contains("Error")) {
      print("result = " + list[RESULT_STATUS]);
    } else {
      print("Error = " + list[RESULT_STATUS + 1]);
    }
  }

  List<DropdownMenuItem<String>> _getDropDownCarItems() {
    print("_getDropDownCarItems");
    List<DropdownMenuItem<String>> items =
        List<DropdownMenuItem<String>>.empty(growable: true);

    String colorString = _selectedColor.toString();
    String valueString = colorString.split('(0xff')[1].substring(0, 6);
    print('valueString= ' + valueString);
    CarList car = CarList(color: valueString);

    for (String carName in _cars) {
      print("carName= $carName");
      String assetName = _getAssetName(carName);
      print("assetName= $assetName");
      print("_selectedColor= ${_selectedColor.toString()}");
      items.add(
        DropdownMenuItem(
          value: carName,
          child: Container(
            padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0, 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  //margin: EdgeInsets.only(right: 20),
                  padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.red,
                      ),
                      color: Colors.black, //changeBackGround(_selectedColor),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  child: SvgPicture.asset(assetName,
                      semanticsLabel: 'Acme Logo',
                      width: 100,
                      height: 80,
                      //color: _selectedColor),
                      colorFilter:
                          ColorFilter.mode(_selectedColor!, BlendMode.srcIn)),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(carName),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
    return items;
  }

  String _getAssetName(String carName) {
    String assetName = 'assets/images/mamamovilGris.svg';

    /*   switch (carName) {
      case "Mini":
        assetName = 'assets/images/mini.svg';
        break;
      case "Convertible":
        assetName = 'assets/images/convertible.svg';
        break;
      case "Sport":
        assetName = 'assets/images/sport.svg';
        break;
      case "Sedan":
        assetName = 'assets/images/sedan.svg';
        break;
      case "Suv":
        assetName = 'assets/images/suv.svg';
        break;
      case "Minivan":
        assetName = 'assets/images/minivan.svg';
        break;
      case "Pickup":
        assetName = 'assets/images/pickup.svg';
        break;
    }*/
    return assetName;
  }

  Color changeBackGround(Color color) {
    if (color == Colors.yellow ||
        color == Colors.green ||
        color == Colors.white)
      return Colors.black;
    else
      return Colors.white;
  }

  void changedDropDownCarItem(String? selectedCar) {
    setState(() {
      _selectedCar = selectedCar!;

      if (_selectedCar != null && _selectedColor != null) {
        _isButtonDisabled = false;
      } else {
        _isButtonDisabled = true;
      }
    });
    SharedPreferencesHelper.setCarType(_selectedCar);
  }

/*  void _showDialog() {
    // flutter defined function
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: const Text('Selecciona un color.'),
            content: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: Colors.redAccent,
                onColorChanged: (value) {
                  setState(() {
                    _selectedColor = value;
                    _dropDownCarItems =  _getDropDownCarItems();
                    if (_selectedCar != null && _selectedColor != null) {
                      _isButtonDisabled = false;
                    } else {
                      _isButtonDisabled = true;
                    }
                  });
                  SharedPreferencesHelper.setCarColor(_selectedColor);
                },
                pickerAreaHeightPercent: 0.8,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }*/

  void _openDialog(String title, Widget content) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          title: Text(title),
          content: content,
          actions: [
            ElevatedButton(
              child: const Text('CANCEL'),
              onPressed: Navigator.of(context).pop,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
            ElevatedButton(
              child: const Text('SUBMIT'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  print("_tempMainColor = $_tempMainColor");
                  _selectedColor = _tempMainColor;
                  _dropDownCarItems = _getDropDownCarItems();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  void _openColorPicker() async {
    _openDialog(
      "Color picker",
      Container(
        height: 210,
        child: MaterialColorPicker(
          selectedColor: _selectedColor,
          colors: [
            Colors.blue,
            Colors.brown,
            Colors.grey,
            Colors.green,
            Colors.orange,
            Colors.purple,
            Colors.red,
            Colors.yellow,
          ],
          allowShades: false,
          onMainColorChange: (color) => setState(() {
            print('El color seleccionado es: ${color.toString()}');
            _tempMainColor = color!;
          }),
          onBack: () => print("Back button pressed"),
        ),
      ),
    );
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
                      'PASO 1',
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
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Información básica de tu vehículo.',
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
                    left: 40.0, right: 40.0, top: 20.0, bottom: 0.0),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: Colors.black,
                        width: 0.5,
                        style: BorderStyle.solid),
                  ),
                ),
                padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        obscureText: false,
                        controller: plateCtrl,
                        onEditingComplete: () {
                          SharedPreferencesHelper.setCarPlate(plateCtrl.text);
                        },
                        textAlign: TextAlign.left,
                        maxLength: 3,
                        decoration: const InputDecoration(
                          hintText: 'Escribe los últimos 3 dígitos tus placas',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 00.0, bottom: 0.0),
                padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                child: DropdownButtonFormField(
                  itemHeight: 150,
                  isDense: false,
                  hint: const Text('Seleccione el tipo del vehículo'),
                  value: _selectedCar,
                  isExpanded: true,
                  items: _dropDownCarItems,
                  onChanged: changedDropDownCarItem,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(
                    left: 40.0, right: 40.0, top: 20.0, bottom: 0.0),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: Colors.black,
                        width: 0.5,
                        style: BorderStyle.solid),
                  ),
                ),
                padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20.0),
                  child: InkWell(
                    onTap: () {
                      _openColorPicker();
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              color: _selectedColor,
                              border: Border.all(),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          margin: const EdgeInsets.only(right: 12.0),
                          child: const SizedBox(
                            width: 60.0,
                            height: 30.0,
                          ),
                        ),
                        const Expanded(
                          child: Text(
                            "Da click aquí para seleccionar el color de tu vehículo",
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                        //Icon(Icons.expand_more),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 10.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isButtonDisabled
                            ? null
                            : () {
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
