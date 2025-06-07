// lib/features/obra/screens/tela_cadastro_obra.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/components/form_widgets.dart';
import '../../../theme/theme.dart';
import '../controllers/obra_cadastro_controller.dart';

class TelaCadastroObra extends StatefulWidget {
  final int? obraId; // se nulo → criar nova

  const TelaCadastroObra({super.key, this.obraId});

  @override
  State<TelaCadastroObra> createState() => _TelaCadastroObraState();
}

class _TelaCadastroObraState extends State<TelaCadastroObra> {
  @override
  void initState() {
    super.initState();
    if (widget.obraId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<ObraCadastroController>().carregarObraExistente(
          widget.obraId!,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ObraCadastroController(),
      child: Consumer<ObraCadastroController>(
        builder: (context, controller, _) {
          return Scaffold(
            appBar: AppBarCustom(
              titulo: widget.obraId == null ? 'Nova Obra' : 'Editar Obra',
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
                          InputCampo(
                            label: 'ID do Cliente',
                            icone: Icons.person,
                            controller: controller.clienteIdController,
                            tipoTeclado: TextInputType.number,
                            enabled: controller.obraIdExistente == null,
                          ),
                          const SizedBox(height: 12),
                          InputCampo(
                            label: 'ID do Orçamento',
                            icone: Icons.description,
                            controller: controller.orcamentoIdController,
                            tipoTeclado: TextInputType.number,
                            enabled: controller.obraIdExistente == null,
                          ),
                          const SizedBox(height: 12),
                          InputCampo(
                            label: 'Data de Início',
                            icone: Icons.date_range,
                            controller: controller.dataInicioController,
                            tipoTeclado: TextInputType.datetime,
                          ),
                          const SizedBox(height: 12),
                          InputCampo(
                            label: 'Data de Fim',
                            icone: Icons.event,
                            controller: controller.dataFimController,
                            tipoTeclado: TextInputType.datetime,
                          ),
                          const SizedBox(height: 12),
                          InputCampo(
                            label: 'URL do Contrato',
                            icone: Icons.link,
                            controller: controller.contratoUrlController,
                          ),
                          const SizedBox(height: 12),
                          InputCampo(
                            label: 'ID do Executor (opcional)',
                            icone: Icons.person_outline,
                            controller: controller.executorIdController,
                            tipoTeclado: TextInputType.number,
                          ),
                          const SizedBox(height: 24),
                          BotaoPadrao(
                            texto:
                                widget.obraId == null
                                    ? 'Criar Obra'
                                    : 'Atualizar Obra',
                            onPressed: () => controller.salvarObra(context),
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
