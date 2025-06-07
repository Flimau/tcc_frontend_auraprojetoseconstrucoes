// lib/features/agenda/screens/tela_listar_agenda.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/components/form_widgets.dart'; // AppBarCustom, BotaoPadrao, DrawerMenu
import '../../../theme/theme.dart'; // AppColors, AppTextStyles
import '../controllers/agenda_list_controller.dart'; // AgendaListController
import '../models/agenda_item.dart'; // AgendaItem
import 'tela_cadastro_agenda.dart'; // TelaCadastroAgenda

class TelaListarAgenda extends StatelessWidget {
  const TelaListarAgenda({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AgendaListController()..buscarTodos(),
      child: Consumer<AgendaListController>(
        builder: (context, controller, _) {
          return Scaffold(
            appBar: const AppBarCustom(titulo: 'Agenda'),
            drawer: const DrawerMenu(),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: controller.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        Expanded(
                          child: controller.itens.isEmpty
                              ? const Center(
                                  child: Text(
                                    'Nenhum item na agenda',
                                    style: TextStyle(color: AppColors.subtitle),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: controller.itens.length,
                                  itemBuilder: (ctx, idx) {
                                    final AgendaItem item = controller.itens[idx];
                                    return Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      elevation: 4,
                                      margin: const EdgeInsets.symmetric(vertical: 6),
                                      child: ListTile(
                                        title: Text(
                                          item.titulo,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.text,
                                          ),
                                        ),
                                        subtitle: Text(
                                          '${item.descricao}\n'
                                          'Data: ${item.data.toLocal().toString().split(' ')[0]} '
                                          'às ${item.horario}',
                                          style: const TextStyle(color: AppColors.subtitle),
                                        ),
                                        isThreeLine: true,
                                        trailing: IconButton(
                                          icon: const Icon(Icons.edit, size: 24),
                                          color: AppColors.primary,
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => TelaCadastroAgenda(
                                                  itemId: item.id!,
                                                ),
                                              ),
                                            ).then((_) => controller.buscarTodos());
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                        BotaoPadrao(
                          texto: 'Novo Item',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const TelaCadastroAgenda(),
                              ),
                            ).then((_) => controller.buscarTodos());
                          },
                        ),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }
}
