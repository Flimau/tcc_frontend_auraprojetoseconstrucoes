import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/theme.dart';

class InputCampo extends StatelessWidget {
  final String label;
  final IconData icone;
  final TextEditingController controller;
  final TextInputType tipoTeclado;
  final List<TextInputFormatter>? mascaras;
  final String? Function(String?)? validador;
  final FocusNode? focusNode;

  const InputCampo({
    super.key,
    required this.label,
    required this.icone,
    required this.controller,
    this.tipoTeclado = TextInputType.text,
    this.mascaras,
    this.validador,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: tipoTeclado,
        inputFormatters: mascaras,
        validator: validador,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icone),
          filled: true,
          fillColor: AppColors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
