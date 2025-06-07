// lib/features/agenda/controllers/agenda_list_controller.dart

import 'package:flutter/material.dart';
import 'package:front_application/shared/services/agenda_service.dart';

import '../models/agenda_item.dart';

class AgendaListController extends ChangeNotifier {
  final AgendaService _service = AgendaService();
  List<AgendaItem> itens = [];
  bool isLoading = false;

  Future<void> buscarTodos() async {
    isLoading = true;
    notifyListeners();
    try {
      itens = await _service.listarAgenda();
    } catch (_) {
      itens = [];
    }
    isLoading = false;
    notifyListeners();
  }
}
