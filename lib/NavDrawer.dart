import 'package:flutter/material.dart';
import 'Login.dart';
import 'messages.dart';
import 'students.dart';

class NavDrawer extends StatelessWidget {
  static String screenToGo;
  bool admin = true;

  static Future navigateToLogin(context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Login(
                  screenToGo: screenToGo,
                )));
  }

  static Future navigateToStudents(context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Students()));
  }

  static Future navigateToMessages(context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Messages(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget widget;
    admin ? widget = AdminDrawer() : widget = UserDrawer();
    return widget;
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
                    image: AssetImage('assets/images/cover.jpg'))),
          ),
          ListTile(
            leading: Icon(Icons.input),
            title: Text('Administración'),
            onTap: () => {},
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
            onTap: () => {},
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
