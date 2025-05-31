import 'package:flutter/material.dart';

import '../../../shared/components/form_widgets.dart';
import '../models/visita.dart';

class VisitaListController extends ChangeNotifier {
  final valorBuscaController = TextEditingController();
  final dataInicioController = TextEditingController();
  final dataFimController = TextEditingController();

  String chaveSelecionada = 'ID';

  final List<String> chaves = ['ID', 'Endereço', 'Cliente', 'Data da visita'];

  List<Visita> resultados = [];

  void atualizarChave(String novaChave) {
    chaveSelecionada = novaChave;
    notifyListeners();
  }

  void buscar(BuildContext context) {
    final valor = valorBuscaController.text.trim();
    final dataInicio = dataInicioController.text.trim();
    final dataFim = dataFimController.text.trim();

    if (chaveSelecionada == 'Data da visita') {
      if (dataInicio.isEmpty || dataFim.isEmpty) {
        mostrarMensagem(
          context,
          'Preencha ambas as datas para buscar por intervalo',
          erro: true,
        );
        return;
      }

      final hoje = DateTime.now();
      final dataFimParsed = _parseData(dataFim);
      if (dataFimParsed != null && dataFimParsed.isAfter(hoje)) {
        mostrarMensagem(
          context,
          'Data final não pode ser maior que hoje',
          erro: true,
        );
        return;
      }
    }

    if (valor.isEmpty && dataInicio.isEmpty && dataFim.isEmpty) {
      mostrarMensagem(context, 'Buscando todas as visitas...');
    }

    resultados = [
      Visita(id: '1', endereco: 'Rua Projetada, 123', data: '15/05/2025'),
      Visita(id: '2', endereco: 'Av. das Obras, 456', data: '16/05/2025'),
    ];

    notifyListeners();
  }

  DateTime? _parseData(String data) {
    try {
      final partes = data.split('/');
      return DateTime(
        int.parse(partes[2]),
        int.parse(partes[1]),
        int.parse(partes[0]),
      );
    } catch (_) {
      return null;
    }
  }
}
