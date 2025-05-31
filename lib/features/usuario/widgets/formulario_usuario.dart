import 'package:flutter/material.dart';
import 'package:front_application/theme/theme.dart';
import 'package:provider/provider.dart';

import '../../../shared/components/form_widgets.dart';
import '../../../shared/utils/formatters.dart';
import '../controllers/usuario_cadastro_controller.dart';

class FormularioUsuario extends StatelessWidget {
  const FormularioUsuario({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<UsuarioCadastroController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.cepFocus.addListener(() {
        if (!controller.cepFocus.hasFocus) {
          final cep = controller.cepController.text.replaceAll(
            RegExp(r'\D'),
            '',
          );
          if (cep.length == 8) {
            controller.buscarEnderecoPorCep(
              controller.cepController.text,
              context,
              controller.mostrarMensagemInterna ??
                  (ctx, msg, {erro = false}) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(msg)));
                  },
            );
          }
        }
      });
    });

    final tipoPessoaMap = {'1': 'Física', '2': 'Jurídica'};

    return Column(
      children: [
        CardContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const TituloSecao('Dados Pessoais'),
                  if (controller.usuarioCarregado && controller.ativo != null)
                    Row(
                      children: [
                        Text(
                          controller.ativo! ? 'Desativar' : 'Ativar',
                          style: TextStyle(
                            color:
                                controller.ativo!
                                    ? AppColors.accent
                                    : AppColors.subtitle,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Switch(
                          value: controller.ativo!,
                          activeColor: AppColors.accent,
                          inactiveThumbColor: AppColors.subtitle,
                          inactiveTrackColor: AppColors.subtitle.withOpacity(
                            0.3,
                          ),
                          onChanged:
                              (value) => controller.alterarStatusUsuario(
                                value,
                                context,
                              ),
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: InputCampo(
                      label: 'Nome completo',
                      icone: Icons.person,
                      controller: controller.nomeController,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownPadrao(
                      label: 'Sexo',
                      itens: ['', 'MASCULINO', 'FEMININO', 'OUTRO'],
                      valorSelecionado: controller.sexoSelecionado,
                      onChanged: (val) {
                        controller.sexoSelecionado = val;
                        controller.atualizar();
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownPadrao(
                      label: 'Tipo de Usuário',
                      itens: ['', 'ADMINISTRADOR', 'CLIENTE', 'EXECUTOR'],
                      valorSelecionado: controller.tipoUsuarioSelecionado,
                      onChanged: (val) {
                        controller.tipoUsuarioSelecionado = val;
                        controller.atualizar();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              InputCampo(
                label: 'E-mail',
                icone: Icons.email,
                controller: controller.emailController,
              ),
              InputCampo(
                label: 'Telefone',
                icone: Icons.phone,
                controller: controller.telefoneController,
                mascaras: [telefoneMask],
              ),
              DropdownPadrao(
                label: 'Tipo de Pessoa',
                itens: tipoPessoaMap.values.toList(),
                valorSelecionado:
                    tipoPessoaMap[controller.tipoPessoaSelecionado],
                onChanged: (val) {
                  controller.tipoPessoaSelecionado =
                      tipoPessoaMap.entries
                          .firstWhere((element) => element.value == val)
                          .key;
                  controller.atualizar();
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  if (controller.tipoPessoaSelecionado == '1')
                    Expanded(
                      child: InputCampo(
                        label: 'CPF',
                        icone: Icons.credit_card,
                        controller: controller.cpfController,
                        mascaras: [cpfMask],
                      ),
                    ),
                  if (controller.tipoPessoaSelecionado == '2')
                    Expanded(
                      child: InputCampo(
                        label: 'CNPJ',
                        icone: Icons.business,
                        controller: controller.cnpjController,
                        mascaras: [cnpjMask],
                      ),
                    ),
                ],
              ),
              InputCampo(
                label: 'Data de nascimento',
                icone: Icons.cake,
                controller: controller.nascimentoController,
                mascaras: [dataMask],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        CardContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TituloSecao('Endereço'),
              InputCampo(
                label: 'CEP',
                icone: Icons.map,
                controller: controller.cepController,
                focusNode: controller.cepFocus,
                mascaras: [cepMask],
              ),
              const SizedBox(height: 8),
              InputCampo(
                label: 'Rua',
                icone: Icons.location_on,
                controller: controller.ruaController,
              ),
              InputCampo(
                label: 'Número',
                icone: Icons.confirmation_number,
                controller: controller.numeroController,
              ),
              InputCampo(
                label: 'Complemento',
                icone: Icons.home,
                controller: controller.complementoController,
              ),
              InputCampo(
                label: 'Bairro',
                icone: Icons.map,
                controller: controller.bairroController,
              ),
              InputCampo(
                label: 'Cidade',
                icone: Icons.location_city,
                controller: controller.cidadeController,
              ),
              InputCampo(
                label: 'Estado',
                icone: Icons.flag,
                controller: controller.estadoController,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
