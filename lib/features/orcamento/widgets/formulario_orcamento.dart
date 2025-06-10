// lib/features/orcamento/widgets/formulario_orcamento.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/components/form_widgets.dart';
import '../../../theme/colors.dart';
import '../../../theme/text_styles.dart';
import '../../usuario/models/usuario.dart';
import '../../visita/models/visita.dart';
import '../controllers/orcamento_cadastro_controller.dart';
import '../models/orcamento.dart';

class FormularioOrcamento extends StatefulWidget {
  const FormularioOrcamento({Key? key}) : super(key: key);

  @override
  State<FormularioOrcamento> createState() => _FormularioOrcamentoState();
}

class _FormularioOrcamentoState extends State<FormularioOrcamento> {
  final nomeItemController = TextEditingController();
  final valorItemController = TextEditingController();
  final quantidadeController = TextEditingController();
  OrcamentoItem? itemEmEdicao;

  @override
  void dispose() {
    nomeItemController.dispose();
    valorItemController.dispose();
    quantidadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<OrcamentoCadastroController>();
    final double totalOrcamento = controller.itens.fold(
      0.0,
      (sum, item) =>
          sum + (item.subtotal ?? (item.quantidade * item.valorUnitario)),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // === Dados Gerais ===
        CardContainer(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TituloSecao('Informações Gerais'),
                const SizedBox(height: 12),

                // Cliente
                if (controller.carregandoClientes)
                  const Center(child: CircularProgressIndicator())
                else if (controller.erroClientes != null)
                  Text(
                    controller.erroClientes!,
                    style: AppTextStyles.body.copyWith(color: AppColors.error),
                  )
                else
                  DropdownPadrao(
                    label: 'Cliente (ID - Nome)',
                    itens:
                        controller.clientes
                            .map((u) => '${u.id} - ${u.nome}')
                            .toList(),
                    valorSelecionado:
                        controller.clienteIdController.text.isNotEmpty
                            ? '${controller.clienteIdController.text} - '
                                '${controller.clientes.firstWhere((u) => u.id.toString() == controller.clienteIdController.text, orElse: () => Usuario(id: controller.clienteIdController.text, nome: '---', documento: '', ativo: false)).nome}'
                            : null,
                    onChanged: (val) {
                      if (val != null) {
                        final partes = val.split(' - ');
                        controller.clienteIdController.text = partes[0];
                        controller.notifyListeners();
                      }
                    },
                  ),

                const SizedBox(height: 16),

                // Visita
                if (controller.carregandoVisitas)
                  const Center(child: CircularProgressIndicator())
                else if (controller.erroVisitas != null)
                  Text(
                    controller.erroVisitas!,
                    style: AppTextStyles.body.copyWith(color: AppColors.error),
                  )
                else
                  DropdownPadrao(
                    label: 'Visita (ID - Data)',
                    itens:
                        controller.visitas
                            .map(
                              (v) =>
                                  '${v.id} - ${v.dataVisita.substring(0, 10)}',
                            )
                            .toList(),
                    valorSelecionado:
                        controller.visitaIdController.text.isNotEmpty
                            ? '${controller.visitaIdController.text} - '
                                '${controller.visitas.firstWhere((v) => v.id.toString() == controller.visitaIdController.text, orElse: () => Visita(id: controller.visitaIdController.text, clienteId: 0, clienteNome: '', endereco: EnderecoDTO(cep: '', logradouro: '', numero: '', complemento: '', bairro: '', cidade: '', siglaEstado: ''), descricao: '', dataVisita: '', fotos: [], videos: [], usadaEmOrcamento: false)).dataVisita.substring(0, 10)}'
                            : null,
                    onChanged: (val) {
                      if (val != null) {
                        final partes = val.split(' - ');
                        controller.visitaIdController.text = partes[0];
                        controller.notifyListeners();
                      }
                    },
                  ),

                const SizedBox(height: 16),

                // Data
                Row(
                  children: [
                    const Icon(Icons.calendar_today, color: AppColors.primary),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () async {
                        final selecionada = await showDatePicker(
                          context: context,
                          initialDate:
                              controller.dataSelecionada ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (selecionada != null) {
                          controller.dataSelecionada = selecionada;
                          controller.notifyListeners();
                        }
                      },
                      child: Text(
                        controller.dataSelecionada != null
                            ? 'Data: ${controller.dataSelecionada!.toLocal().toString().split(" ")[0]}'
                            : 'Selecionar Data',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.text,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Descrição
                InputCampoMultiline(
                  label: 'Descrição',
                  icone: Icons.description,
                  controller: controller.descricaoController,
                ),

                const SizedBox(height: 16),

                // Tipo
                DropdownPadrao(
                  label: 'Tipo de Orçamento',
                  itens: controller.tipos,
                  valorSelecionado: controller.tipoSelecionado,
                  onChanged: (val) {
                    controller.tipoSelecionado = val;
                    controller.subtipoSelecionado = null;
                    controller.notifyListeners();
                  },
                ),

                const SizedBox(height: 16),

                // Subtipo
                if (controller.tipoSelecionado != null)
                  DropdownPadrao(
                    label: 'Subtipo de Orçamento',
                    itens:
                        controller.subtiposPorTipo[controller
                            .tipoSelecionado] ??
                        [],
                    valorSelecionado: controller.subtipoSelecionado,
                    onChanged: (val) {
                      controller.subtipoSelecionado = val;
                      controller.notifyListeners();
                    },
                  ),

                const SizedBox(height: 16),

                // Checkbox Com Material
                Row(
                  children: [
                    Checkbox(
                      value: controller.comMaterial,
                      activeColor: AppColors.primary,
                      onChanged: (val) {
                        controller.comMaterial = val ?? false;
                        controller.notifyListeners();
                      },
                    ),
                    Text(
                      'Com Material?',
                      style: AppTextStyles.body.copyWith(color: AppColors.text),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // === Seção de Itens ===
        if (controller.comMaterial) ...[
          const SizedBox(height: 24),
          CardContainer(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TituloSecao('Itens do Orçamento'),
                  const SizedBox(height: 12),
                  InputCampo(
                    label: 'Nome do Item',
                    icone: Icons.label,
                    controller: nomeItemController,
                  ),
                  const SizedBox(height: 12),
                  InputCampo(
                    label: 'Valor Unitário',
                    icone: Icons.attach_money,
                    controller: valorItemController,
                    tipoTeclado: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  InputCampo(
                    label: 'Quantidade',
                    icone: Icons.format_list_numbered,
                    controller: quantidadeController,
                    tipoTeclado: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: BotaoPadrao(
                      texto:
                          itemEmEdicao == null
                              ? 'Adicionar Item'
                              : 'Atualizar Item',
                      onPressed: () {
                        final nome = nomeItemController.text.trim();
                        final valorText = valorItemController.text
                            .trim()
                            .replaceAll(',', '.');
                        final qtdText = quantidadeController.text.trim();
                        if (nome.isEmpty ||
                            valorText.isEmpty ||
                            qtdText.isEmpty)
                          return;
                        final valor = double.tryParse(valorText);
                        final qtd = int.tryParse(qtdText);
                        if (valor == null || qtd == null) return;

                        if (itemEmEdicao != null) {
                          final novoItem = OrcamentoItem(
                            id: itemEmEdicao!.id,
                            descricao: nome,
                            quantidade: qtd,
                            valorUnitario: valor,
                            subtotal: qtd * valor,
                          );

                          final index = controller.itens.indexOf(itemEmEdicao!);
                          if (index != -1) {
                            controller.itens[index] = novoItem;
                          }

                          itemEmEdicao = null;
                        } else {
                          controller.addItem(
                            descricao: nome,
                            quantidade: qtd,
                            valorUnitario: valor,
                          );
                        }

                        nomeItemController.clear();
                        valorItemController.clear();
                        quantidadeController.clear();
                        controller.notifyListeners();
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (controller.itens.isEmpty)
                    Text(
                      'Nenhum item adicionado ainda.',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.subtitle,
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.itens.length,
                      itemBuilder: (context, index) {
                        final item = controller.itens[index];
                        final subtotal =
                            item.subtotal ??
                            (item.quantidade * item.valorUnitario);
                        return ListTile(
                          tileColor: AppColors.background,
                          title: Text(item.descricao),
                          subtitle: Text(
                            'R\$ ${item.valorUnitario.toStringAsFixed(2)} x ${item.quantidade}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: AppColors.primary,
                                ),
                                onPressed: () {
                                  nomeItemController.text = item.descricao;
                                  valorItemController.text =
                                      item.valorUnitario.toString();
                                  quantidadeController.text =
                                      item.quantidade.toString();
                                  controller.removeItem(item);
                                  setState(() => itemEmEdicao = item);
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: AppColors.error,
                                ),
                                onPressed: () => controller.removeItem(item),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 16),
                  Text(
                    'Total estimado: R\$ ${totalOrcamento.toStringAsFixed(2)}',
                    style: AppTextStyles.headline.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
