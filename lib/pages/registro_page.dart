import 'package:colecciona_app/providers/google_sing_service.dart';
import 'package:flutter/material.dart';
import 'package:colecciona_app/providers/usuario_provider.dart';
import 'package:colecciona_app/bloc/provider.dart';
import 'package:colecciona_app/utils/utils.dart';
import 'package:colecciona_app/bloc/login_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegistroPage extends StatelessWidget {
  final usuarioProvider = new UsuarioProvider();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        _crearFondo(context),
        _loginForm(context),
      ],
    ));
  }

  Widget _loginForm(BuildContext context) {
    final bloc = Provider.of(context);
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SafeArea(
            child: Container(
              height: 190.0,
            ),
          ),
          Container(
            width: size.width * 0.85,
            margin: EdgeInsets.symmetric(vertical: 30.0),
            padding: EdgeInsets.symmetric(vertical: 50.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3.0,
                      offset: Offset(0.0, 5.0),
                      spreadRadius: 3.0)
                ]),
            child: Column(
              children: <Widget>[
                Text(
                  'ColeccionApp',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 25.0,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Hind'),
                ),
                SizedBox(height: 28.0),
                _crearEmail(bloc),
                SizedBox(height: 18.0),
                _crearPassword(bloc),
                SizedBox(height: 18.0),
                _crearBoton(bloc),
                SizedBox(height: 18.0),
                _loginGoogle()
              ],
            ),
          ),
          TextButton(
            child: Text('¿Ya tienes cuenta? Login'),
            onPressed: () => Navigator.pushReplacementNamed(context, 'login'),
          ),
          SizedBox(height: 45.0)
        ],
      ),
    );
  }

  Widget _crearEmail(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                icon: Icon(Icons.alternate_email, color: Colors.deepPurple),
                hintText: 'ejemplo@correo.com',
                labelText: 'Correo electrónico',
                counterText: snapshot.data,
                errorText: snapshot.error as String?),
            onChanged: bloc.changeEmail,
          ),
        );
      },
    );
  }

  Widget _crearPassword(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.paswordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
                icon: Icon(Icons.lock_outline, color: Colors.deepPurple),
                labelText: 'Contraseña',
                counterText: snapshot.data,
                errorText: snapshot.error as String?),
            onChanged: bloc.changePassword,
          ),
        );
      },
    );
  }

  Widget _crearBoton(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return ElevatedButton(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 10.0),
            child: Text('Registrar'),
          ),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            elevation: 0.0,
            primary: Colors.deepPurple,
          ),
          onPressed: snapshot.hasData ? () => _register(bloc, context) : null,
        );
      },
    );
  }

  Widget _loginGoogle() {
    return MaterialButton(
        splashColor: Colors.transparent,
        minWidth: double.infinity,
        height: 40,
        color: Colors.red,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.google,
              color: Colors.white,
            ),
            Text(
              '  Iniciar sesión con google',
              style: TextStyle(color: Colors.white, fontSize: 17),
            ),
          ],
        ),
        onPressed: () {
          GoogleSingInService.singInWithGoogle();
        });
  }

  _register(LoginBloc bloc, BuildContext context) async {
    final info = await usuarioProvider.nuevoUsuario(bloc.email, bloc.password);
    if (info['ok']) {
      Navigator.pushReplacementNamed(context, 'home');
    } else {
      //print(info);
      mostrarAlerta(context, info['Mensaje']);
    }
  }

  Widget _crearFondo(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final fondoModaro = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: <Color>[
        Color.fromRGBO(63, 63, 156, 1.0),
        Color.fromRGBO(90, 70, 178, 1.0)
      ])),
    );

    final circulo = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Color.fromRGBO(255, 255, 255, 0.05)),
    );

    return Stack(
      children: <Widget>[
        fondoModaro,
        Positioned(top: 90.0, left: 30.0, child: circulo),
        Positioned(top: -40.0, right: -30.0, child: circulo),
        Positioned(bottom: -50.0, right: -10.0, child: circulo),
        Positioned(bottom: 120.0, right: 20.0, child: circulo),
        Positioned(bottom: -50.0, left: -20.0, child: circulo),
        Container(
          padding: EdgeInsets.only(top: 50.0),
          child: Column(
            children: <Widget>[
              Image(
                image: AssetImage('assets/logo.png'),
                height: 150.0,
              ),
              SizedBox(height: 10.0, width: double.infinity),
            ],
          ),
        )
      ],
    );
  }
}
