import 'package:flutter/material.dart';

bool isNumeric(String s) {
  if (s.isEmpty) return false;
  final n = num.tryParse(s);
  return (n == null) ? false : true;
}

void mostrarAlerta(BuildContext context, String? mensaje) {
  if (mensaje == 'INVALID_PASSWORD') {
    mensaje = 'Contraseña incorrecta';
  } else if (mensaje == 'EMAIL_NOT_FOUND') {
    mensaje = 'Correo no encontrado';
  } else if (mensaje == 'EMAIL_EXISTS') {
    mensaje = 'Este correo ya existe';
  }
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Datos incorrectos'),
        content: Text(mensaje!),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Ok'),
          ),
        ],
      );
    },
  );
}
