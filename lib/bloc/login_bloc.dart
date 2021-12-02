import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:colecciona_app/bloc/validator.dart';

class LoginBloc with Validators {
  final _emailController = BehaviorSubject<String>.seeded('');
  final _passwordController = BehaviorSubject<String>.seeded('');

  //Recuperar datos del Stream
  Stream<String> get emailStream =>
      _emailController.stream.transform(validarEmail);
  Stream<String> get paswordStream =>
      _passwordController.stream.transform(validarPassword);

  Stream<bool> get formValidStream =>
      Rx.combineLatest2(emailStream, paswordStream, (e, p) => true);

  //Insertar valores al Stream
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  //Obtener el ultimo valor ingresadon a los Stream
  String get email => _emailController.value;
  String get password => _passwordController.value;

  dispose() {
    _emailController.close();
    _passwordController.close();
  }
}
