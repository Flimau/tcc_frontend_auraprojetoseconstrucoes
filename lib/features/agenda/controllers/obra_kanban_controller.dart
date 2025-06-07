import 'package:flutter/material.dart';

import '../../../shared/services/obra_service.dart';
import '../../obra/models/obra.dart';

class ObraKanbanController extends ChangeNotifier {
  final ObraService _service = ObraService();

  List<Obra> pendentes = [];
  List<Obra> emAndamento = [];
  List<Obra> concluidas = [];
  bool isLoading = false;

  Future<void> carregarObras() async {
    isLoading = true;
    notifyListeners();
    try {
      final todas = await _service.fetchAllObras();
      pendentes = todas.where((o) => o.status == 'PENDENTE').toList();
      emAndamento = todas.where((o) => o.status == 'EM_ANDAMENTO').toList();
      concluidas = todas.where((o) => o.status == 'CONCLUIDA').toList();
    } catch (_) {
      pendentes = [];
      emAndamento = [];
      concluidas = [];
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> moverStatus(Obra obra, String novoStatus) async {
    final atualizado = obra.copyWith(status: novoStatus);
    try {
      await _service.changeStatus(obra.id!, novoStatus);
      await carregarObras();
    } catch (_) {
      // Em caso de falha, você pode exibir uma Snackbar se quiser
    }
  }
}
