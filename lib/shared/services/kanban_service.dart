import 'dart:convert';

import 'package:front_application/constants/constants.dart';
import 'package:front_application/features/agenda/models/kanban_card.dart';
import 'package:http/http.dart' as http;

class KanbanService {
  String get _baseUrl => AppConstants.baseUrl;

  Future<List<KanbanCard>> listarCards() async {
    final url = Uri.parse('$_baseUrl/api/kanban/cards');
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(resp.body);
      return jsonList
          .map((e) => KanbanCard.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Falha ao listar cards (${resp.statusCode})');
    }
  }

  Future<KanbanCard> criarCard(KanbanCard card) async {
    final url = Uri.parse('$_baseUrl/api/kanban/cards');
    final resp = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(card.toJson()),
    );
    if (resp.statusCode == 201) {
      return KanbanCard.fromJson(jsonDecode(resp.body));
    } else {
      throw Exception('Falha ao criar card (${resp.statusCode})');
    }
  }

  Future<KanbanCard> atualizarCard(int id, KanbanCard card) async {
    final url = Uri.parse('$_baseUrl/api/kanban/cards/$id');
    final resp = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(card.toJson()),
    );
    if (resp.statusCode == 200) {
      return KanbanCard.fromJson(jsonDecode(resp.body));
    } else {
      throw Exception('Falha ao atualizar card (${resp.statusCode})');
    }
  }

  Future<void> deletarCard(int id) async {
    final url = Uri.parse('$_baseUrl/api/kanban/cards/$id');
    final resp = await http.delete(url);
    if (resp.statusCode != 204) {
      throw Exception('Falha ao deletar card (${resp.statusCode})');
    }
  }
}
