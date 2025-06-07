// lib/features/contrato/widgets/formulario_contrato.dart

import 'package:flutter/material.dart';
import 'package:front_application/shared/components/form_widgets.dart';
import 'package:provider/provider.dart';

import '../controllers/contrato_cadastro_controller.dart';

class FormularioContrato extends StatelessWidget {
  const FormularioContrato({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ContratoCadastroController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputCampo(
          label: 'ID do Orçamento',
          icone: Icons.description,
          controller: controller.orcamentoIdController,
          tipoTeclado: TextInputType.number,
          enabled: controller.contratoIdExistente == null,
        ),

        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  final hoje = DateTime.now();
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: controller.dataInicio ?? hoje,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    controller.dataInicio = picked;
                    controller.notifyListeners();
                  }
                },
                child: AbsorbPointer(
                  child: InputCampo(
                    label: 'Data de Início',
                    icone: Icons.date_range,
                    controller: TextEditingController(
                      text:
                          controller.dataInicio == null
                              ? ''
                              : controller.dataInicio!
                                  .toLocal()
                                  .toString()
                                  .split(' ')[0],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  final hoje = DateTime.now();
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: controller.dataFim ?? hoje,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    controller.dataFim = picked;
                    controller.notifyListeners();
                  }
                },
                child: AbsorbPointer(
                  child: InputCampo(
                    label: 'Data de Término',
                    icone: Icons.event,
                    controller: TextEditingController(
                      text:
                          controller.dataFim == null
                              ? ''
                              : controller.dataFim!.toLocal().toString().split(
                                ' ',
                              )[0],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),
        InputCampo(
          label: 'Status do Contrato',
          icone: Icons.info,
          controller: controller.statusController,
        ),

        const SizedBox(height: 12),
        InputCampo(
          label: 'Valor Total (R\$)',
          icone: Icons.attach_money,
          controller: controller.valorTotalController,
          tipoTeclado: TextInputType.numberWithOptions(decimal: true),
        ),
      ],
    );
  }
}
