import 'package:flutter/material.dart';

import '../../theme/colors.dart';

class BotaoSwitch extends StatelessWidget {
  final bool value;
  final String ativoLabel;
  final String inativoLabel;
  final ValueChanged<bool> onChanged;

  const BotaoSwitch({
    super.key,
    required this.value,
    required this.ativoLabel,
    required this.inativoLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(
        value ? ativoLabel : inativoLabel,
        style: TextStyle(
          color: value ? AppColors.accent : AppColors.subtitle,
          fontWeight: FontWeight.bold,
        ),
      ),
      value: value,
      activeColor: AppColors.accent,
      inactiveThumbColor: AppColors.subtitle,
      inactiveTrackColor: AppColors.subtitle.withValues(alpha: 0.3),
      onChanged: onChanged,
    );
  }
}
