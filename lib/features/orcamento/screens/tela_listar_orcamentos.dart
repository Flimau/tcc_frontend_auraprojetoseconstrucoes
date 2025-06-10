// lib/features/orcamento/screens/tela_listar_orcamentos.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/components/form_widgets.dart';
import '../../../shared/services/orcamento_service.dart';
import '../../../shared/utils/pdf_utils.dart';
import '../../../theme/colors.dart';
import '../../../theme/text_styles.dart';
import '../controllers/orcamento_list_controller.dart';
import 'tela_cadastro_orcamento.dart';

class TelaListarOrcamentos extends StatelessWidget {
  const TelaListarOrcamentos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OrcamentoListController>(
      create: (_) => OrcamentoListController(),
      child: Consumer<OrcamentoListController>(
        builder: (context, controller, _) {
          return Scaffold(
            appBar: const AppBarCustom(titulo: 'Listar Orçamentos'),
            drawer: const DrawerMenu(),
            backgroundColor: AppColors.background,
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Botões de ação
                  Row(
                    children: [
                      Expanded(
                        child: BotaoPadrao(
                          texto: 'Recarregar',
                          onPressed: () => controller.fetchAllOrcamentos(),
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
                                builder: (_) => const TelaCadastroOrcamento(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  const Divider(),

                  if (controller.carregando)
                    const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (controller.erro != null)
                    Expanded(
                      child: Center(
                        child: Text(
                          controller.erro!,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.error,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  else if (controller.orcamentos.isEmpty)
                    Expanded(
                      child: Center(
                        child: Text(
                          'Nenhum orçamento encontrado.',
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.subtitle,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: controller.orcamentos.length,
                        itemBuilder: (context, index) {
                          final orc = controller.orcamentos[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: CardContainer(
                              child: ListTile(
                                tileColor: AppColors.white,
                                title: Text(
                                  'ID ${orc.id} • ${orc.clienteNome}',
                                  style: AppTextStyles.body.copyWith(
                                    color: AppColors.text,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  '${orc.tipo} > ${orc.subtipo}\nCriado em: ${orc.dataCriacao.toString().substring(0, 10)}',
                                  style: AppTextStyles.body.copyWith(
                                    color: AppColors.subtitle,
                                  ),
                                ),
                                isThreeLine: true,
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Editar
                                    IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color: AppColors.primary,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (_) =>
                                                    const TelaCadastroOrcamento(),
                                            settings: RouteSettings(
                                              arguments: orc.id.toString(),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    // Gerar PDF
                                    IconButton(
                                      icon: const Icon(
                                        Icons.picture_as_pdf,
                                        color: AppColors.accent,
                                      ),
                                      tooltip: 'Gerar PDF',
                                      onPressed: () async {
                                        try {
                                          final bytes =
                                              await OrcamentoService.gerarPdfOrcamento(
                                                orc.id,
                                              );
                                          await PdfUtils.abrirOuSalvarPdf(
                                            bytes,
                                            'orcamento_${orc.id}.pdf',
                                          );
                                        } catch (e) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Erro ao gerar PDF: $e',
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    // Excluir
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: AppColors.error,
                                      ),
                                      onPressed: () async {
                                        await controller.deleteOrcamento(
                                          context,
                                          (ctxMsg, texto, {bool erro = false}) {
                                            final snack = SnackBar(
                                              content: Text(
                                                texto,
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
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 24,
                                                    vertical: 12,
                                                  ),
                                            );
                                            ScaffoldMessenger.of(ctxMsg)
                                              ..removeCurrentSnackBar()
                                              ..showSnackBar(snack);
                                          },
                                          orc.id,
                                        );
                                      },
                                    ),
                                  ],
                                ),
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
