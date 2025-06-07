import 'package:flutter/material.dart';
import 'package:front_application/shared/components/form_widgets.dart';
import 'package:provider/provider.dart';

import '../../../theme/theme.dart';
import '../controllers/obra_list_controller.dart';
import 'tela_cadastro_obra.dart';
import 'tela_listar_diarios.dart';

class TelaListarObras extends StatelessWidget {
  const TelaListarObras({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ObraListController()..buscarTodas(),
      child: Consumer<ObraListController>(
        builder: (context, controller, _) {
          return Scaffold(
            appBar: const AppBarCustom(titulo: 'Listar Obras'),
            drawer: const DrawerMenu(),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: controller.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : controller.obras.isEmpty
                      ? const Center(
                          child: Text(
                            'Nenhuma obra encontrada',
                            style: TextStyle(color: AppColors.subtitle),
                          ),
                        )
                      : ListView.builder(
                          itemCount: controller.obras.length,
                          itemBuilder: (context, index) {
                            final obra = controller.obras[index];
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 4,
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              child: ListTile(
                                title: Text(
                                  'Obra ${obra.id} — Cliente: ${obra.clienteNome}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.text,
                                  ),
                                ),
                                subtitle: Text(
                                  'Período: ${obra.dataInicio} → ${obra.dataFim}\n'
                                  'Status: ${obra.status}',
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
                                      tooltip: 'Editar Obra',
                                      color: AppColors.primary,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => TelaCadastroObra(
                                              obraId: obra.id!,
                                            ),
                                          ),
                                        ).then((_) =>
                                            controller.buscarTodas());
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.menu_book),
                                      tooltip: 'Ver Diários',
                                      color: AppColors.accent,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                TelaListarDiarios(
                                                    obraId: obra.id!),
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      tooltip: 'Excluir Obra',
                                      color: AppColors.error,
                                      onPressed: () {
                                        _confirmarExclusao(
                                            context, controller, obra.id!);
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
                  MaterialPageRoute(builder: (_) => const TelaCadastroObra()),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _confirmarExclusao(
    BuildContext context,
    ObraListController controller,
    int obraId,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.white,
        title: const Text('Excluir Obra'),
        content: const Text('Deseja excluir esta obra?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await controller.excluirObra(obraId, context);
            },
            child: const Text(
              'Excluir',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
