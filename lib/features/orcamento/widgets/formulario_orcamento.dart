import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/components/form_widgets.dart';
import '../controllers/orcamento_cadastro_controller.dart';

class FormularioOrcamento extends StatelessWidget {
  const FormularioOrcamento({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<OrcamentoCadastroController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CardContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TituloSecao('Informações Gerais'),

              InputCampo(
                label: 'Descritivo',
                icone: Icons.description,
                controller: controller.descritivoController,
              ),

              InputCampo(
                label: 'Endereço da Obra',
                icone: Icons.location_on,
                controller: controller.enderecoController,
              ),

              DropdownPadrao(
                label: 'Tipo de Orçamento',
                itens: [
                  'PROJETO > ARQUITETÔNICO',
                  'PROJETO > INTERIORES',
                  'PROJETO > REGULARIZAÇÃO',
                  'CONSTRUÇÃO',
                  'REFORMA > BANHEIRO',
                  'REFORMA > COZINHA',
                  'REFORMA > LAVANDERIA',
                  'REFORMA > SALA',
                  'REFORMA > DORMITÓRIO',
                  'REFORMA > COMERCIAL',
                  'DRYWALL > FORRO',
                  'DRYWALL > PAREDE',
                  'DRYWALL > AMBOS',
                  'ACABAMENTO > PISO',
                  'ACABAMENTO > PINTURA',
                  'ACABAMENTO > RODAPÉ',
                  'ACABAMENTO > REVESTIMENTO',
                ],
                valorSelecionado: controller.tipoOrcamentoSelecionado,
                onChanged: (val) {
                  controller.tipoOrcamentoSelecionado = val;
                  controller.notifyListeners();
                },
              ),

              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: controller.comMaterial,
                    onChanged:
                        (val) => controller.toggleComMaterial(val ?? false),
                  ),
                  const Text('Com Material?'),
                ],
              ),
            ],
          ),
        ),

        if (controller.comMaterial) ...[
          const SizedBox(height: 24),
          CardContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TituloSecao('Itens do Orçamento'),

                InputCampo(
                  label: 'Nome do Item',
                  icone: Icons.label,
                  controller: controller.nomeItemController,
                ),
                InputCampo(
                  label: 'Valor Unitário',
                  icone: Icons.attach_money,
                  controller: controller.valorItemController,
                ),
                InputCampo(
                  label: 'Quantidade',
                  icone: Icons.format_list_numbered,
                  controller: controller.quantidadeController,
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: BotaoPadrao(
                    texto: 'Adicionar Item',
                    onPressed: controller.adicionarItem,
                  ),
                ),

                const SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.itensMaterial.length,
                  itemBuilder: (context, index) {
                    final item = controller.itensMaterial[index];
                    return ListTile(
                      title: Text(item['nome']),
                      subtitle: Text(
                        'R\$ ${item['valor']} x ${item['quantidade']}',
                      ),
                      trailing: Text(
                        'R\$ ${(item['valor'] * item['quantidade']).toStringAsFixed(2)}',
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),
                Text(
                  'Total estimado: R\$ ${controller.totalOrcamento.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
