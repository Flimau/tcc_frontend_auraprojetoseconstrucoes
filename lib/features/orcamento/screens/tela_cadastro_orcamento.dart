import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/components/form_widgets.dart';
import '../controllers/orcamento_cadastro_controller.dart';
import '../widgets/formulario_orcamento.dart';

class TelaCadastroOrcamento extends StatelessWidget {
  const TelaCadastroOrcamento({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OrcamentoCadastroController(),
      child: Consumer<OrcamentoCadastroController>(
        builder: (context, controller, _) {
          return Scaffold(
            appBar: const AppBarCustom(titulo: 'Novo Orçamento'),
            drawer: const DrawerMenu(),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const FormularioOrcamento(),
                  const SizedBox(height: 24),
                  BotaoPadrao(
                    texto: 'Salvar Orçamento',
                    onPressed:
                        () => controller.salvarOrcamento(
                          context,
                          mostrarMensagem,
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
