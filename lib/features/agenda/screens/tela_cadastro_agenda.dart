// lib/features/agenda/screens/tela_cadastro_agenda.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/components/form_widgets.dart'; // AppBarCustom, BotaoPadrao, InputCampo
import '../../../theme/theme.dart'; // AppColors, AppTextStyles
import '../controllers/agenda_cadastro_controller.dart'; // AgendaCadastroController

class TelaCadastroAgenda extends StatefulWidget {
  final int? itemId;

  const TelaCadastroAgenda({super.key, this.itemId});

  @override
  State<TelaCadastroAgenda> createState() => _TelaCadastroAgendaState();
}

class _TelaCadastroAgendaState extends State<TelaCadastroAgenda> {
  @override
  void initState() {
    super.initState();
    if (widget.itemId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<AgendaCadastroController>().carregarParaEdicao(
          widget.itemId!,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AgendaCadastroController(),
      child: Consumer<AgendaCadastroController>(
        builder: (context, controller, _) {
          return Scaffold(
            appBar: AppBarCustom(
              titulo: widget.itemId == null ? 'Novo Item' : 'Editar Item',
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
                            label: 'Título',
                            icone: Icons.title,
                            controller: controller.tituloController,
                          ),
                          const SizedBox(height: 12),
                          InputCampo(
                            label: 'Descrição',
                            icone: Icons.description,
                            controller: controller.descricaoController,
                          ),
                          const SizedBox(height: 12),
                          GestureDetector(
                            onTap: () async {
                              final hoje = DateTime.now();
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: controller.data ?? hoje,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null) {
                                controller.data = picked;
                                controller.notifyListeners();
                              }
                            },
                            child: AbsorbPointer(
                              child: InputCampo(
                                label: 'Data',
                                icone: Icons.date_range,
                                controller: TextEditingController(
                                  text:
                                      controller.data == null
                                          ? ''
                                          : controller.data!
                                              .toLocal()
                                              .toString()
                                              .split(' ')[0],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          InputCampo(
                            label: 'Horário (HH:MM)',
                            icone: Icons.access_time,
                            controller: controller.horarioController,
                            tipoTeclado: TextInputType.datetime,
                          ),
                          const SizedBox(height: 24),
                          BotaoPadrao(
                            texto:
                                widget.itemId == null ? 'Salvar' : 'Atualizar',
                            onPressed:
                                () => controller
                                    .salvar(context)
                                    .then((_) => Navigator.of(context).pop()),
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
