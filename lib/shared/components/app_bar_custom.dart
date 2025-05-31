import 'package:flutter/material.dart';
import '../../theme/theme.dart';

class AppBarCustom extends StatelessWidget implements PreferredSizeWidget {
  final String titulo;

  const AppBarCustom({super.key, required this.titulo});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        titulo,
        style: AppTextStyles.headline.copyWith(color: AppColors.accent),
      ),
      backgroundColor: AppColors.primary,
      iconTheme: const IconThemeData(color: Colors.white),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          tooltip: 'Sair',
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
