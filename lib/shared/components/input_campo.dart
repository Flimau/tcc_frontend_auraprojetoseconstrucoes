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
  final bool enabled;
  final int? maxLinhas;
  final void Function(bool)? onFocusChange;
  final bool readOnly;
  final Widget? suffixIcon;

  const InputCampo({
    super.key,
    required this.label,
    required this.icone,
    required this.controller,
    this.tipoTeclado = TextInputType.text,
    this.mascaras,
    this.validador,
    this.focusNode,
    this.enabled = true,
    this.maxLinhas,
    this.onFocusChange,
    this.readOnly = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Focus(
        focusNode: focusNode,
        onFocusChange: onFocusChange,
        child: TextFormField(
          controller: controller,
          keyboardType: tipoTeclado,
          enabled: enabled,
          readOnly: readOnly,
          inputFormatters: mascaras,
          validator: validador,
          maxLines: maxLinhas,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icone),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: AppColors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }
}
