import 'package:flutter/material.dart';

import '../../../shared/services/obra_service.dart';
import '../models/diario_de_obra.dart';

class DiarioController extends ChangeNotifier {
  final ObraService _service = ObraService();

  bool isLoading = false;
  List<DiarioDeObra> diarios = [];

  Future<void> fetchDiarios(int obraId) async {
    isLoading = true;
    notifyListeners();
    try {
      diarios = await _service.fetchDiarios(obraId);
    } catch (_) {
      diarios = [];
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> criarDiario(
    int obraId,
    DiarioDeObra diario,
    BuildContext context,
  ) async {
    isLoading = true;
    notifyListeners();
    try {
      await _service.createDiario(obraId, diario);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('diario criado com sucesso.')));
      await fetchDiarios(obraId);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao criar diario: ${e.toString()}')),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateDiario(
    int obraId,
    int diarioId,
    DiarioDeObra diario,
    BuildContext context,
  ) async {
    isLoading = true;
    notifyListeners();
    try {
      await _service.updateDiario(obraId, diarioId, diario);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('diario atualizado com sucesso.')));
      await fetchDiarios(obraId);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar diario: ${e.toString()}')),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteDiario(
    int obraId,
    int diarioId,
    BuildContext context,
  ) async {
    isLoading = true;
    notifyListeners();
    try {
      await _service.deleteDiario(obraId, diarioId);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('diario deletado com sucesso.')));
      await fetchDiarios(obraId);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao deletar diario: ${e.toString()}')),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
