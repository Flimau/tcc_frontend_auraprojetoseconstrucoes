import 'package:flutter/material.dart';

import 'colors.dart';
import 'text_styles.dart';

export '../shared/components/card_container.dart';
export 'colors.dart';
export 'text_styles.dart';

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'Roboto',

      textTheme: const TextTheme(
        bodyMedium: AppTextStyles.body,
        headlineSmall: AppTextStyles.headline,
        titleSmall: AppTextStyles.subtitle,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: AppTextStyles.fontButton,
        ),
      ),

      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        labelStyle: TextStyle(color: AppColors.primary),
        prefixIconColor: AppColors.accent,
      ),
    );
  }

  static BoxDecoration get cardBox {
    return BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.grey,
          spreadRadius: 2,
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
