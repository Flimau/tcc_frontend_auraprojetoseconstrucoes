// lib/shared/services/agenda_service.dart

import 'dart:convert';

import 'package:front_application/constants/constants.dart';
import 'package:front_application/features/agenda/models/agenda_item.dart';
import 'package:http/http.dart' as http;

class AgendaService {
  String get _baseUrl => AppConstants.baseUrl;

  Future<List<AgendaItem>> listarAgenda() async {
    final url = Uri.parse('$_baseUrl/api/agenda');
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(resp.body);
      return jsonList
          .map((e) => AgendaItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Falha ao listar agenda (${resp.statusCode})');
    }
  }

  Future<AgendaItem> buscarPorId(int id) async {
    final url = Uri.parse('$_baseUrl/api/agenda/$id');
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      return AgendaItem.fromJson(jsonDecode(resp.body));
    } else {
      throw Exception('Falha ao buscar item (${resp.statusCode})');
    }
  }

  Future<AgendaItem> criarAgenda(AgendaItem item) async {
    final url = Uri.parse('$_baseUrl/api/agenda');
    final resp = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(item.toJson()),
    );
    if (resp.statusCode == 201) {
      return AgendaItem.fromJson(jsonDecode(resp.body));
    } else {
      throw Exception('Falha ao criar item (${resp.statusCode})');
    }
  }

  Future<AgendaItem> atualizarAgenda(int id, AgendaItem item) async {
    final url = Uri.parse('$_baseUrl/api/agenda/$id');
    final resp = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(item.toJson()),
    );
    if (resp.statusCode == 200) {
      return AgendaItem.fromJson(jsonDecode(resp.body));
    } else {
      throw Exception('Falha ao atualizar item (${resp.statusCode})');
    }
  }

  Future<void> deletarAgenda(int id) async {
    final url = Uri.parse('$_baseUrl/api/agenda/$id');
    final resp = await http.delete(url);
    if (resp.statusCode != 204) {
      throw Exception('Falha ao deletar item (${resp.statusCode})');
    }
  }
}
