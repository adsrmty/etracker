import 'package:flutter/material.dart';
import 'Login.dart';
import 'Messages.dart';
import 'students.dart';
import 'SecureStorage.dart';
import 'SetReferencePoint.dart';

class NavDrawer extends StatelessWidget {
  static String screenToGo = "screenToGo";
  final SecureStorage secureStorage = SecureStorage();
  String admin = "admin";

  static Future navigateToLogin(context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Login(
              title: "Login",
              screenToGo: screenToGo,
            )));
  }

  static Future navigateToStudents(context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Students(title: "Students")));
  }

  static Future navigateToMessages(context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Messages(title: "Messages"),
      ),
    );
  }

  Future<String> getAdminStatus() async {
    admin = await secureStorage.readSecureData('admin');
    return admin;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: getAdminStatus(),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == '2tr1ck2r') {
              return AdminDrawer();
            } else {
              return UserDrawer();
            }
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}

class AdminDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Side menu',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
                color: Colors.green,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/mountains.jpg'))),
          ),
          ListTile(
            leading: Icon(Icons.input),
            title: Text('Fijar punto de referencia'),
            onTap: () {
              Navigator.pop(context);
              NavDrawer.screenToGo = '/SetReferencePoint';
              NavDrawer.navigateToLogin(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.input),
            title: Text('Alumnos'),
            onTap: () {
              Navigator.pop(context);
/*              NavDrawer.screenToGo = '/Students';
              NavDrawer.navigateToLogin(context);*/
              NavDrawer.navigateToStudents(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.input),
            title: Text('Mensajes'),
            onTap: () {
              NavDrawer.navigateToMessages(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Ajustes del vehículo'),
            onTap: () {
              Navigator.pop(context);
              NavDrawer.screenToGo = '/VehicleSettings';
              NavDrawer.navigateToLogin(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Ajiustes de cuenta'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.border_color),
            title: Text('Política de privacidad'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Ayuda'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('contacto'),
            onTap: () => {Navigator.of(context).pop()},
          ),
        ],
      ),
    );
  }
}

class UserDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Side menu',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
                color: Colors.green,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/cover.jpg'))),
          ),
          ListTile(
            leading: Icon(Icons.input),
            title: Text('Alumnos'),
            onTap: () {
              Navigator.pop(context);
              NavDrawer.navigateToStudents(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.input),
            title: Text('Mensajes'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Ajustes del vehículo'),
            onTap: () {
              NavDrawer.screenToGo = '/VehicleSettings';
              NavDrawer.navigateToLogin(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Ajustes de cuenta'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.border_color),
            title: Text('Política de privacidad'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Ayuda'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('contacto'),
            onTap: () => {Navigator.of(context).pop()},
          ),
        ],
      ),
    );
  }
}




