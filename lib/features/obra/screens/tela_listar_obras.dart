import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/components/form_widgets.dart';
import '../controllers/obra_list_controller.dart';
import 'tela_cadastro_obra.dart';

class TelaListarObras extends StatelessWidget {
  const TelaListarObras({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ObraListController(),
      child: Consumer<ObraListController>(
        builder: (context, controller, _) {
          return Scaffold(
            appBar: const AppBarCustom(titulo: 'Listar Obras'),
            drawer: const DrawerMenu(),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: DropdownPadrao(
                          label: 'Buscar por',
                          itens: controller.chaves,
                          valorSelecionado: controller.chaveSelecionada,
                          onChanged: (value) {
                            controller.atualizarChave(value!);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (controller.chaveSelecionada == 'Data de criação') ...[
                        Expanded(
                          child: TextFormField(
                            controller: controller.dataInicioController,
                            decoration: const InputDecoration(
                              labelText: 'Início',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            controller: controller.dataFimController,
                            decoration: const InputDecoration(labelText: 'Fim'),
                          ),
                        ),
                      ] else ...[
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: controller.valorBuscaController,
                            decoration: const InputDecoration(
                              labelText: 'Valor',
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: BotaoPadrao(
                          texto: 'Buscar',
                          onPressed: () => controller.buscar(context),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: BotaoPadrao(
                          texto: 'Cadastrar',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const TelaCadastroObra(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.resultados.length,
                      itemBuilder: (context, index) {
                        final obra = controller.resultados[index];
                        return Card(
                          child: ListTile(
                            title: Text(obra.clienteNome),
                            subtitle: Text('Status: ${obra.status}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const TelaCadastroObra(),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
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
