import 'package:flutter/material.dart';

void mostrarMensagem(BuildContext context, String texto, {bool erro = false}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(texto),
      backgroundColor: erro ? Colors.red : Colors.green,
    ),
  );
}
