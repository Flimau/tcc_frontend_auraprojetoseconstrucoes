import 'package:flutter/material.dart';
import 'package:front_application/shared/services/kanban_service.dart';

import '../models/kanban_card.dart';

class KanbanController extends ChangeNotifier {
  final KanbanService _service = KanbanService();
  List<KanbanCard> todo = [];
  List<KanbanCard> inProgress = [];
  List<KanbanCard> done = [];
  bool isLoading = false;

  Future<void> carregarCards() async {
    isLoading = true;
    notifyListeners();
    try {
      final todos = await _service.listarCards();
      todo = todos.where((c) => c.status == 'TODO').toList();
      inProgress = todos.where((c) => c.status == 'IN_PROGRESS').toList();
      done = todos.where((c) => c.status == 'DONE').toList();
    } catch (_) {
      todo = [];
      inProgress = [];
      done = [];
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> moverCard(KanbanCard card, String novoStatus) async {
    final atualizado = card.copyWith(status: novoStatus);
    try {
      await _service.atualizarCard(card.id!, atualizado);
      await carregarCards();
    } catch (_) {
      // falha, não altera
    }
  }

  Future<void> criarCard(KanbanCard card) async {
    try {
      await _service.criarCard(card);
      await carregarCards();
    } catch (_) {}
  }

  Future<void> deletarCard(int id) async {
    try {
      await _service.deletarCard(id);
      await carregarCards();
    } catch (_) {}
  }
}
