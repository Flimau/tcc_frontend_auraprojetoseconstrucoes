import 'package:flutter/material.dart';

import '../../theme/colors.dart';

class BotaoVoltar extends StatelessWidget {
  final Color? cor;

  const BotaoVoltar({super.key, this.cor});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      color: cor ?? AppColors.accent,
      tooltip: 'Voltar',
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
