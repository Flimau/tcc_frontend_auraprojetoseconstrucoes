import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/components/form_widgets.dart';
import '../controllers/contrato_cadastro_controller.dart';

class FormularioContrato extends StatelessWidget {
  const FormularioContrato({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ContratoCadastroController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CardContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TituloSecao('Dados do Contrato'),

              InputCampo(
                label: 'Cliente (ID ou nome)',
                icone: Icons.person,
                controller: controller.clienteController,
              ),

              InputCampo(
                label: 'Obra vinculada (ID ou nome)',
                icone: Icons.location_city,
                controller: controller.obraController,
              ),

              InputCampo(
                label: 'Orçamento aprovado (ID ou nome)',
                icone: Icons.description,
                controller: controller.orcamentoController,
              ),

              InputCampo(
                label: 'Valor Total (R\$)',
                icone: Icons.attach_money,
                controller: controller.valorTotalController,
              ),

              InputCampo(
                label: 'Data de Início',
                icone: Icons.date_range,
                controller: controller.dataInicioController,
              ),

              InputCampo(
                label: 'Data de Término',
                icone: Icons.event,
                controller: controller.dataFimController,
              ),

              DropdownPadrao(
                label: 'Status do Contrato',
                itens: controller.statusDisponiveis,
                valorSelecionado: controller.statusContrato,
                onChanged: (val) {
                  controller.atualizarStatus(val!);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
