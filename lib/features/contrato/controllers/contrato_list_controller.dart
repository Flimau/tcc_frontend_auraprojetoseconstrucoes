// lib/features/contrato/controllers/contrato_list_controller.dart

import 'package:flutter/material.dart';
import 'package:front_application/shared/services/contrato_service.dart';

import '../models/contrato.dart';

class ContratoListController extends ChangeNotifier {
  final List<String> chaves = ['ID do orçamento', 'Nome do cliente'];
  String chaveSelecionada = 'ID do orçamento';
  final TextEditingController valorBuscaController = TextEditingController();
  List<Contrato> resultados = [];
  final ContratoService _service = ContratoService();

  void atualizarChave(String novaChave) {
    chaveSelecionada = novaChave;
    valorBuscaController.clear();
    resultados = [];
    notifyListeners();
  }

  Future<void> buscar(BuildContext context) async {
    final valor = valorBuscaController.text.trim();
    if (valor.isEmpty) return;

    try {
      List<Contrato> lista = [];
      if (chaveSelecionada == 'ID do orçamento') {
        final id = int.tryParse(valor);
        if (id != null) {
          try {
            final contr = await _service.buscarContratoPorOrcamento(id);
            lista = [contr];
          } catch (_) {
            lista = [];
          }
        }
      } else {
        final todos = await _service.listarContratosResumo();
        lista =
            todos
                .where(
                  (c) =>
                      c.clienteNome != null &&
                      c.clienteNome!.toLowerCase().contains(
                        valor.toLowerCase(),
                      ),
                )
                .toList();
      }
      resultados = lista;
    } catch (_) {
      resultados = [];
    }
    notifyListeners();
  }
}
