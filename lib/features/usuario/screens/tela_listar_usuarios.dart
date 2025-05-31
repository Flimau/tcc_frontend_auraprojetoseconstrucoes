import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/components/form_widgets.dart';
import '../../../theme/theme.dart'; // ← importa seu tema
import '../controllers/usuario_list_controller.dart';
import '../screens/tela_cadastro_usuario.dart';

class TelaListarUsuarios extends StatelessWidget {
  const TelaListarUsuarios({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UsuarioListController(),
      child: Consumer<UsuarioListController>(
        builder: (context, controller, _) {
          return Scaffold(
            appBar: const AppBarCustom(titulo: 'Listar Cadastros de Usuários'),
            drawer: const DrawerMenu(),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Filtros
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: DropdownPadrao(
                          label: 'Buscar por',
                          itens: controller.chaves,
                          valorSelecionado: controller.chaveSelecionada,
                          onChanged: (value) {
                            controller.chaveSelecionada = value!;
                            controller.notifyListeners();
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 3,
                        child: TextField(
                          controller: controller.campoBuscaController,
                          decoration: const InputDecoration(labelText: 'Valor'),
                        ),
                      ),
                    ],
                  ),
                  DropdownPadrao(
                    label: 'Tipo de Usuário',
                    itens: controller.tiposUsuario,
                    valorSelecionado: controller.tipoUsuarioSelecionado,
                    onChanged: (value) {
                      controller.tipoUsuarioSelecionado = value;
                      controller.notifyListeners();
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: BotaoPadrao(
                          texto: 'Buscar',
                          onPressed: () async {
                            controller.buscar();
                            controller.campoBuscaController.clear();
                            controller.chaveSelecionada =
                                controller.chaves.first;
                            controller.tipoUsuarioSelecionado = null;
                            controller.notifyListeners();
                          },
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
                                builder: (_) => const TelaCadastroUsuario(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Estado vazio ou tabela
                  Expanded(
                    child:
                        controller.resultados.isEmpty
                            ? Center(
                              child: Text(
                                'Nenhum usuário encontrado com esses parâmetros.',
                                style: AppTextStyles.body.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: AppColors.text,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                            : TabelaGenerica(
                              dados:
                                  controller.resultados
                                      .map(
                                        (usu) => {
                                          'ID': usu.id,
                                          'Nome': usu.nome,
                                          'Documento': usu.documento,
                                          'Ativo': usu.ativo ? 'Sim' : 'Não',
                                        },
                                      )
                                      .toList(),
                              colunas: const [
                                'ID',
                                'Nome',
                                'Documento',
                                'Ativo',
                              ],
                              chaves: const [
                                'ID',
                                'Nome',
                                'Documento',
                                'Ativo',
                              ],
                              onEditar: (usuarioMap) {
                                final id = usuarioMap['ID'];
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) =>
                                            TelaCadastroUsuario(idUsuario: id),
                                  ),
                                ).then((voltouComMudanca) {
                                  if (voltouComMudanca == true) {
                                    controller.carregarUsuarios();
                                  }
                                });
                              },
                              onSort: (columnIndex, ascending) {
                                controller.sortDados(columnIndex, ascending);
                              },
                              sortColumnIndex: controller.sortColumnIndex,
                              isAscending: controller.isAscending,
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
