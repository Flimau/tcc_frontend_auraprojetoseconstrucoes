import 'package:flutter/material.dart';
import 'package:front_application/shared/utils/formatters.dart';
import 'package:provider/provider.dart';

import '../../../shared/components/form_widgets.dart';
import '../../../theme/colors.dart';
import '../../../theme/text_styles.dart';
import '../controllers/diario_controller.dart';

class TelaAcompanhamentoObra extends StatefulWidget {
  final String obraId;
  const TelaAcompanhamentoObra({Key? key, required this.obraId})
    : super(key: key);

  @override
  State<TelaAcompanhamentoObra> createState() => _TelaAcompanhamentoObraState();
}

class _TelaAcompanhamentoObraState extends State<TelaAcompanhamentoObra> {
  late DiarioController controller;

  @override
  void initState() {
    super.initState();
    controller = DiarioController(obraId: widget.obraId);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DiarioController>.value(
      value: controller,
      child: Scaffold(
        appBar: const AppBarCustom(titulo: 'Acompanhamento da Obra'),
        drawer: const DrawerMenu(),
        backgroundColor: AppColors.background,
        body: Consumer<DiarioController>(
          builder: (context, ctrl, _) {
            if (ctrl.carregando) {
              return const Center(child: CircularProgressIndicator());
            }
            if (ctrl.erro != null) {
              return Center(
                child: Text(
                  ctrl.erro!,
                  style: AppTextStyles.body.copyWith(color: AppColors.error),
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título de seção
                  const TituloSecao('Diário da Obra'),
                  const SizedBox(height: 16),

                  // Campo “Data (DD/MM/AAAA)”
                  InputCampo(
                    label: 'Data (DD/MM/AAAA)',
                    icone: Icons.calendar_today,
                    controller: ctrl.dataController,
                    mascaras: [dataMask],
                  ),
                  const SizedBox(height: 16),

                  // Campo multilinha “Itens do Dia”
                  InputCampoMultiline(
                    label: 'Itens do Dia (uma linha por item)',
                    icone: Icons.list_alt,
                    controller: ctrl.itensController,
                    maxLines: 4,
                  ),
                  const SizedBox(height: 16),

                  // Campo multilinha “Observações”
                  InputCampoMultiline(
                    label: 'Observações',
                    icone: Icons.note,
                    controller: ctrl.observacoesController,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),

                  // Botões Registrar/Atualizar e Cancelar
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            textStyle: AppTextStyles.fontButton.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                          onPressed:
                              () => ctrl.salvarDiario(context, mostrarMensagem),
                          child: Text(
                            ctrl.editandoId == null
                                ? 'Registrar Andamento'
                                : 'Atualizar Andamento',
                            style: AppTextStyles.fontButton.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                      if (ctrl.editandoId != null) ...[
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade400,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              textStyle: AppTextStyles.fontButton.copyWith(
                                color: AppColors.text,
                              ),
                            ),
                            onPressed: ctrl.cancelarEdicao,
                            child: Text(
                              'Cancelar',
                              style: AppTextStyles.fontButton.copyWith(
                                color: AppColors.text,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  const Divider(height: 40, thickness: 1, color: Colors.grey),

                  const TituloSecao('Registros Anteriores'),
                  const SizedBox(height: 12),

                  if (ctrl.diarios.isEmpty)
                    Center(
                      child: Text(
                        'Nenhum registro encontrado.',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.subtitle,
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: ctrl.diarios.length,
                      itemBuilder: (context, index) {
                        final diario = ctrl.diarios[index];
                        return Card(
                          color: AppColors.white,
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 16,
                            ),
                            title: Text(
                              _formatarDataVisual(diario.dataRegistro),
                              style: AppTextStyles.headline.copyWith(
                                fontSize: 18,
                                color: AppColors.primary,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Itens: ${diario.itens.join(', ')}',
                                    style: AppTextStyles.body,
                                  ),
                                  if (diario.observacoes != null &&
                                      diario.observacoes!.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Text(
                                        'Obs: ${diario.observacoes!}',
                                        style: AppTextStyles.subtitle,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            isThreeLine: true,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: AppColors.accent,
                                  ),
                                  onPressed: () {
                                    ctrl.prepararEdicao(diario);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: AppColors.error,
                                  ),
                                  onPressed: () {
                                    _confirmarExclusao(
                                      context,
                                      ctrl,
                                      diario.id,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Diálogo de confirmação de exclusão
  void _confirmarExclusao(
    BuildContext context,
    DiarioController ctrl,
    String diarioId,
  ) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: AppColors.white,
            title: Text(
              'Excluir Registro',
              style: AppTextStyles.headline.copyWith(fontSize: 20),
            ),
            content: Text(
              'Tem certeza que deseja excluir este registro?',
              style: AppTextStyles.body,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancelar', style: AppTextStyles.link),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ctrl.excluirDiario(context, diarioId, mostrarMensagem);
                },
                child: Text(
                  'Excluir',
                  style: AppTextStyles.link.copyWith(color: AppColors.error),
                ),
              ),
            ],
          ),
    );
  }

  /// Exibe Snackbar (verde para sucesso, vermelho para erro)
  void mostrarMensagem(
    BuildContext context,
    String texto, {
    bool erro = false,
  }) {
    final snackBar = SnackBar(
      content: Text(
        texto,
        style: AppTextStyles.body.copyWith(color: AppColors.white),
      ),
      backgroundColor: erro ? AppColors.error : AppColors.success,
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  /// Converte ISO “YYYY-MM-DD” para “DD/MM/AAAA”
  String _formatarDataVisual(String isoDate) {
    try {
      final parts = isoDate.split('-');
      return '${parts[2].padLeft(2, '0')}/${parts[1].padLeft(2, '0')}/${parts[0]}';
    } catch (_) {
      return isoDate;
    }
  }
}
