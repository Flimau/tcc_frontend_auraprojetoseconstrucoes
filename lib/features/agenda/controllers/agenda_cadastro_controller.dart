// lib/features/agenda/controllers/agenda_cadastro_controller.dart

import 'package:flutter/material.dart';
import 'package:front_application/shared/services/agenda_service.dart';

import '../models/agenda_item.dart';

class AgendaCadastroController extends ChangeNotifier {
  final AgendaService _service = AgendaService();

  final TextEditingController tituloController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  DateTime? data;
  final TextEditingController horarioController = TextEditingController();

  int? itemIdExistente;
  bool isLoading = false;

  Future<void> carregarParaEdicao(int id) async {
    isLoading = true;
    notifyListeners();
    try {
      final item = await _service.buscarPorId(id);
      itemIdExistente = item.id;
      tituloController.text = item.titulo;
      descricaoController.text = item.descricao;
      data = item.data;
      horarioController.text = item.horario;
    } catch (_) {
      itemIdExistente = null;
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> salvar(BuildContext context) async {
    final titulo = tituloController.text.trim();
    final descricao = descricaoController.text.trim();
    final horario = horarioController.text.trim();
    if (titulo.isEmpty ||
        descricao.isEmpty ||
        data == null ||
        horario.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Preencha todos os campos')));
      return;
    }

    final dto = AgendaItem(
      id: itemIdExistente,
      titulo: titulo,
      descricao: descricao,
      data: data!,
      horario: horario,
    );

    try {
      isLoading = true;
      notifyListeners();
      if (itemIdExistente == null) {
        await _service.criarAgenda(dto);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item criado com sucesso')),
        );
      } else {
        await _service.atualizarAgenda(itemIdExistente!, dto);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item atualizado com sucesso')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro: ${e.toString()}')));
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
