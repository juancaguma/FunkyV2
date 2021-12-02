import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:colecciona_app/bloc/provider.dart';
import 'package:colecciona_app/pages/home_page.dart';
import 'package:colecciona_app/pages/login_pages.dart';
import 'package:colecciona_app/pages/producto_page.dart';
import 'package:colecciona_app/pages/registro_page.dart';
import 'package:colecciona_app/preferencias_usuario/preferencias_usuario.dart';
import 'package:admob_flutter/admob_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Admob.initialize(testDeviceIds: ["com.syslabcolima.colecciona_app"]);
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final prefs = new PreferenciasUsuario();
    return Provider(
      child: MaterialApp(
        title: 'ColeccionApp',
        debugShowCheckedModeBanner: false,
        initialRoute: 'login',
        routes: {
          'login': (BuildContext context) => LoginPage(),
          'registro': (BuildContext context) => RegistroPage(),
          'home': (BuildContext context) => HomePage(),
          'producto': (BuildContext context) => ProductoPage(),
        },
        theme: ThemeData.light()
            .copyWith(appBarTheme: const AppBarTheme(color: Colors.indigo)),
      ),
    );
  }
}
