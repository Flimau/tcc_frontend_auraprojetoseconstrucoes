import 'package:flutter/material.dart';

import '../../../shared/components/form_widgets.dart';

class TelaAcompanhamentoObra extends StatefulWidget {
  const TelaAcompanhamentoObra({super.key});

  @override
  State<TelaAcompanhamentoObra> createState() => _TelaAcompanhamentoObraState();
}

class _TelaAcompanhamentoObraState extends State<TelaAcompanhamentoObra> {
  final dataController = TextEditingController();
  final etapaController = TextEditingController();
  final tarefasController = TextEditingController();
  final observacoesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCustom(titulo: 'Acompanhamento da Obra'),
      drawer: const DrawerMenu(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TituloSecao('Diário da Obra'),

            InputCampo(
              label: 'Data',
              icone: Icons.calendar_month,
              controller: dataController,
            ),
            InputCampo(
              label: 'Etapa',
              icone: Icons.timeline,
              controller: etapaController,
            ),
            InputCampo(
              label: 'Tarefas do Dia',
              icone: Icons.list,
              controller: tarefasController,
            ),
            InputCampo(
              label: 'Observações',
              icone: Icons.note,
              controller: observacoesController,
            ),

            const SizedBox(height: 24),
            BotaoPadrao(
              texto: 'Registrar Andamento',
              onPressed: () {
                mostrarMensagem(context, 'Registro salvo!');
              },
            ),
          ],
        ),
      ),
    );
  }
}
