// lib/features/obra/widgets/formulario_obra.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/components/form_widgets.dart';   // InputCampo, InputCampoMultiline
import '../../../shared/components/dropdown_padrao.dart'; // DropdownPadrao
import '../../../shared/components/titulo_secao.dart';
import '../../../shared/components/card_container.dart';

import '../controllers/obra_cadastro_controller.dart';

class FormularioObra extends StatelessWidget {
  const FormularioObra({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ObraCadastroController>();

    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TituloSecao('Informações da Obra'),
          const SizedBox(height: 16),

          // Cliente ID
          InputCampo(
            label: 'Cliente (ID)',
            icone: Icons.person,
            controller: controller.clienteIdController,
            mascaras: [],
          ),
          const SizedBox(height: 16),

          // Orçamento ID
          InputCampo(
            label: 'Orçamento (ID)',
            icone: Icons.request_quote,
            controller: controller.orcamentoIdController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),

          // Executor ID (opcional)
          InputCampo(
            label: 'Executor (ID, opcional)',
            icone: Icons.build,
            controller: controller.executorIdController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),

          // Data Início (DD/MM/AAAA)
          InputCampo(
            label: 'Data Início (DD/MM/AAAA)',
            icone: Icons.calendar_today,
            controller: controller.dataInicioController,
            keyboardType: TextInputType.datetime,
          ),
          const SizedBox(height: 16),

          // Data Fim (DD/MM/AAAA)
          InputCampo(
            label: 'Data Fim (DD/MM/AAAA)',
            icone: Icons.calendar_today,
            controller: controller.dataFimController,
            keyboardType: TextInputType.datetime,
          ),
          const SizedBox(height: 16),

          // Contrato URL (opcional)
          InputCampo(
            label: 'Contrato URL (opcional)',
            icone: Icons.link,
            controller: controller.contratoUrlController,
            keyboardType: TextInputType.url,
          ),
          const SizedBox(height: 16),

          // Status da Obra
          const Text(
            'Status da Obra',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          DropdownPadrao(
            label: 'Selecione o Status',
            itens: controller.statusObra,
            valorSelecionado: controller.status,
            onChanged: (val) {
              if (val != null) controller.atualizarStatus(val);
            },
          ),
        ],
      ),
    );
  }
}
