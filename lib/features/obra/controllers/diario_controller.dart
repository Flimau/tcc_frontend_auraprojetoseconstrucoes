// lib/features/obra/controllers/diario_controller.dart

import 'package:flutter/material.dart';
import '../../../features/obra/models/diario_de_obra.dart';
import '../../../shared/services/obra_service.dart';

class DiarioController extends ChangeNotifier {
  final String obraId;

  DiarioController({required this.obraId}) {
    listarDiarios();
  }

  List<Diario> diarios = [];
  bool carregando = false;
  String? erro;

  // Campos do formulário para criar/editar
  final dataController = TextEditingController();
  final itensController = TextEditingController(); // itens separados por vírgula ou nova linha
  final observacoesController = TextEditingController();

  String? editandoId; // se não nulo, estamos editando o diário com esse ID

  /// Lista todos os diários da obra
  Future<void> listarDiarios() async {
    carregando = true;
    erro = null;
    notifyListeners();

    try {
      diarios = await ObraService.fetchDiarios(obraId);
    } catch (e) {
      erro = 'Erro ao listar diários: $e';
      diarios = [];
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  /// Prepara os campos para editar um diário existente
  void prepararEdicao(Diario diario) {
    editandoId = diario.id;
    // Converte data ISO para DD/MM/AAAA
    dataController.text = _formatarDataTela(diario.dataRegistro);
    itensController.text = diario.itens.join('\n');
    observacoesController.text = diario.observacoes ?? '';
    notifyListeners();
  }

  /// Cancela o modo edição (limpa campos)
  void cancelarEdicao() {
    editandoId = null;
    dataController.clear();
    itensController.clear();
    observacoesController.clear();
    notifyListeners();
  }

  /// Salva (cria ou atualiza) um diário
  Future<void> salvarDiario(BuildContext context, void Function(BuildContext, String, {bool erro}) mostrarMensagem) async {
    final dataText = dataController.text.trim();
    final itensText = itensController.text.trim();
    final obsText = observacoesController.text.trim();

    if (dataText.isEmpty || itensText.isEmpty) {
      mostrarMensagem(context, 'Preencha data e itens do dia.', erro: true);
      return;
    }

    final dataParsed = _parseData(dataText);
    if (dataParsed == null) {
      mostrarMensagem(context, 'Data inválida (use DD/MM/AAAA).', erro: true);
      return;
    }
    final isoData = _toIsoDate(dataParsed);

    final itensList = itensText
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final payload = {
      'dataRegistro': isoData,
      'itens': itensList,
      'observacoes': obsText.isNotEmpty ? obsText : null,
    };

    carregando = true;
    erro = null;
    notifyListeners();

    try {
      if (editandoId == null) {
        // Cria
        await ObraService.createDiario(obraId, payload);
        mostrarMensagem(context, 'Diário criado com sucesso!');
      } else {
        // Atualiza
        await ObraService.updateDiario(obraId, editandoId!, payload);
        mostrarMensagem(context, 'Diário atualizado com sucesso!');
      }
      cancelarEdicao();
      await listarDiarios(); // recarrega lista
    } catch (e) {
      mostrarMensagem(context, 'Erro ao salvar diário: $e', erro: true);
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  /// Exclui um diário
  Future<void> excluirDiario(BuildContext context, String diarioId, void Function(BuildContext, String, {bool erro}) mostrarMensagem) async {
    carregando = true;
    erro = null;
    notifyListeners();
    try {
      await ObraService.deleteDiario(obraId, diarioId);
      mostrarMensagem(context, 'Diário excluído com sucesso!');
      await listarDiarios();
    } catch (e) {
      mostrarMensagem(context, 'Erro ao excluir diário: $e', erro: true);
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  /// Converte string “DD/MM/AAAA” para DateTime ou retorna null
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

  /// Converte DateTime para “YYYY-MM-DD”
  String _toIsoDate(DateTime d) {
    final ano = d.year.toString().padLeft(4, '0');
    final mes = d.month.toString().padLeft(2, '0');
    final dia = d.day.toString().padLeft(2, '0');
    return '$ano-$mes-$dia';
  }

  /// Converte ISO “YYYY-MM-DD” para “DD/MM/AAAA”
  String _formatarDataTela(String isoDate) {
    try {
      final parts = isoDate.split('-'); // [YYYY, MM, DD]
      return '${parts[2].padLeft(2, '0')}/${parts[1].padLeft(2, '0')}/${parts[0]}';
    } catch (_) {
      return isoDate;
    }
  }
}
