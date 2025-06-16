// lib/features/contrato/screens/tela_cadastro_contrato.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/components/form_widgets.dart';
import '../../../theme/theme.dart';
import '../controllers/contrato_cadastro_controller.dart';
import '../widgets/formulario_contrato.dart';

class TelaCadastroContrato extends StatefulWidget {
  final int? orcamentoId;

  const TelaCadastroContrato({super.key, this.orcamentoId});

  @override
  State<TelaCadastroContrato> createState() => _TelaCadastroContratoState();
}

class _TelaCadastroContratoState extends State<TelaCadastroContrato> {
  late final ContratoCadastroController controller;

  @override
  void initState() {
    super.initState();
    controller = ContratoCadastroController();
    controller.carregarOrcamentos().then((_) {
      if (widget.orcamentoId != null) {
        controller.carregarContratoPorOrcamento(widget.orcamentoId!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: controller,
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
