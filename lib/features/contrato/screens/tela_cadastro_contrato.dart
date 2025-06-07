// lib/features/contrato/screens/tela_cadastro_contrato.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/components/form_widgets.dart'; // AppBarCustom, BotaoPadrao, DrawerMenu
import '../../../theme/theme.dart'; // AppColors, AppTextStyles
import '../controllers/contrato_cadastro_controller.dart'; // ContratoCadastroController
import '../widgets/formulario_contrato.dart'; // FormularioContrato

class TelaCadastroContrato extends StatefulWidget {
  /// Se quiser editar um contrato existente, passe orcamentoId.
  final int? orcamentoId;

  const TelaCadastroContrato({super.key, this.orcamentoId});

  @override
  State<TelaCadastroContrato> createState() => _TelaCadastroContratoState();
}

class _TelaCadastroContratoState extends State<TelaCadastroContrato> {
  @override
  void initState() {
    super.initState();
    // Se veio orcamentoId, carregamos dados existentes
    if (widget.orcamentoId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<ContratoCadastroController>().carregarContratoExistente(
          widget.orcamentoId!,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ContratoCadastroController(),
      child: Consumer<ContratoCadastroController>(
        builder: (context, controller, _) {
          return Scaffold(
            appBar: AppBarCustom(
              titulo:
                  widget.orcamentoId == null
                      ? 'Novo Contrato'
                      : 'Editar Contrato',
            ),
            drawer: const DrawerMenu(),
            backgroundColor: AppColors.background,
            body:
                controller.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const FormularioContrato(),
                          const SizedBox(height: 24),
                          BotaoPadrao(
                            texto:
                                widget.orcamentoId == null
                                    ? 'Criar Contrato'
                                    : 'Atualizar Contrato',
                            onPressed: () => controller.salvarContrato(context),
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
