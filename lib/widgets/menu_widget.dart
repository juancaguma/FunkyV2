import 'package:flutter/material.dart';
import 'package:colecciona_app/preferencias_usuario/preferencias_usuario.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MenuWidget extends StatelessWidget {
  final prefs = new PreferenciasUsuario();
  @override
  Widget build(BuildContext context) {
    //final color = (prefs.colorSecundario) ? Colors.teal : Colors.blue;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://wallpaperaccess.com/full/1372730.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            accountName: Text(
              "${prefs.emailUser.split('@')[0]}",
              style: TextStyle(color: Colors.black),
            ),
            accountEmail: Text("${prefs.emailUser}",
                style: TextStyle(color: Colors.black)),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://wipy.tv/wp-content/uploads/2020/06/por-que-tony-stark-usaba-un-reactor-arc-1200x675.jpg'),
            ),
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.home, color: Colors.blue),
            title: Text("Mi colección"),
            onTap: () {
              Navigator.pushReplacementNamed(context, 'home');
            },
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.folderPlus, color: Colors.blue),
            title: Text("Agregar elemento"),
            onTap: () {
              Navigator.pushReplacementNamed(context, 'producto');
            },
          ),
          SizedBox(
            height: 350,
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.doorOpen, color: Colors.blue),
            title: Text("Salir"),
            onTap: () {
              // Navigator.pop(context);
              Navigator.pushReplacementNamed(context, 'login');
            },
          ),
        ],
      ),
    );
  }
}
