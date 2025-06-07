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
          _item(context, 'Ativar Conta', '/tela_ativacao_usuario'),
          _item(context, 'Orçamentos', '/tela_listar_orcamentos'),
          _item(context, 'Contratos', '/tela_listar_contratos'),
          _item(context, 'Obras', '/tela_listar_obras'),
          _item(context, 'Agenda', '/tela_listar_agenda'),
          _item(context, 'Kanban', '/tela_kanban_obras'),
        ],
      ),
    );
  }

  Widget _item(BuildContext context, String label, String route) {
    return ListTile(
      title: Text(label),
      onTap: () {
        Navigator.pop(context); // fecha o drawer
        Navigator.pushNamed(context, route);
      },
    );
  }
}
