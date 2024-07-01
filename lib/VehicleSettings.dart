import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:etracker/SharedPreferencesHelper.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'Step2.dart';

class VehicleSettings extends StatefulWidget {
  const VehicleSettings({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<VehicleSettings> createState() => _VehicleSettingsState();
}

class _VehicleSettingsState extends State<VehicleSettings> {
  final plateCtrl = TextEditingController();

  final List <String> _cars = [
    "SUV",
    "SUV Grande",
    "Van",
    "Sedan",
    "Camioneta",
    "Hatchback",
    "Mini",
    "Minivan"
  ];

  final List <String>   _colors = [
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

  late List<DropdownMenuItem<String>> _dropDownCarItems;
  late List<DropdownMenuItem<String>> _dropDownColorItems;
  bool _isButtonDisabled =  false;
  String _selectedCar = "";
  Color _selectedColor = Colors.black;
  String _selectedPlate = "";

  @override
  void initState() {

    _isButtonDisabled = true;
    updateFutureValues().then((whenComplete){
      plateCtrl.text= _selectedPlate;
      _dropDownCarItems = _getDropDownCarItems();

      if (_selectedCar != null && _selectedColor != null) {
        _isButtonDisabled = false;
      } else {
        _isButtonDisabled = true;
      }

    });
    super.initState();
  }

  Future<void> updateFutureValues() async{
    _selectedCar =  await SharedPreferencesHelper.getCarType();
    _selectedColor =  await SharedPreferencesHelper.getCarColor();
    _selectedPlate =  await SharedPreferencesHelper.getCarPlate();
  }
  Future navigateToStep2(context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Step2(title: "Step2"),
          settings: const RouteSettings(name: "/Step2"),
        ));
  }

  List<DropdownMenuItem<String>> _getDropDownCarItems() {
    //List<DropdownMenuItem<String>> items = List();
    List<DropdownMenuItem<String>> items = List<DropdownMenuItem<String>>.empty();
    Color colorSelected = Colors.black;

    for (String car in _cars) {
      print('El color es: ' + colorSelected.toString());
      items.add(
        DropdownMenuItem(
          value: car,
          child: Row(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(right: 20),
                padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                child: SvgPicture.asset(
                  'assets/images/mamamovilGris.svg',
                  semanticsLabel: 'Acme Logo',
                  width: 1500,
                  height: 80,
                  color: _selectedColor,
                ),
              ),
              Text(car),
            ],
          ),
        ),
      );
    }
    return items;
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

  void _showDialog() {
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
                  print("El color es: " + value.toString());
                  setState(() {
                    _selectedColor = value;
                    _dropDownCarItems = _getDropDownCarItems();
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
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
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
                margin: const EdgeInsets.only(bottom: 0.0),
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
                    left: 40.0, right: 40.0, top: 40.0, bottom: 0.0),
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
                  hint: const Text('Tipo de vehiculo'),
                  value: _selectedCar,
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
                      _showDialog();
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
                              const BorderRadius.all(Radius.circular(20))),
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
                margin: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 10.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextButton(
                        onPressed: _isButtonDisabled
                            ? null
                            : () {
                          Navigator.pop(context);
                        },
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



