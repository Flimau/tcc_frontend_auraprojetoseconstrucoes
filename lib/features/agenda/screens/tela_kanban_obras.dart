import 'package:flutter/material.dart';

import '../../../theme/theme.dart';

class TelaKanbanObras extends StatelessWidget {
  const TelaKanbanObras({super.key});

  @override
  Widget build(BuildContext context) {
    // Simula uma lista de obras por status
    final obras = [
      {'titulo': 'Obra 1', 'status': 'PENDENTE'},
      {'titulo': 'Obra 2', 'status': 'EM ANDAMENTO'},
      {'titulo': 'Obra 3', 'status': 'FINALIZADA'},
      {'titulo': 'Obra 4', 'status': 'PENDENTE'},
      {'titulo': 'Obra 5', 'status': 'EM ANDAMENTO'},
    ];

    // Separa por status
    final pendentes = obras.where((o) => o['status'] == 'PENDENTE').toList();
    final andamento =
        obras.where((o) => o['status'] == 'EM ANDAMENTO').toList();
    final finalizadas =
        obras.where((o) => o['status'] == 'FINALIZADA').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kanban de Obras', style: AppTextStyles.headline),
        backgroundColor: AppColors.primary,
        centerTitle: true,
      ),
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _colunaKanban('Pendente', pendentes, Colors.amber),
            _colunaKanban('Em Andamento', andamento, Colors.blue),
            _colunaKanban('Finalizada', finalizadas, Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _colunaKanban(
    String titulo,
    List<Map<String, dynamic>> obras,
    Color cor,
  ) {
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
            ...obras.map(
              (obra) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(obra['titulo']),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
