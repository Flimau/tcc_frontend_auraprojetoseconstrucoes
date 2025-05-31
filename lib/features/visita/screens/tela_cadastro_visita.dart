import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/components/form_widgets.dart';
import '../controllers/visita_cadastro_controller.dart';
import '../widgets/formulario_visita.dart';

class TelaCadastroVisita extends StatelessWidget {
  const TelaCadastroVisita({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VisitaCadastroController(),
      child: Consumer<VisitaCadastroController>(
        builder: (context, controller, _) {
          return Scaffold(
            appBar: const AppBarCustom(titulo: 'Cadastro de Visita'),
            drawer: const DrawerMenu(),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const FormularioVisita(),
                  const SizedBox(height: 24),
                  BotaoPadrao(
                    texto: 'Salvar Visita',
                    onPressed:
                        () => controller.salvarVisita(context, mostrarMensagem),
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
