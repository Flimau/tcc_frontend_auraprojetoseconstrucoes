import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/components/form_widgets.dart';
import '../controllers/visita_cadastro_controller.dart';

class FormularioVisita extends StatelessWidget {
  const FormularioVisita({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<VisitaCadastroController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CardContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TituloSecao('Informações da Visita'),

              InputCampo(
                label: 'Data da Visita',
                icone: Icons.calendar_today,
                controller: controller.dataVisitaController,
              ),

              InputCampo(
                label: 'Endereço',
                icone: Icons.location_on,
                controller: controller.enderecoController,
              ),

              InputCampo(
                label: 'Descrição Técnica',
                icone: Icons.description,
                controller: controller.descricaoController,
              ),

              InputCampo(
                label: 'Metragem (m²)',
                icone: Icons.square_foot,
                controller: controller.metragemController,
              ),

              InputCampo(
                label: 'Necessidades do Cliente',
                icone: Icons.warning_amber,
                controller: controller.necessidadesController,
              ),

              InputCampo(
                label: 'Observações',
                icone: Icons.notes,
                controller: controller.observacoesController,
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        CardContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TituloSecao('Mídias da Visita'),
              ...controller.midias.map((m) => Text('🖼️ $m')).toList(),
              const SizedBox(height: 8),
              BotaoPadrao(
                texto: 'Adicionar Mídia (simulado)',
                onPressed: () {
                  controller.adicionarMidia('foto_${controller.midias.length + 1}.jpg');
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
