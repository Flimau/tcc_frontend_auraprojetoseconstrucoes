// ============================
// lib/features/visita/controllers/visita_list_controller.dart
// ============================

import 'package:flutter/material.dart';

import '../../../shared/services/visita_service.dart';
import '../models/visita.dart';

class VisitaListController extends ChangeNotifier {
  List<Visita> resultados = [];
  bool carregando = false;
  String? erro;

  // Campos de busca / filtro
  String chaveSelecionada = 'DataVisita';
  final List<String> chaves = ['ID', 'Cliente', 'DataVisita'];

  final valorBuscaController = TextEditingController();
  final dataInicioController = TextEditingController();
  final dataFimController = TextEditingController();

  VisitaListController() {
    buscarTodasVisitas();
  }

  void atualizarChave(String nova) {
    chaveSelecionada = nova;
    notifyListeners();
  }

  /// Busca todas as visitas
  Future<void> buscarTodasVisitas() async {
    carregando = true;
    erro = null;
    notifyListeners();

    try {
      resultados = await VisitaService.fetchAllVisitas();
    } catch (e) {
      erro = 'Erro ao carregar visitas: $e';
      resultados = [];
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  /// Busca de acordo com o filtro selecionado
  Future<void> buscar(BuildContext context) async {
    final valor = valorBuscaController.text.trim();
    final dataInicioText = dataInicioController.text.trim();
    final dataFimText = dataFimController.text.trim();

    // Filtro por DataVisita (período)
    if (chaveSelecionada == 'DataVisita') {
      if (dataInicioText.isEmpty || dataFimText.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Preencha Data Início e Data Fim')),
        );
        return;
      }
      final inicio = _parseData(dataInicioText);
      final fim = _parseData(dataFimText);
      if (inicio == null || fim == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Formato de data inválido (DD/MM/AAAA)'),
          ),
        );
        return;
      }
      if (fim.isBefore(inicio)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data final não pode ser antes da inicial'),
          ),
        );
        return;
      }

      carregando = true;
      erro = null;
      notifyListeners();

      try {
        final isoInicio = _toIsoDate(inicio);
        final isoFim = _toIsoDate(fim);
        resultados = await VisitaService.fetchVisitasByPeriod(
          isoInicio,
          isoFim,
        );
      } catch (e) {
        erro = 'Erro ao buscar por período: $e';
        resultados = [];
      } finally {
        carregando = false;
        notifyListeners();
      }
      return;
    }

    // Filtro por ID
    if (chaveSelecionada == 'ID') {
      final idNum = int.tryParse(valor);
      if (idNum == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('ID inválido')));
        return;
      }
      carregando = true;
      erro = null;
      resultados = [];
      notifyListeners();

      try {
        final visita = await VisitaService.fetchVisitaById(valor);
        resultados = [visita];
      } catch (e) {
        erro = 'Nenhuma visita encontrada para ID $valor';
        resultados = [];
      } finally {
        carregando = false;
        notifyListeners();
      }
      return;
    }

    // Filtro por Cliente (nome)
    if (chaveSelecionada == 'Cliente') {
      carregando = true;
      erro = null;
      notifyListeners();

      try {
        final todas = await VisitaService.fetchAllVisitas();
        resultados =
            todas
                .where(
                  (v) =>
                      v.clienteNome.toLowerCase().contains(valor.toLowerCase()),
                )
                .toList();
      } catch (e) {
        erro = 'Erro ao filtrar por cliente: $e';
        resultados = [];
      } finally {
        carregando = false;
        notifyListeners();
      }
      return;
    }

    // Se o campo de texto estiver vazio, recarrega todas
    if (valor.isEmpty) {
      await buscarTodasVisitas();
      return;
    }
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

  String _toIsoDate(DateTime d) {
    final ano = d.year.toString().padLeft(4, '0');
    final mes = d.month.toString().padLeft(2, '0');
    final dia = d.day.toString().padLeft(2, '0');
    return '$ano-$mes-$dia';
  }

  /// Exclui uma visita e recarrega a lista
  Future<void> deleteVisita(
    BuildContext context,
    String visitaId,
    void Function(BuildContext, String, {bool erro}) mostrarMensagem,
  ) async {
    carregando = true;
    notifyListeners();
    try {
      await VisitaService.deleteVisita(visitaId);
      mostrarMensagem(context, 'Visita excluída com sucesso!');
      //aguarda o rebuild terminar antes de carregar as visitas
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await buscarTodasVisitas();
      });
    } catch (e) {
      mostrarMensagem(context, 'Erro ao excluir visita: $e', erro: true);
    } finally {
      carregando = false;
      notifyListeners();
    }
  }
}
