import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/components/form_widgets.dart';
import '../controllers/usuario_cadastro_controller.dart';
import '../widgets/formulario_usuario.dart';

class TelaCadastroUsuario extends StatelessWidget {
  final String? idUsuario;
  const TelaCadastroUsuario({super.key, this.idUsuario});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UsuarioCadastroController(),
      child: Consumer<UsuarioCadastroController>(
        builder: (context, controller, _) {
          if (idUsuario != null && !controller.usuarioCarregado) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              controller.carregarPessoaPorId(idUsuario!);
            });
          }

          return Scaffold(
            appBar: const AppBarCustom(titulo: 'Cadastro de Usuário'),
            drawer: const DrawerMenu(),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 16, top: 16),
                  child: BotaoVoltar(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const FormularioUsuario(),
                        const SizedBox(height: 24),
                        if (idUsuario == null)
                          BotaoPadrao(
                            texto: 'Cadastrar',
                            onPressed:
                                () => controller.cadastrarUsuario(
                                  context,
                                  mostrarMensagem,
                                ),
                          ),
                        if (idUsuario != null)
                          BotaoPadrao(
                            texto: 'Atualizar Cadastro',
                            onPressed:
                                () => controller.atualizarUsuario(context),
                          ),
                        const SizedBox(height: 16),
                        if (controller.usuarioCarregado &&
                            controller.ativo != null)
                          BotaoSwitch(
                            value: controller.ativo!,
                            ativoLabel: 'Desativar usuário',
                            inativoLabel: 'Ativar usuário',
                            onChanged:
                                (value) => controller.alterarStatusUsuario(
                                  value,
                                  context,
                                ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
