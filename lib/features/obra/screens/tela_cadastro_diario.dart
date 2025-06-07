// lib/features/obra/screens/tela_cadastro_diario.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/components/form_widgets.dart';
import '../controllers/diario_controller.dart';
import '../models/diario_de_obra.dart';

class TelaCadastroDiario extends StatefulWidget {
  final int obraId;
  final int? diarioId; // se nulo → criar novo

  const TelaCadastroDiario({super.key, required this.obraId, this.diarioId});

  @override
  State<TelaCadastroDiario> createState() => _TelaCadastroDiarioState();
}

class _TelaCadastroDiarioState extends State<TelaCadastroDiario> {
  final TextEditingController dataRegistroController = TextEditingController();
  final TextEditingController itensController = TextEditingController();
  final TextEditingController observacoesController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.diarioId != null) {
      _carregarDiarioExistente();
    }
  }

  Future<void> _carregarDiarioExistente() async {
    setState(() => isLoading = true);
    final ctrl = context.read<DiarioController>();
    final lista = await ctrl.fetchDiarios(widget.obraId);
    final d = ctrl.diarios.firstWhere((e) => e.id == widget.diarioId);
    dataRegistroController.text = d.dataRegistro;
    itensController.text = d.itens.join('\n');
    observacoesController.text = d.observacoes ?? '';
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.read<DiarioController>();
    return Scaffold(
      appBar: AppBarCustom(
        titulo: widget.diarioId == null ? 'Novo Diário' : 'Editar Diário',
      ),
      drawer: const DrawerMenu(),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    InputCampo(
                      label: 'Data Registro',
                      icone: Icons.date_range,
                      controller: dataRegistroController,
                      tipoTeclado: TextInputType.datetime,
                    ),
                    const SizedBox(height: 12),
                    InputCampo(
                      label: 'Itens (uma por linha)',
                      icone: Icons.list,
                      controller: itensController,
                      tipoTeclado: TextInputType.multiline,
                      maxLinhas: 4,
                    ),
                    const SizedBox(height: 12),
                    InputCampo(
                      label: 'Observações (opcional)',
                      icone: Icons.note,
                      controller: observacoesController,
                      tipoTeclado: TextInputType.multiline,
                      maxLinhas: 4,
                    ),
                    const SizedBox(height: 24),
                    BotaoPadrao(
                      texto:
                          widget.diarioId == null
                              ? 'Criar Diário'
                              : 'Atualizar Diário',
                      onPressed: () {
                        final dataReg = dataRegistroController.text.trim();
                        final itensTex = itensController.text.trim();
                        if (dataReg.isEmpty || itensTex.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Data e itens são obrigatórios'),
                            ),
                          );
                          return;
                        }
                        final itensList =
                            itensTex.split('\n').map((e) => e.trim()).toList();
                        final diario = DiarioDeObra(
                          id:
                              widget.diarioId ??
                              0, // no POST, back gera novo id
                          obraId: widget.obraId,
                          dataRegistro: dataReg,
                          itens: itensList,
                          observacoes:
                              observacoesController.text.trim().isEmpty
                                  ? null
                                  : observacoesController.text.trim(),
                        );
                        if (widget.diarioId == null) {
                          ctrl.criarDiario(widget.obraId, diario, context);
                        } else {
                          ctrl.updateDiario(
                            widget.obraId,
                            widget.diarioId!,
                            diario,
                            context,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
    );
  }
}
