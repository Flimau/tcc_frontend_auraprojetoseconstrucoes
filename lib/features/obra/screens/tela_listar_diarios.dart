// lib/features/obra/screens/tela_listar_diarios.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/components/form_widgets.dart';
import '../../../theme/theme.dart';
import '../controllers/diario_controller.dart';
import 'tela_cadastro_diario.dart';

class TelaListarDiarios extends StatelessWidget {
  final int obraId;

  const TelaListarDiarios({super.key, required this.obraId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DiarioController()..fetchDiarios(obraId),
      child: Consumer<DiarioController>(
        builder: (context, controller, _) {
          return Scaffold(
            appBar: AppBarCustom(titulo: 'Diários da Obra $obraId'),
            drawer: const DrawerMenu(),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child:
                  controller.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : controller.diarios.isEmpty
                      ? const Center(
                        child: Text(
                          'Nenhum diário encontrado',
                          style: TextStyle(color: AppColors.subtitle),
                        ),
                      )
                      : ListView.builder(
                        itemCount: controller.diarios.length,
                        itemBuilder: (context, index) {
                          final d = controller.diarios[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            child: ListTile(
                              title: Text('Data: ${d.dataRegistro}'),
                              subtitle: Text(
                                'Itens:\n${d.itens.join('\n')}\n'
                                'Observações: ${d.observacoes ?? "-"}',
                                style: const TextStyle(
                                  color: AppColors.subtitle,
                                ),
                              ),
                              isThreeLine: true,
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    color: AppColors.primary,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => TelaCadastroDiario(
                                                obraId: obraId,
                                                diarioId: d.id,
                                              ),
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    color: Colors.red,
                                    onPressed: () {
                                      controller.deleteDiario(
                                        obraId,
                                        d.id,
                                        context,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TelaCadastroDiario(obraId: obraId),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
