// lib/features/kanban/screens/tela_kanban.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/components/form_widgets.dart'; // AppBarCustom, BotaoPadrao, DrawerMenu
import '../controllers/kanban_controller.dart'; // KanbanController
import '../models/kanban_card.dart'; // KanbanCard
import '../widgets/kanban_column.dart'; // KanbanColumn

class TelaKanban extends StatelessWidget {
  const TelaKanban({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => KanbanController()..carregarCards(),
      child: Consumer<KanbanController>(
        builder: (context, controller, _) {
          return Scaffold(
            appBar: const AppBarCustom(titulo: 'Kanban'),
            drawer: const DrawerMenu(),
            body:
                controller.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Row(
                      children: [
                        KanbanColumn(
                          titulo: 'TO DO',
                          cards: controller.todo,
                          onDragStarted: (card) {},
                          onAccept:
                              (card) => controller.moverCard(card, 'TODO'),
                        ),
                        KanbanColumn(
                          titulo: 'IN PROGRESS',
                          cards: controller.inProgress,
                          onDragStarted: (card) {},
                          onAccept:
                              (card) =>
                                  controller.moverCard(card, 'IN_PROGRESS'),
                        ),
                        KanbanColumn(
                          titulo: 'DONE',
                          cards: controller.done,
                          onDragStarted: (card) {},
                          onAccept:
                              (card) => controller.moverCard(card, 'DONE'),
                        ),
                      ],
                    ),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                _mostrarDialogoCriar(context, controller);
              },
            ),
          );
        },
      ),
    );
  }

  void _mostrarDialogoCriar(BuildContext context, KanbanController controller) {
    final tituloCtrl = TextEditingController();
    final descricaoCtrl = TextEditingController();
    String status = 'TODO';

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Novo Card'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tituloCtrl,
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              TextField(
                controller: descricaoCtrl,
                decoration: const InputDecoration(labelText: 'Descrição'),
              ),
              const SizedBox(height: 8),
              DropdownButton<String>(
                value: status,
                items:
                    ['TODO', 'IN_PROGRESS', 'DONE'].map((st) {
                      return DropdownMenuItem(
                        value: st,
                        child: Text(st.replaceAll('_', ' ')),
                      );
                    }).toList(),
                onChanged: (v) {
                  if (v != null) {
                    status = v;
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final novo = KanbanCard(
                  id: null,
                  titulo: tituloCtrl.text.trim(),
                  descricao: descricaoCtrl.text.trim(),
                  status: status,
                );
                controller.criarCard(novo).then((_) => Navigator.of(ctx).pop());
              },
              child: const Text('Criar'),
            ),
          ],
        );
      },
    );
  }
}
