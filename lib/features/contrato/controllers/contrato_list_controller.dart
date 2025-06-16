import 'package:flutter/material.dart';
import 'package:front_application/features/contrato/models/contrato_resumo.dart';
import 'package:front_application/shared/services/contrato_service.dart';

class ContratoListController extends ChangeNotifier {
  final ContratoService _service = ContratoService();

  List<ContratoResumo> resultados = [];

  bool isLoading = false;

  Future<void> buscarTodosContratos() async {
    try {
      isLoading = true;
      notifyListeners();

      resultados = await _service.listarContratosResumo();
    } catch (_) {
      resultados = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
