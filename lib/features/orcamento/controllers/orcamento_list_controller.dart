// lib/features/orcamento/controllers/orcamento_list_controller.dart

import 'package:flutter/material.dart';
import 'package:front_application/features/orcamento/models/orcamento.dart';
import 'package:front_application/shared/services/orcamento_service.dart';

class OrcamentoListController extends ChangeNotifier {
  /// Lista de orçamentos carregados do back-end
  List<Orcamento> orcamentos = [];

  /// Flag para indicar se está carregando orçamentos
  bool carregando = false;

  /// Armazena mensagem de erro, caso ocorra
  String? erro;

  /// Para evitar notifyListeners após dispose()
  bool _isDisposed = false;

  /// Construtor: já dispara a busca inicial de todos os orçamentos
  OrcamentoListController() {
    fetchAllOrcamentos();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  /// Chama notifyListeners somente se o controller não estiver
  /// já descartado (dispose)
  void _safeNotify() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  // ======================================================
  // 1. BUSCAR TODOS OS ORÇAMENTOS
  // ======================================================

  /// Busca todos os orçamentos no back-end e preenche [orcamentos].
  Future<void> fetchAllOrcamentos() async {
    carregando = true;
    erro = null;
    _safeNotify();

    try {
      final lista = await OrcamentoService.fetchAllOrcamentos();
      orcamentos = lista;
    } catch (e) {
      erro = 'Erro ao carregar orçamentos: $e';
      orcamentos = [];
    } finally {
      carregando = false;
      _safeNotify();
    }
  }

  // ======================================================
  // 2. DELETAR UM ORÇAMENTO
  // ======================================================

  /// Exclui o orçamento com [id]. Em caso de sucesso, recarrega a lista.
  ///
  /// Recebe [context] e [mostrarMensagem] para exibir feedback via Snackbar.
  Future<void> deleteOrcamento(
    BuildContext context,
    void Function(BuildContext, String, {bool erro}) mostrarMensagem,
    int id,
  ) async {
    carregando = true;
    erro = null;
    _safeNotify();

    try {
      await OrcamentoService.deleteOrcamento(id);

      if (context.mounted) {
        mostrarMensagem(context, 'Orçamento excluído com sucesso!');
      }

      // Após excluir, recarrega a lista completa
      await fetchAllOrcamentos();
    } catch (e) {
      erro = 'Erro ao excluir orçamento: $e';
      if (context.mounted) {
        mostrarMensagem(context, erro!, erro: true);
      }
    } finally {
      carregando = false;
      _safeNotify();
    }
  }
}
