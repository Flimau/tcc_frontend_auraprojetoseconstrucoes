import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/components/form_widgets.dart';
import '../controllers/obra_cadastro_controller.dart';

class FormularioObra extends StatelessWidget {
  const FormularioObra({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ObraCadastroController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CardContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TituloSecao('Informações da Obra'),

              InputCampo(
                label: 'Nome da Obra',
                icone: Icons.construction,
                controller: controller.nomeObraController,
              ),

              InputCampo(
                label: 'Endereço da Obra',
                icone: Icons.location_on,
                controller: controller.enderecoController,
              ),

              InputCampo(
                label: 'Cliente (ID ou nome)',
                icone: Icons.person,
                controller: controller.clienteController,
              ),

              InputCampo(
                label: 'Orçamento vinculado (ID ou nome)',
                icone: Icons.description,
                controller: controller.orcamentoController,
              ),

              DropdownPadrao(
                label: 'Status da Obra',
                itens: controller.statusObra,
                valorSelecionado: controller.status,
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
