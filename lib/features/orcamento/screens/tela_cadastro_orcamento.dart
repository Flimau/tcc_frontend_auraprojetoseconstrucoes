// lib/features/orcamento/screens/tela_cadastro_orcamento.dart

import 'package:flutter/material.dart';
import 'package:front_application/shared/services/orcamento_service.dart';
import 'package:provider/provider.dart';

import '../../../shared/components/form_widgets.dart'; // AppBarCustom, DrawerMenu, BotaoPadrao, BotaoVoltar
import '../../../shared/utils/pdf_utils.dart';
import '../../../theme/colors.dart';
import '../../../theme/text_styles.dart';
import '../controllers/orcamento_cadastro_controller.dart';
import '../widgets/formulario_orcamento.dart';

class TelaCadastroOrcamento extends StatefulWidget {
  const TelaCadastroOrcamento({Key? key}) : super(key: key);

  static const routeName = '/orcamentos/cadastro';

  @override
  State<TelaCadastroOrcamento> createState() => _TelaCadastroOrcamentoState();
}

class _TelaCadastroOrcamentoState extends State<TelaCadastroOrcamento> {
  late OrcamentoCadastroController _controller;
  bool _isInit = false;

  @override
  void initState() {
    super.initState();
    // Inicialmente, cria o controller sem ID (modo criação)
    _controller = OrcamentoCadastroController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is String) {
        // Se veio um ID, refaz o controller em modo edição
        final id = int.tryParse(args);
        _controller.dispose();
        _controller = OrcamentoCadastroController(orcamentoId: id);
      }
      _isInit = true;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _mostrarMensagem(
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
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    );
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OrcamentoCadastroController>.value(
      value: _controller,
      child: Consumer<OrcamentoCadastroController>(
        builder: (ctx, controller, _) {
          return Scaffold(
            appBar: AppBarCustom(
              titulo:
                  controller.orcamentoId == null
                      ? 'Novo Orçamento'
                      : 'Editar Orçamento #${controller.orcamentoId}',
            ),
            drawer: const DrawerMenu(),
            backgroundColor: AppColors.background,
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Botão “Voltar”
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: BotaoVoltar(),
                  ),
                  const SizedBox(height: 16),

                  // Formulário de Orçamento
                  const FormularioOrcamento(),

                  const SizedBox(height: 24),

                  // Botão Salvar / Atualizar
                  if (controller.carregando)
                    const Center(child: CircularProgressIndicator())
                  else
                    BotaoPadrao(
                      texto:
                          controller.orcamentoId == null
                              ? 'Salvar Orçamento'
                              : 'Atualizar Orçamento',
                      onPressed:
                          () => controller.saveOrcamento(ctx, _mostrarMensagem),
                    ),

                  const SizedBox(height: 12),
                  if (controller.orcamentoId != null)
                    BotaoPadrao(
                      texto: 'Gerar PDF',
                      onPressed: () async {
                        try {
                          final bytes =
                              await OrcamentoService.gerarPdfOrcamento(
                                controller.orcamentoId!,
                              );
                          await PdfUtils.abrirOuSalvarPdf(
                            bytes,
                            'orcamento_${controller.orcamentoId}.pdf',
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Erro ao gerar PDF: $e')),
                          );
                        }
                      },
                    ),

                  const SizedBox(height: 12),
                  if (controller.sucesso != null)
                    Text(
                      controller.sucesso!,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.success,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  if (controller.erro != null)
                    Text(
                      controller.erro!,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.error,
                      ),
                      textAlign: TextAlign.center,
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
