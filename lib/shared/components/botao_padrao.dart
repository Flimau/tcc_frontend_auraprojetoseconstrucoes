import 'package:flutter/material.dart';

import '../../theme/theme.dart';

class BotaoPadrao extends StatelessWidget {
  final String texto;
  final VoidCallback onPressed;

  const BotaoPadrao({super.key, required this.texto, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onPressed,
      child: Text(
        texto,
        style: AppTextStyles.fontButton.copyWith(
          color: AppColors.accent,
          fontSize: 16,
        ),
      ),
    );
  }
}
