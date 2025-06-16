// lib/features/contrato/widgets/formulario_contrato.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/components/form_widgets.dart';
import '../../orcamento/models/orcamento.dart';
import '../controllers/contrato_cadastro_controller.dart';

class FormularioContrato extends StatelessWidget {
  const FormularioContrato({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ContratoCadastroController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButton<Orcamento>(
          isExpanded: true,
          hint: const Text("Selecione o Orçamento"),
          value: controller.orcamentoSelecionado,
          items:
              controller.orcamentos.map((orc) {
                return DropdownMenuItem<Orcamento>(
                  value: orc,
                  child: Text('${orc.id} - ${orc.clienteNome}'),
                );
              }).toList(),
          onChanged: (orcamento) {
            controller.orcamentoSelecionado = orcamento;
            controller.notifyListeners();
          },
        ),
        const SizedBox(height: 12),

        // Datas de início e fim
        Row(
          children: [
            Expanded(
              child: _buildDateField(
                context,
                "Data de Início",
                controller.dataInicio,
                (picked) {
                  controller.dataInicio = picked;
                  controller.notifyListeners();
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDateField(
                context,
                "Data de Término",
                controller.dataFim,
                (picked) {
                  controller.dataFim = picked;
                  controller.notifyListeners();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateField(
    BuildContext context,
    String label,
    DateTime? date,
    Function(DateTime) onPicked,
  ) {
    return GestureDetector(
      onTap: () async {
        final hoje = DateTime.now();
        final picked = await showDatePicker(
          context: context,
          initialDate: date ?? hoje,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) onPicked(picked);
      },
      child: AbsorbPointer(
        child: InputCampo(
          label: label,
          icone: Icons.date_range,
          controller: TextEditingController(
            text: date == null ? '' : date.toLocal().toString().split(' ')[0],
          ),
        ),
      ),
    );
  }
}
