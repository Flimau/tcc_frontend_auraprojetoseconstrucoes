import 'package:flutter/material.dart';
import 'package:front_application/features/contrato/models/contrato_dto.dart';
import 'package:front_application/features/orcamento/models/orcamento.dart';
import 'package:front_application/shared/services/contrato_service.dart';
import 'package:front_application/shared/services/orcamento_service.dart';

class ContratoCadastroController extends ChangeNotifier {
  final ContratoService _contratoService = ContratoService();

  List<Orcamento> orcamentos = [];

  Orcamento? orcamentoSelecionado;
  DateTime? dataInicio;
  DateTime? dataFim;
  int? contratoIdExistente;

  bool isLoading = false;

  Future<void> carregarOrcamentos() async {
    try {
      isLoading = true;
      notifyListeners();
      orcamentos = await OrcamentoService.fetchAllOrcamentos();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> carregarContratoPorOrcamento(int orcamentoId) async {
    try {
      isLoading = true;
      notifyListeners();

      final contrato = await _contratoService.buscarContratoPorOrcamento(
        orcamentoId,
      );
      contratoIdExistente = contrato.id;
      dataInicio = contrato.dataInicio;
      dataFim = contrato.dataFim;

      orcamentoSelecionado = orcamentos.firstWhere(
        (orc) => orc.id == contrato.orcamentoId,
      );
    } catch (_) {
      contratoIdExistente = null;
      dataInicio = null;
      dataFim = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> salvarContrato(BuildContext context) async {
    if (orcamentoSelecionado == null) {
      _mostrarSnack(context, 'Selecione o orçamento');
      return;
    }
    if (dataInicio == null || dataFim == null) {
      _mostrarSnack(context, 'Informe data de início e término');
      return;
    }

    final dto = ContratoDTO(
      id: contratoIdExistente,
      orcamentoId: orcamentoSelecionado!.id,
      dataInicio: dataInicio,
      dataFim: dataFim,
    );

    try {
      isLoading = true;
      notifyListeners();

      if (contratoIdExistente == null) {
        await _contratoService.criarContrato(dto);
        _mostrarSnack(context, 'Contrato criado com sucesso');
      } else {
        await _contratoService.atualizarContrato(contratoIdExistente!, dto);
        _mostrarSnack(context, 'Contrato atualizado com sucesso');
      }
    } catch (e) {
      _mostrarSnack(context, 'Erro: ${e.toString()}');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _mostrarSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
