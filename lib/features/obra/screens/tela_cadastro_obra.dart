import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/components/form_widgets.dart';
import '../controllers/obra_cadastro_controller.dart';
import '../widgets/formulario_obra.dart';

class TelaCadastroObra extends StatelessWidget {
  const TelaCadastroObra({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ObraCadastroController(),
      child: Consumer<ObraCadastroController>(
        builder: (context, controller, _) {
          return Scaffold(
            appBar: const AppBarCustom(titulo: 'Cadastrar nova obra'),
            drawer: const DrawerMenu(),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const FormularioObra(),
                  const SizedBox(height: 24),
                  BotaoPadrao(
                    texto: 'Salvar Obra',
                    onPressed:
                        () => controller.salvarObra(context, mostrarMensagem),
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
