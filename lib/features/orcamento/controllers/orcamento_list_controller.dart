import 'package:flutter/material.dart';
import 'package:front_application/features/orcamento/models/orcamento.dart';
import 'package:front_application/shared/services/orcamento_service.dart';

class OrcamentoListController extends ChangeNotifier {
  List<Orcamento> orcamentos = [];
  bool carregando = false;
  String? erro;
  bool _isDisposed = false;

  OrcamentoListController() {
    fetchAllOrcamentos();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void _safeNotify() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

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
