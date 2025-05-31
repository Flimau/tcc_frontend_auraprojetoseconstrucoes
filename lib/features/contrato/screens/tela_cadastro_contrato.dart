import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/components/form_widgets.dart';
import '../../../theme/theme.dart';
import '../controllers/contrato_cadastro_controller.dart';
import '../widgets/formulario_contrato.dart';

class TelaCadastroContrato extends StatelessWidget {
  const TelaCadastroContrato({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ContratoCadastroController(),
      child: Consumer<ContratoCadastroController>(
        builder: (context, controller, _) {
          return Scaffold(
            appBar: const AppBarCustom(titulo: 'Novo Contrato'),
            drawer: const DrawerMenu(),
            backgroundColor: AppColors.background,
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const FormularioContrato(),
                  const SizedBox(height: 24),
                  BotaoPadrao(
                    texto: 'Salvar Contrato',
                    onPressed:
                        () =>
                            controller.salvarContrato(context, mostrarMensagem),
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
