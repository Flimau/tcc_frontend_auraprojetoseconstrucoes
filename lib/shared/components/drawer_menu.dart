import 'package:flutter/material.dart';

import '../../theme/theme.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.background,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: AppColors.primary),
            child: Text(
              'Menu',
              style: AppTextStyles.headline.copyWith(color: AppColors.accent),
            ),
          ),
          _item(context, 'Home', '/home'),
          _item(context, 'Usuários', '/tela_listar_usuarios'),
          _item(context, 'Orçamentos', '/orcamento'),
          _item(context, 'Obras', '/tela_listar_obras'),
          _item(context, 'Contratos', '/tela_listar_contratos'),
          _item(context, 'Visitas', '/tela_listar_visitas'),
          _item(context, 'Ativar conta', '/tela_ativacao_usuario'),
        ],
      ),
    );
  }

  ListTile _item(BuildContext context, String titulo, String rota) {
    return ListTile(
      title: Text(titulo),
      onTap: () {
        Navigator.pop(context); // fecha o drawer
        Navigator.pushNamed(context, rota);
      },
    );
  }
}
