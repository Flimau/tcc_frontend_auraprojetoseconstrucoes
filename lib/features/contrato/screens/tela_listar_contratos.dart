// lib/features/contrato/screens/tela_listar_contratos.dart

import 'package:flutter/material.dart';
import 'package:front_application/shared/services/contrato_service.dart';
import 'package:provider/provider.dart';

import '../../../shared/components/form_widgets.dart';
import '../../../shared/utils/pdf_utils.dart';
import '../../../theme/theme.dart';
import '../controllers/contrato_list_controller.dart';
import '../models/contrato_resumo.dart';
import 'tela_cadastro_contrato.dart';

class TelaListarContratos extends StatelessWidget {
  const TelaListarContratos({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ContratoListController()..buscarTodosContratos(),
      child: Consumer<ContratoListController>(
        builder: (context, controller, _) {
          return Scaffold(
            appBar: const AppBarCustom(titulo: 'Listar Contratos'),
            drawer: const DrawerMenu(),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: BotaoPadrao(
                          texto: 'Cadastrar',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const TelaCadastroContrato(),
                              ),
                            ).then((_) => controller.buscarTodosContratos());
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(),

                  Expanded(
                    child:
                        controller.resultados.isEmpty
                            ? const Center(
                              child: Text(
                                'Nenhum contrato encontrado',
                                style: TextStyle(color: AppColors.subtitle),
                              ),
                            )
                            : ListView.builder(
                              itemCount: controller.resultados.length,
                              itemBuilder: (context, index) {
                                final ContratoResumo contrato =
                                    controller.resultados[index];
                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 4,
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      'Contrato ID: ${contrato.id}  •  Orçamento ID: ${contrato.orcamentoId}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.text,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Cliente: ${contrato.clienteNome} (ID ${contrato.clienteId})',
                                      style: const TextStyle(
                                        color: AppColors.subtitle,
                                      ),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            size: 24,
                                            color: AppColors.primary,
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (_) => TelaCadastroContrato(
                                                      orcamentoId:
                                                          contrato.orcamentoId,
                                                    ),
                                              ),
                                            ).then(
                                              (_) =>
                                                  controller
                                                      .buscarTodosContratos(),
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.picture_as_pdf,
                                            size: 24,
                                            color: AppColors.accent,
                                          ),
                                          onPressed: () async {
                                            try {
                                              final bytes =
                                                  await ContratoService.gerarPdfContrato(
                                                    contrato.id,
                                                  );
                                              await PdfUtils.abrirOuSalvarPdf(
                                                bytes,
                                                'contrato_${contrato.id}.pdf',
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
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete_forever,
                                            size: 24,
                                            color: Colors.red,
                                          ),
                                          onPressed: () async {
                                            final confirmar = await showDialog<
                                              bool
                                            >(
                                              context: context,
                                              builder:
                                                  (ctx) => AlertDialog(
                                                    title: const Text(
                                                      "Confirmação",
                                                    ),
                                                    content: const Text(
                                                      "Deseja realmente excluir o contrato?",
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed:
                                                            () => Navigator.pop(
                                                              ctx,
                                                              false,
                                                            ),
                                                        child: const Text(
                                                          "Cancelar",
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed:
                                                            () => Navigator.pop(
                                                              ctx,
                                                              true,
                                                            ),
                                                        child: const Text(
                                                          "Excluir",
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                            );
                                            if (confirmar == true) {
                                              await ContratoService()
                                                  .deletarContrato(contrato.id);
                                              controller.buscarTodosContratos();
                                            }
                                          },
                                        ),
                                      ],
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
