// lib/features/contrato/controllers/contrato_cadastro_controller.dart

import 'package:flutter/material.dart';
import 'package:front_application/shared/services/contrato_service.dart';

import '../models/contrato.dart';

class ContratoCadastroController extends ChangeNotifier {
  final ContratoService _service = ContratoService();

  /// Campos do formulário
  final TextEditingController orcamentoIdController = TextEditingController();
  DateTime? dataInicio;
  DateTime? dataFim;
  final TextEditingController statusController = TextEditingController();
  final TextEditingController valorTotalController = TextEditingController();

  /// Para edição, armazenamos o ID do contrato (se existir)
  int? contratoIdExistente;

  /// Flag para indicar se estamos carregando dados do contrato
  bool isLoading = false;

  /// Preenche dados de um Contrato existente no formulário
  Future<void> carregarContratoExistente(int orcamentoId) async {
    try {
      isLoading = true;
      notifyListeners();
      final contrato = await _service.buscarContratoPorOrcamento(orcamentoId);
      contratoIdExistente = contrato.id;
      orcamentoIdController.text = contrato.orcamentoId.toString();
      dataInicio = contrato.dataInicio;
      dataFim = contrato.dataFim;
      statusController.text = contrato.status ?? '';
      valorTotalController.text =
          contrato.valorTotal != null ? contrato.valorTotal.toString() : '';
    } catch (_) {
      // Se não existir contrato para esse orçamento, mantemos campos vazios
      contratoIdExistente = null;
      dataInicio = null;
      dataFim = null;
      statusController.clear();
      valorTotalController.clear();
      orcamentoIdController.text = orcamentoId.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Salva (cria ou atualiza) o contrato
  Future<void> salvarContrato(BuildContext context) async {
    final orcId = int.tryParse(orcamentoIdController.text.trim());
    if (orcId == null) {
      _mostrarSnack(context, 'Informe um ID de orçamento válido.');
      return;
    }
    if (dataInicio == null || dataFim == null) {
      _mostrarSnack(context, 'Informe data de início e data de término.');
      return;
    }
    if (statusController.text.trim().isEmpty) {
      _mostrarSnack(context, 'Informe um status.');
      return;
    }
    final valor = double.tryParse(valorTotalController.text.trim());
    if (valor == null) {
      _mostrarSnack(context, 'Informe um valor total válido.');
      return;
    }

    try {
      isLoading = true;
      notifyListeners();

      final dto = Contrato(
        id: contratoIdExistente,
        orcamentoId: orcId,
        dataInicio: dataInicio,
        dataFim: dataFim,
        status: statusController.text.trim(),
        valorTotal: valor,
      );

      if (contratoIdExistente == null) {
        // Cria novo contrato
        await _service.criarContrato(dto);
        _mostrarSnack(context, 'Contrato criado com sucesso.');
      } else {
        // Atualiza contrato existente
        await _service.atualizarContrato(contratoIdExistente!, dto);
        _mostrarSnack(context, 'Contrato atualizado com sucesso.');
      }
    } catch (e) {
      _mostrarSnack(context, 'Erro ao salvar contrato: ${e.toString()}');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _mostrarSnack(BuildContext context, String mensagem) {
    final snackBar = SnackBar(content: Text(mensagem));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
