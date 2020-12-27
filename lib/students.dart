import 'package:flutter/material.dart';
import 'package:flutter_login_screens/DbHelperStudent.dart';
import 'student.dart';
import 'AddStudent.dart';

class Students extends StatefulWidget {
  Students() : super();

  final String title = "Alumnos registrados";

  @override
  StudentsState createState() => StudentsState();
}

class StudentsState extends State<Students> {
  List<Student> _students = new List();
  List<Student> _selectedStudents = new List();
  DbHelperStudent _db = new DbHelperStudent();
  bool sort;

  Future navigateToAddStudent(context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddStudent(),
          settings: RouteSettings(name: "/AddStudent"),
        )).then((val) => {
          setState(() {initState();}),
        });
  }

  @override
  void initState() {
    sort = false;
    _students.clear();
    _db.getAllStudents().then((items) {
      setState(() {
        items.forEach((item) {
          print('printing item map');
          print(item['id']);
          print(item['name']);
          print(item['school']);
          print(item['time']);
          _students.add(Student.fromMap(item));
        });
      });
      print("_students length= ${_students.length}");
    });

    super.initState();
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
          "id= ${student.getId}, name= ${student.getName}, school= ${student.getSchool}, time= ${student.getTime}");
      await _db.deleteStudent(student.getId);
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
    if (columnIndex == 0) {
      if (ascending) {
        _students.sort((a, b) => a.getName.compareTo(b.getName));
      } else {
        _students.sort((a, b) => b.getName.compareTo(a.getName));
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
        columns: [
          DataColumn(
              label: Text(
                'Nombre',
                style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              numeric: false,
              tooltip: "This is First Name",
              onSort: (columnIndex, ascending) {
                setState(() {
                  sort = !sort;
                });
                onSortColum(columnIndex, ascending);
              }),
          DataColumn(
            label: Text(
              "Escuela",
              style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            numeric: false,
            tooltip: "This is Last Name",
          ),
          DataColumn(
            label: Text(
              "Hora",
              style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            numeric: false,
            tooltip: "This is Last Name",
          ),
        ],
        rows: _students
            .map(
              (student) => DataRow(
                  selected: _selectedStudents.contains(student),
                  onSelectChanged: (b) {
                    print("Onselect");
                    onSelectedRow(b, student);
                  },
                  cells: [
                    DataCell(
                      Text(student.getName ?? 'default value'),
                      onTap: () {
                        print('Selected ${student.getName ?? 'default value'}');
                      },
                    ),
                    DataCell(
                      Text(student.getSchool ?? 'default value'),
                    ),
                    DataCell(
                      Text(student.getTime ?? 'default value'),
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
          mainAxisSize: MainAxisSize.min,
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
                  padding: EdgeInsets.all(20.0),
                  child: OutlineButton(
                    child: Text('Agregar'),
                    onPressed: () {
                      navigateToAddStudent(context);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: OutlineButton(
                    child: Text('Borrar selección'),
                    onPressed: _selectedStudents.isEmpty
                        ? null
                        : () {
                            _deleteStudents();
                          },
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
