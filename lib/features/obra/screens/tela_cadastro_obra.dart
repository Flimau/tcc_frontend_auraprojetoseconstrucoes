// lib/features/obra/screens/tela_cadastro_obra.dart

import 'package:flutter/material.dart';
import 'package:front_application/theme/colors.dart'; // para AppColors.error
import 'package:provider/provider.dart';

import '../../../shared/components/form_widgets.dart'; // InputCampo, TituloSecao, CardContainer, BotaoPadrao, etc.
import '../controllers/obra_cadastro_controller.dart';
import '../widgets/formulario_obra.dart';

class TelaCadastroObra extends StatelessWidget {
  // Se quiser forçar edição via construtor, passe obraId
  final String? obraId;
  const TelaCadastroObra({Key? key, this.obraId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extrai obraId de argumentos, caso não tenha sido passado no construtor
    final args = ModalRoute.of(context)?.settings.arguments;
    String? idParaEdicao = obraId;
    if (idParaEdicao == null && args is String) {
      idParaEdicao = args;
    }

    return ChangeNotifierProvider<ObraCadastroController>(
      create: (_) => ObraCadastroController(obraId: idParaEdicao),
      child: Consumer<ObraCadastroController>(
        builder: (context, controller, _) {
          // Se em modo edição, garantir que carregue apenas uma vez
          if (controller.obraId != null &&
              controller.sucesso == null &&
              controller.erro == null) {
            final isFirstLoad =
                controller.clienteIdController.text.isEmpty &&
                controller.orcamentoIdController.text.isEmpty &&
                controller.dataInicioController.text.isEmpty;
            if (isFirstLoad) {
              controller.carregarObraParaEdicao();
            }
          }

          return Scaffold(
            appBar: AppBarCustom(
              titulo:
                  controller.obraId == null
                      ? 'Cadastrar Nova Obra'
                      : 'Editar Obra #${controller.obraId}',
            ),
            drawer: const DrawerMenu(),
            backgroundColor: AppColors.background,
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Formulário reutilizável
                  const FormularioObra(),
                  const SizedBox(height: 24),

                  // Botão ou Spinner, dependendo de controller.carregando
                  if (controller.carregando)
                    const Center(child: CircularProgressIndicator())
                  else
                    BotaoPadrao(
                      texto:
                          controller.obraId == null
                              ? 'Salvar Obra'
                              : 'Atualizar Obra',
                      onPressed:
                          () => controller.salvarObra(context, mostrarMensagem),
                    ),

                  const SizedBox(height: 12),

                  // Mensagem de sucesso ou erro (após salvar)
                  if (controller.sucesso != null)
                    Text(
                      controller.sucesso!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  if (controller.erro != null)
                    Text(
                      controller.erro!,
                      style: TextStyle(color: AppColors.error, fontSize: 14),
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

  /// Exibe Snackbar (verde para sucesso, vermelho para erro)
  void mostrarMensagem(
    BuildContext context,
    String texto, {
    bool erro = false,
  }) {
    final snackBar = SnackBar(
      content: Text(texto),
      backgroundColor:
          erro ? AppColors.error : Theme.of(context).colorScheme.secondary,
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
