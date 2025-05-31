import 'package:flutter/material.dart';

import '../../../shared/components/form_widgets.dart';
import '../../../theme/theme.dart';
import '../../contrato/screens/tela_listar_contratos.dart';
import '../../obra/screens/tela_listar_obras.dart';
import '../../orcamento/screens/tela_listar_orcamentos.dart';
import '../../usuario/screens/tela_listar_usuarios.dart';
import '../../visita/screens/tela_listar_visitas.dart';

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
              const TelaListarUsuarios(),
            ),
            _cardDash(
              context,
              Icons.assignment,
              'Orçamentos',
              AppColors.accent,
              const TelaListarOrcamentos(),
            ),
            _cardDash(
              context,
              Icons.home_work,
              'Obras',
              AppColors.primary.withOpacity(0.7),
              const TelaListarObras(),
            ),
            _cardDash(
              context,
              Icons.description,
              'Contratos',
              AppColors.accent,
              const TelaListarContratos(),
            ),
            _cardDash(
              context,
              Icons.map_outlined,
              'Visitas',
              AppColors.primary.withOpacity(0.6),
              const TelaListarVisitas(),
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
    Widget destino,
  ) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => destino));
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
