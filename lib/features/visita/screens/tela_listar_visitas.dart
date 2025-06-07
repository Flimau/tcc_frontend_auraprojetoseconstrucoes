// lib/features/visita/screens/tela_listar_visitas.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/components/form_widgets.dart';
import '../../../shared/utils/formatters.dart';
import '../../../theme/colors.dart';
import '../../../theme/text_styles.dart';
import '../controllers/visita_list_controller.dart';
import 'tela_cadastro_visita.dart';

class TelaListarVisitas extends StatelessWidget {
  const TelaListarVisitas({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VisitaListController(),
      child: Consumer<VisitaListController>(
        builder: (context, controller, _) {
          return Scaffold(
            appBar: const AppBarCustom(titulo: 'Listar Visitas'),
            drawer: const DrawerMenu(),
            backgroundColor: AppColors.background,
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // ===== Filtros =====
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: DropdownPadrao(
                          label: 'Buscar por',
                          itens: controller.chaves,
                          valorSelecionado: controller.chaveSelecionada,
                          onChanged:
                              (value) => controller.atualizarChave(value!),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Se "DataVisita" selecionado, exibimos intervalo de datas
                      if (controller.chaveSelecionada == 'DataVisita') ...[
                        Expanded(
                          child: InputCampo(
                            label: 'Início (DD/MM/AAAA)',
                            icone: Icons.calendar_month,
                            controller: controller.dataInicioController,
                            tipoTeclado: TextInputType.datetime,
                            mascaras: [dataMask],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: InputCampo(
                            label: 'Fim (DD/MM/AAAA)',
                            icone: Icons.calendar_month,
                            controller: controller.dataFimController,
                            tipoTeclado: TextInputType.datetime,
                            mascaras: [dataMask],
                          ),
                        ),
                      ] else ...[
                        Expanded(
                          flex: 3,
                          child: InputCampo(
                            label: 'Valor',
                            icone: Icons.search,
                            controller: controller.valorBuscaController,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
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
                                builder: (_) => const TelaCadastroVisita(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(color: AppColors.subtitle),

                  // ===== Lista de resultados =====
                  Expanded(
                    child:
                        controller.carregando
                            ? const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            )
                            : controller.erro != null
                            ? Center(
                              child: Text(
                                controller.erro!,
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.error,
                                ),
                              ),
                            )
                            : controller.resultados.isEmpty
                            ? Center(
                              child: Text(
                                'Nenhuma visita encontrada.',
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.subtitle,
                                ),
                              ),
                            )
                            : ListView.builder(
                              itemCount: controller.resultados.length,
                              itemBuilder: (context, index) {
                                final visita = controller.resultados[index];
                                return CardContainer(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              visita.endereco.logradouro,
                                              style: AppTextStyles.subtitle
                                                  .copyWith(
                                                    color: AppColors.primary,
                                                  ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Cliente: ${visita.clienteNome}',
                                              style: AppTextStyles.body,
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              'Data: ${visita.dataVisita}',
                                              style: AppTextStyles.body,
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: AppColors.primary,
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (_) =>
                                                      const TelaCadastroVisita(),
                                              settings: RouteSettings(
                                                arguments: visita.id,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: AppColors.error,
                                        ),
                                        onPressed: () {
                                          controller.deleteVisita(
                                            context,
                                            visita.id,
                                            (ctx, msg, {erro = false}) {
                                              final snackBar = SnackBar(
                                                content: Text(
                                                  msg,
                                                  style: AppTextStyles.body
                                                      .copyWith(
                                                        color: AppColors.white,
                                                      ),
                                                ),
                                                backgroundColor:
                                                    erro
                                                        ? AppColors.error
                                                        : AppColors.success,
                                                duration: const Duration(
                                                  seconds: 2,
                                                ),
                                              );
                                              ScaffoldMessenger.of(ctx)
                                                ..removeCurrentSnackBar()
                                                ..showSnackBar(snackBar);
                                            },
                                          );
                                        },
                                      ),
                                    ],
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
