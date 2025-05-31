import 'package:flutter/material.dart';

import 'colors.dart';

class AppTextStyles {
  static const TextStyle headline = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.accent,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 12,
    fontStyle: FontStyle.italic,
    color: AppColors.subtitle,
  );

  static const TextStyle body = TextStyle(fontSize: 16, color: AppColors.text);

  static const TextStyle link = TextStyle(
    fontSize: 14,
    color: AppColors.primary,
    decoration: TextDecoration.underline,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle fontButton = TextStyle(
    fontSize: 16,
    color: AppColors.accent,
  );
}
