import 'package:flutter/material.dart';

import '../../theme/theme.dart';

class DropdownPadrao extends StatelessWidget {
  final String label;
  final List<String> itens;
  final String? valorSelecionado;
  final Function(String?)? onChanged;
  final bool somenteLeitura;
  const DropdownPadrao({
    super.key,
    required this.label,
    required this.itens,
    required this.valorSelecionado,
    required this.onChanged,
    this.somenteLeitura = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 300, maxHeight: 50),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: AppColors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value:
                  (valorSelecionado != null && itens.contains(valorSelecionado))
                      ? valorSelecionado
                      : null,
              isExpanded: true,
              hint: const Text("Selecione..."),
              items:
                  itens
                      .map(
                        (item) =>
                            DropdownMenuItem(value: item, child: Text(item)),
                      )
                      .toList(),
              onChanged: somenteLeitura ? (_) {} : onChanged,
            ),
          ),
        ),
      ),
    );
  }
}
