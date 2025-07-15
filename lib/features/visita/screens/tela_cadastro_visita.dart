import 'package:flutter/material.dart';
import 'package:front_application/features/usuario/models/usuario.dart';
import 'package:front_application/theme/colors.dart';
import 'package:front_application/theme/text_styles.dart';
import 'package:provider/provider.dart';

import '../../../shared/components/form_widgets.dart'; 
import '../controllers/visita_cadastro_controller.dart';
import '../widgets/formulario_visita.dart';

class TelaCadastroVisita extends StatefulWidget {
  const TelaCadastroVisita({Key? key}) : super(key: key);

  @override
  State<TelaCadastroVisita> createState() => _TelaCadastroVisitaState();
}

class _TelaCadastroVisitaState extends State<TelaCadastroVisita> {
  late VisitaCadastroController _controller;
  bool _isInit = false;

  @override
  void initState() {
    super.initState();
    _controller = VisitaCadastroController(visitaId: null);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is String) {
        _controller.dispose();
        _controller = VisitaCadastroController(visitaId: args);
      }
      _isInit = true;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<VisitaCadastroController>.value(
      value: _controller,
      child: Consumer<VisitaCadastroController>(
        builder: (ctx, ctrl, _) {
          ctrl.setContextParaBusca(ctx, _mostrarMensagem);
          if (ctrl.visitaId != null &&
              ctrl.sucesso == null &&
              ctrl.erro == null) {
            final firstLoad =
                ctrl.clienteIdController.text.isEmpty &&
                ctrl.dataVisitaController.text.isEmpty;
            if (firstLoad) {
              ctrl.carregarVisitaParaEdicao();
            }
          }
          String textoClienteInformativo = '';
          if (ctrl.visitaId != null &&
              ctrl.clienteIdController.text.isNotEmpty) {
            final encontrado = ctrl.clientes.firstWhere(
              (u) => u.id == ctrl.clienteIdController.text,
              orElse:
                  () => Usuario(
                    id: ctrl.clienteIdController.text,
                    nome: '---',
                    documento: '',
                    ativo: false,
                  ),
            );
            textoClienteInformativo = '${encontrado.id} - ${encontrado.nome}';
          }

          return Scaffold(
            appBar: AppBarCustom(
              titulo:
                  ctrl.visitaId == null
                      ? 'Nova Visita'
                      : 'Editar Visita #${ctrl.visitaId}',
            ),
            drawer: const DrawerMenu(),
            backgroundColor: AppColors.background,
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: BotaoVoltar(),
                  ),

                  const SizedBox(height: 16),

                  if (ctrl.carregandoClientes)
                    const Center(child: CircularProgressIndicator())
                  else if (ctrl.erroClientes != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        ctrl.erroClientes!,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  else if (ctrl.visitaId == null)
                    
                    DropdownPadrao(
                      label: 'Cliente (ID - Nome)',
                      itens:
                          ctrl.clientes
                              .map((u) => '${u.id} - ${u.nome}')
                              .toList(),
                      valorSelecionado:
                          ctrl.clienteIdController.text.isNotEmpty
                              ? '${ctrl.clienteIdController.text} - '
                                  '${ctrl.clientes.firstWhere((u) => u.id == ctrl.clienteIdController.text, orElse: () => Usuario(id: '', nome: '', documento: '', ativo: false)).nome}'
                              : null,
                      onChanged: (val) {
                        if (val != null) {
                          final partes = val.split(' - ');
                          ctrl.clienteIdController.text = partes[0];
                          ctrl.notifyListeners();
                        }
                      },
                    )
                  else
                    
                    CardContainer(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.person, color: AppColors.primary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              textoClienteInformativo,
                              style: AppTextStyles.body.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 16),

                  
                  const FormularioVisita(),

                  const SizedBox(height: 24),

                  
                  if (ctrl.carregando)
                    const Center(child: CircularProgressIndicator())
                  else
                    BotaoPadrao(
                      texto:
                          ctrl.visitaId == null
                              ? 'Salvar Visita'
                              : 'Atualizar Visita',
                      onPressed: () {
                        
                        if (ctrl.visitaId == null &&
                            ctrl.clienteIdController.text.trim().isEmpty) {
                          _mostrarMensagem(
                            context,
                            'Selecione um cliente antes de salvar.',
                            erro: true,
                          );
                          return;
                        }
                        
                        ctrl.salvarVisita(context, _mostrarMensagem);
                      },
                    ),

                  const SizedBox(height: 12),
                  if (ctrl.sucesso != null)
                    Text(
                      ctrl.sucesso!,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.success,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  if (ctrl.erro != null)
                    Text(
                      ctrl.erro!,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _mostrarMensagem(
    BuildContext context,
    String texto, {
    bool erro = false,
  }) {
    final snackBar = SnackBar(
      content: Text(
        texto,
        style: AppTextStyles.body.copyWith(color: AppColors.white),
      ),
      backgroundColor: erro ? AppColors.error : AppColors.success,
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
