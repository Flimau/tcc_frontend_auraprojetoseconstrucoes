// lib/features/orcamento/widgets/formulario_orcamento.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/components/form_widgets.dart'; // CardContainer, TituloSecao, InputCampo, DropdownPadrao, BotaoPadrao
import '../../../theme/colors.dart';
import '../../../theme/text_styles.dart';
import '../../usuario/models/usuario.dart';
import '../../visita/models/visita.dart';
import '../controllers/orcamento_cadastro_controller.dart';

class FormularioOrcamento extends StatefulWidget {
  const FormularioOrcamento({Key? key}) : super(key: key);

  @override
  State<FormularioOrcamento> createState() => _FormularioOrcamentoState();
}

class _FormularioOrcamentoState extends State<FormularioOrcamento> {
  // Controllers para os campos de item
  final nomeItemController = TextEditingController();
  final valorItemController = TextEditingController();
  final quantidadeController = TextEditingController();

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

    // Calcula o total de todos os itens adicionados
    final double totalOrcamento = controller.itens.fold(
      0.0,
      (sum, item) =>
          sum + (item.subtotal ?? (item.quantidade * item.valorUnitario)),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // === Seção de Informações Gerais ===
        CardContainer(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TituloSecao('Informações Gerais'),

                const SizedBox(height: 12),

                // Dropdown de Cliente
                if (controller.carregandoClientes)
                  const Center(child: CircularProgressIndicator())
                else if (controller.erroClientes != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      controller.erroClientes!,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
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

                // Dropdown de Visita (opcional)
                if (controller.carregandoVisitas)
                  const Center(child: CircularProgressIndicator())
                else if (controller.erroVisitas != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      controller.erroVisitas!,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
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

                // Campo Descrição
                InputCampo(
                  label: 'Descrição',
                  icone: Icons.description,
                  controller: controller.descricaoController,
                ),

                const SizedBox(height: 16),

                // Dropdown de Tipo de Orçamento
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

                // Dropdown de Subtipo (aparece se tipoSelecionado != null)
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

                // Checkbox “Com Material?”
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

        // === Seção de Itens do Orçamento (se comMaterial for true) ===
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

                  // Campo Nome do Item
                  InputCampo(
                    label: 'Nome do Item',
                    icone: Icons.label,
                    controller: nomeItemController,
                  ),

                  const SizedBox(height: 12),

                  // Campo Valor Unitário
                  InputCampo(
                    label: 'Valor Unitário',
                    icone: Icons.attach_money,
                    controller: valorItemController,
                    tipoTeclado: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Campo Quantidade
                  InputCampo(
                    label: 'Quantidade',
                    icone: Icons.format_list_numbered,
                    controller: quantidadeController,
                    tipoTeclado: TextInputType.number,
                  ),

                  const SizedBox(height: 12),

                  // Botão Adicionar Item
                  Align(
                    alignment: Alignment.centerRight,
                    child: BotaoPadrao(
                      texto: 'Adicionar Item',
                      onPressed: () {
                        final nome = nomeItemController.text.trim();
                        final valorText = valorItemController.text
                            .trim()
                            .replaceAll(',', '.');
                        final qtdText = quantidadeController.text.trim();

                        if (nome.isEmpty ||
                            valorText.isEmpty ||
                            qtdText.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'Preencha nome, valor e quantidade do item.',
                              ),
                              backgroundColor: AppColors.error,
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                          );
                          return;
                        }

                        final valor = double.tryParse(valorText);
                        final qtd = int.tryParse(qtdText);
                        if (valor == null || qtd == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'Valor ou quantidade inválidos.',
                              ),
                              backgroundColor: AppColors.error,
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                          );
                          return;
                        }

                        // Adiciona o item no controller
                        controller.addItem(
                          descricao: nome,
                          quantidade: qtd,
                          valorUnitario: valor,
                        );

                        nomeItemController.clear();
                        valorItemController.clear();
                        quantidadeController.clear();
                        controller.notifyListeners();
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Lista de Itens Adicionados
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
                          title: Text(
                            item.descricao,
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.text,
                            ),
                          ),
                          subtitle: Text(
                            'R\$ ${item.valorUnitario.toStringAsFixed(2)} x ${item.quantidade}',
                            style: AppTextStyles.subtitle.copyWith(
                              color: AppColors.subtitle,
                            ),
                          ),
                          trailing: Text(
                            'R\$ ${subtotal.toStringAsFixed(2)}',
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.accent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 16),

                  // Total Estimado
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
