// lib/features/obra/screens/tela_kanban_obras.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../theme/theme.dart';
import '../../obra/models/obra.dart';
import '../controllers/obra_kanban_controller.dart';

class TelaKanbanObras extends StatelessWidget {
  const TelaKanbanObras({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ObraKanbanController()..carregarObras(),
      child: Consumer<ObraKanbanController>(
        builder: (context, controller, _) {
          if (controller.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Kanban de Obras',
                style: AppTextStyles.headline,
              ),
              backgroundColor: AppColors.primary,
              centerTitle: true,
            ),
            backgroundColor: AppColors.background,
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _colunaKanban(
                    'Pendente',
                    controller.pendentes,
                    Colors.amber,
                    (obra) => controller.moverStatus(obra, 'EM_ANDAMENTO'),
                    permitirDragEntrada: false,
                  ),
                  _colunaKanban(
                    'Em Andamento',
                    controller.emAndamento,
                    Colors.blue,
                    (obra) => controller.moverStatus(obra, 'CONCLUIDA'),
                    permitirDragEntrada: true,
                  ),
                  _colunaKanban(
                    'Concluída',
                    controller.concluidas,
                    Colors.green,
                    (_) {}, // não move para lugar nenhum
                    permitirDragEntrada: true,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _colunaKanban(
    String titulo,
    List<Obra> obras,
    Color cor,
    void Function(Obra) onAccept, {
    bool permitirDragEntrada = false,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: cor.withOpacity(0.1),
          border: Border.all(color: cor, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(titulo, style: AppTextStyles.headline),
            const SizedBox(height: 12),
            Expanded(
              child: DragTarget<Obra>(
                onWillAccept: (_) => permitirDragEntrada,
                onAccept: (obra) => onAccept(obra),
                builder: (context, candidate, rejected) {
                  return ListView(
                    children:
                        obras.map((obra) {
                          return Draggable<Obra>(
                            data: obra,
                            feedback: Material(
                              child: Container(
                                width: 200,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black12),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(obra.clienteNome),
                              ),
                            ),
                            child: Card(
                              child: ListTile(
                                title: Text(obra.clienteNome),
                                subtitle: Text('Orç: ${obra.orcamentoId}'),
                              ),
                            ),
                          );
                        }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
