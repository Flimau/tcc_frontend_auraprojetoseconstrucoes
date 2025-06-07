import 'package:flutter/material.dart';

import '../../../shared/services/obra_service.dart';
import '../models/obra.dart';

class ObraListController extends ChangeNotifier {
  final ObraService _service = ObraService();

  List<Obra> obras = [];
  bool isLoading = false;

  /// Busca todas as obras disponíveis
  Future<void> buscarTodas() async {
    isLoading = true;
    notifyListeners();
    try {
      obras = await _service.fetchAllObras();
    } catch (_) {
      obras = [];
    }
    isLoading = false;
    notifyListeners();
  }

  /// Exclui uma obra por ID
  Future<void> excluirObra(int id, BuildContext context) async {
    try {
      await _service.deleteObra(id);
      obras.removeWhere((o) => o.id == id);
      notifyListeners();
      _mostrarMensagem(context, 'Obra excluída com sucesso.');
    } catch (e) {
      _mostrarMensagem(
        context,
        'Erro ao excluir obra: ${e.toString()}',
        erro: true,
      );
    }
  }

  /// Exibe snackbar com mensagem de feedback
  void _mostrarMensagem(
    BuildContext context,
    String texto, {
    bool erro = false,
  }) {
    final snackBar = SnackBar(
      content: Text(texto),
      backgroundColor: erro ? Colors.red : Colors.green,
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
