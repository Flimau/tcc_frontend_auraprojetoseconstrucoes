// lib/features/contrato/screens/tela_listar_contratos.dart

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:front_application/shared/services/contrato_service.dart'; // ContratoService
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../../shared/components/form_widgets.dart'; // AppBarCustom, BotaoPadrao, DropdownPadrao, DrawerMenu
import '../../../theme/theme.dart'; // AppColors, AppTextStyles
import '../controllers/contrato_list_controller.dart'; // ContratoListController
import '../models/contrato.dart'; // Contrato
import 'pdf_viewer_page.dart'; // PdfViewerPage
import 'tela_cadastro_contrato.dart'; // TelaCadastroContrato

class TelaListarContratos extends StatelessWidget {
  const TelaListarContratos({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ContratoListController(),
      child: Consumer<ContratoListController>(
        builder: (context, controller, _) {
          return Scaffold(
            appBar: const AppBarCustom(titulo: 'Listar Contratos'),
            drawer: const DrawerMenu(),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // === FILTRO: Dropdown + TextField ===
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
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          controller: controller.valorBuscaController,
                          decoration: InputDecoration(
                            labelText:
                                controller.chaveSelecionada == 'ID do orçamento'
                                    ? 'ID do orçamento'
                                    : 'Nome do cliente',
                          ),
                          keyboardType:
                              controller.chaveSelecionada == 'ID do orçamento'
                                  ? TextInputType.number
                                  : TextInputType.text,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // === BOTÕES “Buscar” e “Cadastrar” ===
                  Row(
                    children: [
                      Expanded(
                        child: BotaoPadrao(
                          texto: 'Buscar',
                          onPressed: () {
                            controller.buscar(context);
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
                                builder: (_) => const TelaCadastroContrato(),
                              ),
                            ).then((_) {
                              controller.buscar(context);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(),

                  // === LISTA DE RESULTADOS ===
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
                                final Contrato contrato =
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
                                      'Contrato ID: ${contrato.id}  •  '
                                      'Orçamento ID: ${contrato.orcamentoId}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.text,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Cliente: ${contrato.clienteNome} (ID ${contrato.clienteId})\n'
                                      'Status: ${contrato.status}',
                                      style: const TextStyle(
                                        color: AppColors.subtitle,
                                      ),
                                    ),
                                    isThreeLine: true,
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // Ícone de edição
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            size: 24,
                                          ),
                                          color: AppColors.primary,
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
                                            ).then((_) {
                                              controller.buscar(context);
                                            });
                                          },
                                        ),
                                        const SizedBox(width: 8),
                                        // Ícone de PDF
                                        IconButton(
                                          icon: const Icon(
                                            Icons.picture_as_pdf,
                                            size: 24,
                                          ),
                                          color: AppColors.accent,
                                          onPressed: () async {
                                            try {
                                              Uint8List bytes =
                                                  await ContratoService()
                                                      .baixarContratoPdf(
                                                        contrato.orcamentoId,
                                                      );
                                              Directory tempDir =
                                                  await getTemporaryDirectory();
                                              String filePath =
                                                  '${tempDir.path}/contrato_${contrato.orcamentoId}.pdf';
                                              File(
                                                filePath,
                                              ).writeAsBytesSync(bytes);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (_) => PdfViewerPage(
                                                        filePath: filePath,
                                                      ),
                                                ),
                                              );
                                            } catch (e) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Erro ao abrir PDF: ${e.toString()}',
                                                  ),
                                                ),
                                              );
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
