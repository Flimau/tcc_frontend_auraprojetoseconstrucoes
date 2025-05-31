import 'package:flutter/material.dart';
import '../../../shared/components/form_widgets.dart';
import '../models/orcamento.dart';

class OrcamentoListController extends ChangeNotifier {
  final valorBuscaController = TextEditingController();
  final dataInicioController = TextEditingController();
  final dataFimController = TextEditingController();

  String chaveSelecionada = 'ID';

  final List<String> chaves = [
    'ID',
    'Descritivo',
    'Tipo',
    'Data de criação',
  ];

  List<Orcamento> resultados = [];

  void atualizarChave(String novaChave) {
    chaveSelecionada = novaChave;
    notifyListeners();
  }

  void buscar(BuildContext context) {
    final valor = valorBuscaController.text.trim();
    final dataInicio = dataInicioController.text.trim();
    final dataFim = dataFimController.text.trim();

    // Validações específicas
    if (chaveSelecionada == 'CPF' && valor.length != 14) {
      mostrarMensagem(context, 'CPF inválido (formato: 000.000.000-00)', erro: true);
      return;
    }

    if (chaveSelecionada == 'CNPJ' && valor.length != 18) {
      mostrarMensagem(context, 'CNPJ inválido (formato: 00.000.000/0000-00)', erro: true);
      return;
    }

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

    // Se todos os campos vazios, traz tudo
    if (valor.isEmpty && dataInicio.isEmpty && dataFim.isEmpty) {
      mostrarMensagem(context, 'Buscando todos os orçamentos...');
    }

    // Simulação de resultado
    resultados = [
      Orcamento(id: '1', descritivo: 'Projeto Arquitetônico', tipo: 'PROJETO'),
      Orcamento(id: '2', descritivo: 'Reforma Banheiro', tipo: 'REFORMA'),
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
