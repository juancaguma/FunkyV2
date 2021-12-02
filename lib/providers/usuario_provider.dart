import 'dart:convert';
import 'package:colecciona_app/preferencias_usuario/preferencias_usuario.dart';
import 'package:http/http.dart' as http;

class UsuarioProvider {
  final String _firebaseToken = 'AIzaSyDVOH2Uz5SB4Ydd4fEwYUHVvOj58VCWxYc';
  final _prefs = new PreferenciasUsuario();

  Future<Map<String, dynamic>> login(String email, String password) async {
    final _url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseToken');
    final autData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final resp = await http.post(_url, body: json.encode(autData));
    Map<String, dynamic> decodedResp = json.decode(resp.body);
    if (decodedResp.containsKey('idToken')) {
      //guardar el token en el storage
      _prefs.token = decodedResp['idToken'];
      _prefs.idUser = decodedResp['localId'];
      _prefs.emailUser = decodedResp['email'];

      return {'ok': true, 'token': decodedResp['idToken']};
    } else {
      return {'ok': false, 'Mensaje': decodedResp['error']['message']};
    }
  }

  Future<Map<String, dynamic>> nuevoUsuario(
      String email, String password) async {
    final _url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseToken');
    final autData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    final resp = await http.post(_url, body: json.encode(autData));
    Map<String, dynamic> decodedResp = json.decode(resp.body);
    if (decodedResp.containsKey('idToken')) {
      //guardar el token en el storage
      _prefs.token = decodedResp['idToken'];
      _prefs.idUser = decodedResp['localId'];
      _prefs.emailUser = decodedResp['email'];
      return {'ok': true, 'token': decodedResp['idToken']};
    } else {
      return {'ok': false, 'Mensaje': decodedResp['error']['message']};
    }
  }
}
