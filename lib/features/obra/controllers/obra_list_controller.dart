import 'package:flutter/material.dart';

import '../../../shared/components/form_widgets.dart';
import '../models/obra.dart';

class ObraListController extends ChangeNotifier {
  final valorBuscaController = TextEditingController();
  final dataInicioController = TextEditingController();
  final dataFimController = TextEditingController();

  String chaveSelecionada = 'ID';

  final List<String> chaves = [
    'ID',
    'Nome da Obra',
    'Cliente',
    'Status',
    'Data de criação',
  ];

  List<Obra> resultados = [];

  void atualizarChave(String novaChave) {
    chaveSelecionada = novaChave;
    notifyListeners();
  }

  void buscar(BuildContext context) {
    final valor = valorBuscaController.text.trim();
    final dataInicio = dataInicioController.text.trim();
    final dataFim = dataFimController.text.trim();

    if (chaveSelecionada == 'Data de criação') {
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
      mostrarMensagem(context, 'Buscando todas as obras...');
    }

    resultados = [
      Obra(id: '1', nome: 'Casa do Cliente XPTO', status: 'EM ANDAMENTO'),
      Obra(id: '2', nome: 'Obra Loft Reforma', status: 'PENDENTE'),
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
