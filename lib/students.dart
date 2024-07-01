import 'package:flutter/material.dart';
import 'package:etracker/DbHelperStudent.dart';
import 'Student.dart';
import 'AddStudent.dart';

class Students extends StatefulWidget {
  const Students({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<Students> createState() => _StudentsState();
}

class _StudentsState extends State<Students> {
  List<Student> _students = List<Student>.empty(growable: true);
  List<Student> _selectedStudents = List<Student>.empty(growable: true);
  DbHelperStudent _db = DbHelperStudent();
  bool sort = false;

  Future navigateToAddStudent(context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AddStudent(title: "AddStudent"),
          settings: const RouteSettings(name: "/AddStudent"),
        )).then((val) => {
          setState(() {
            print("/AddStudent Return");
            getAllStudents();
          }),
        });
  }

  @override
  void initState() {
    super.initState();
    sort = false;
    getAllStudents();
  }

  getAllStudents() {
    _students.clear();
    _db.getAllStudents().then((items) {
      setState(() {
        items.forEach((item) {
          print('printing item map');
          print(item['id']);
          print(item['pickupKey']);
          print(item['schoolKey']);
          print(item['name']);
          print(item['school']);
          print(item['schedule']);
          print(item['expire']);

          var now = DateTime.now();

          int year = int.parse("20" + item['expire'].substring(0, 2));
          int month = int.parse(item['expire'].substring(2, 4));
          int day = int.parse(item['expire'].substring(4, 6));
          var newDate = DateTime(year, month, day, 23, 59, 00);

          // date received is greater than current day that means expiration date is in the future
          print("compare to= " + newDate.compareTo(now).toString());
          if (newDate.compareTo(now) > 0) {
            _students.add(Student.fromMap(item));
          } else {
            _db.deleteStudent(item['id']);
          }
        });
      });
      print("_students length= ${_students.length}");
    });
  }

  Future<void> _saveStudents(List<Student> students) async {
    for (var student in students) {
      int result = await _db.saveStudent(student);
      print('result= ${result}');
    }
  }

  void _deleteStudents() {
    print('_deleteMsgs');
    _selectedStudents.forEach((student) async {
      print(
          "id= ${student.getPickupKey}, schoolKey = ${student.getSchoolKey}, name= ${student.getName}, school= ${student.getSchool}, schedule= ${student.getSchedule}, expire= ${student.getExpire}");
      await _db.deleteStudent(student.getPickupKey);
    });

    _students.clear();
    _db.getAllStudents().then((students) {
      setState(() {
        students.forEach((student) {
          _students.add(Student.fromMap(student));
        });
        print('_items Lengthhh= ${_students.length}');
      });
    });
    _selectedStudents.clear();
  }

  onSortColum(int columnIndex, bool ascending) {
    print("OnSortColumn");
    print("columnIndex = $columnIndex");
    print("ascending = $ascending");
    if (columnIndex == 0) {
      if (ascending) {
        _students.sort((a, b) => a.getName.compareTo(b.getPickupKey));
      } else {
        _students.sort((a, b) => b.getName.compareTo(a.getPickupKey));
      }
    }
  }

  onSelectedRow(bool selected, Student student) async {
    setState(() {
      if (selected) {
        _selectedStudents.add(student);
      } else {
        _selectedStudents.remove(student);
      }
    });
  }

  SingleChildScrollView dataBody() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        sortAscending: sort,
        sortColumnIndex: 0,
        columnSpacing: 50,
        columns: <DataColumn>[
          DataColumn(
              label: const Expanded(
                  flex: 3,
                  child: Text(
                    'Código',
                    style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  )),
              numeric: false,
              tooltip: "Este es el código para recoger",
              onSort: (columnIndex, ascending) {
                print("onSort = $sort");
                setState(() {
                  sort = !sort;
                });
                onSortColum(columnIndex, ascending);
              }),
          const DataColumn(
            label: Expanded(
                flex: 1,
                child: Text(
                  'Escuela',
                  style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                )),
            numeric: false,
            tooltip: "Este es el nombre de la escuela",
          ),
          const DataColumn(
            label: Expanded(
                flex: 1,
                child: Text(
                  'Horario',
                  style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                )),
            numeric: false,
            tooltip: "Este es el horario",
          ),
        ],
        rows: _students
            .map(
              (student) => DataRow(
                  selected: _selectedStudents.contains(student),
                  onSelectChanged: (b) {
                    print("Onselect");
                    onSelectedRow(b!, student);
                  },
                  cells: [
                    DataCell(
                      SizedBox(
                        width: 100,
                        child: Text(
                          student.getPickupKey ?? 'default value',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      onTap: () {
                        print(
                            'Selected ${student.getPickupKey ?? 'default value'}');
                      },
                    ),
                    DataCell(
                      Text(student.getSchool ?? 'default value'),
                    ),
                    DataCell(
                      Text(student.getSchedule ?? 'default value'),
                    ),
                  ]),
            )
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Colors.redAccent,
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            Expanded(
              child: dataBody(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: OutlinedButton(
                    onPressed: () {
                      navigateToAddStudent(context);
                    },
                    child: const Text('Agregar'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: OutlinedButton(
                    onPressed: _selectedStudents.isEmpty
                        ? null
                        : () {
                            _deleteStudents();
                          },
                    child: const Text('Borrar selección'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
