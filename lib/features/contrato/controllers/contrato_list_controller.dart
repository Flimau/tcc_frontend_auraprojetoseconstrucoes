import 'package:flutter/material.dart';
import '../../../shared/components/form_widgets.dart';
import '../models/contrato.dart';

class ContratoListController extends ChangeNotifier {
  final valorBuscaController = TextEditingController();
  final dataInicioController = TextEditingController();
  final dataFimController = TextEditingController();

  String chaveSelecionada = 'ID';

  final List<String> chaves = [
    'ID',
    'Cliente',
    'Obra',
    'Status',
    'Data de criação',
  ];

  List<Contrato> resultados = [];

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
        mostrarMensagem(context, 'Preencha ambas as datas para buscar por intervalo', erro: true);
        return;
      }

      final hoje = DateTime.now();
      final dataFimParsed = _parseData(dataFim);
      if (dataFimParsed != null && dataFimParsed.isAfter(hoje)) {
        mostrarMensagem(context, 'Data final não pode ser maior que hoje', erro: true);
        return;
      }
    }

    if (valor.isEmpty && dataInicio.isEmpty && dataFim.isEmpty) {
      mostrarMensagem(context, 'Buscando todos os contratos...');
    }

    resultados = [
      Contrato(id: '1', status: 'EM EXECUÇÃO'),
      Contrato(id: '2', status: 'EM ABERTO'),
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
