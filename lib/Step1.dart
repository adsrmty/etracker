import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'SharedPreferencesHelper.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'Step2.dart';
import 'CarList.dart';

class Step1 extends StatefulWidget {
  @override
  _Step1State createState() => _Step1State();
}

class _Step1State extends State<Step1> {
  final plateCtrl = TextEditingController();

  List _cars = [
    "SUV"/*,
    "SUV Grande",
    "Van",
    "Sedan",
    "Camioneta",
    "Hatchback",
    "Mini",
    "Minivan"*/
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

  List<DropdownMenuItem<String>> _dropDownCarItems;
  List<DropdownMenuItem<String>> _dropDownColorItems;
  String _selectedCar;
  Color _selectedColor = Colors.black;
  bool _isButtonDisabled;
  var _map= new Map<String, Picture>();

  // Use temp variable to only update color when press dialog 'submit' button
  Color _tempMainColor;

  @override
  void initState() {
    _dropDownCarItems = _getDropDownCarItems();
    _isButtonDisabled = true;
    _decodeSvgPictures();
    super.initState();
  }

  Future navigateToStep2(context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Step2(),
          settings: RouteSettings(name: "/Step2"),
        ));
  }

  Future<void> _decodeSvgPictures() async{
    String colorString = _selectedColor.toString();
    String valueString = colorString.split('(0x')[1].substring(0,5);
    print('valueString= ' + valueString);
    CarList car = new CarList(color: valueString);

    for (String carName in _cars) {
      final String rawSvg= car.getSVGString(carName);
      final DrawableRoot svgRoot = await svg.fromSvgString(rawSvg, rawSvg);
      _map[carName] = svgRoot.toPicture();
    }
  }




  List<DropdownMenuItem<String>> _getDropDownCarItems() {
    List<DropdownMenuItem<String>> items = new List();

    String colorString = _selectedColor.toString();
    String valueString = colorString.split('(0xff')[1].substring(0,6);
    print('valueString= ' + valueString);
    CarList car = new CarList(color: valueString);

    for (String carName in _cars) {

      items.add(
        new DropdownMenuItem(
          value: carName,
          child: new Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 20),
                padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
                child:
                SvgPicture.asset(
                  'assets/images/mamamovilGris.svg',
                  semanticsLabel: 'Acme Logo',
                  width: 100,
                  height: 80,
                  color: _selectedColor,
                ),
              ),
              Text(carName),
            ],
          ),
        ),
      );
    }
    return items;
  }

  void changedDropDownCarItem(String selectedCar) {
    setState(() {
      _selectedCar = selectedCar;

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
            FlatButton(
              child: Text('CANCEL'),
              onPressed: Navigator.of(context).pop,
            ),
            FlatButton(
              child: Text('SUBMIT'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _selectedColor = _tempMainColor;
                  _dropDownCarItems= _getDropDownCarItems();
                });
              },
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
            Colors.black,
            Colors.blueAccent,
            Colors.white,
            Colors.yellow,
            Colors.lightGreen
          ],
          allowShades: false,
          onMainColorChange: (Color color) => setState(() {
            print('El color seleccionado es: ${color.toString()}');
            _tempMainColor = color;
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
              Container(
                margin: EdgeInsets.only(bottom: 20.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text(
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
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text(
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
                        controller: plateCtrl,
                        onEditingComplete: () {
                          SharedPreferencesHelper.setCarPlate(plateCtrl.text);
                        },
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
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
                child: new DropdownButtonFormField(
                  hint: Text('Tipo de vehiculo'),
                  value: _selectedCar,
                  items: _dropDownCarItems,
                  onChanged: changedDropDownCarItem,
                  style: new TextStyle(
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
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: Colors.black,
                        width: 0.5,
                        style: BorderStyle.solid),
                  ),
                ),
                padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                child: Container(
                  margin: EdgeInsets.only(bottom: 20.0),
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
                          margin: EdgeInsets.only(right: 12.0),
                          child: SizedBox(
                            width: 60.0,
                            height: 30.0,
                          ),
                        ),
                        Expanded(
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
                child: new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new FlatButton(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        color: Colors.redAccent,
                        disabledColor: Colors.grey,
                        onPressed: _isButtonDisabled
                            ? null
                            : () {
                                navigateToStep2(context);
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
