import 'package:flutter/material.dart';

import '../../theme/theme.dart';

class TituloSecao extends StatelessWidget {
  final String titulo;

  const TituloSecao(this.titulo, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(titulo, style: AppTextStyles.headline.copyWith(fontSize: 20)),
    );
  }
}
