import 'package:flutter/material.dart';

import '../../../shared/components/form_widgets.dart';
import '../../../theme/theme.dart';

class TelaHome extends StatelessWidget {
  const TelaHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBarCustom(titulo: 'Home'),
      drawer: const DrawerMenu(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _cardDash(
              context,
              Icons.person,
              'Usuários',
              AppColors.primary,
              '/tela_listar_usuarios',
            ),
            _cardDash(
              context,
              Icons.assignment,
              'Orçamentos',
              AppColors.accent,
              '/tela_listar_orcamentos',
            ),
            _cardDash(
              context,
              Icons.home_work,
              'Obras',
              AppColors.primary.withOpacity(0.7),
              '/tela_listar_obras',
            ),
            _cardDash(
              context,
              Icons.description,
              'Contratos',
              AppColors.accent,
              '/tela_listar_contratos',
            ),
            _cardDash(
              context,
              Icons.map_outlined,
              'Visitas',
              AppColors.primary.withOpacity(0.6),
              '/tela_listar_visitas',
            ),
            _cardDash(
              context,
              Icons.home_work,
              'Obras',
              AppColors.primary.withOpacity(0.6),
              '/tela_listar_obras',
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardDash(
    BuildContext context,
    IconData icone,
    String titulo,
    Color corIcone,
    String rotaDestino,
  ) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, rotaDestino);
      },
      child: Container(
        decoration: AppTheme.cardBox,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icone, size: 48, color: corIcone),
            const SizedBox(height: 12),
            Text(titulo, style: AppTextStyles.headline.copyWith(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
