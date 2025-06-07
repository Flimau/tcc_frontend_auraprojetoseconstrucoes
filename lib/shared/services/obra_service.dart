// lib/shared/services/obra_service.dart

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../constants/constants.dart';
import '../../features/obra/models/diario_de_obra.dart';
import '../../features/obra/models/obra.dart';

class ObraService {
  static const String _baseUrl = AppConstants.baseUrl;

  // 1) GET /api/obras → lista todas as obras
  Future<List<Obra>> fetchAllObras() async {
    final resp = await http.get(Uri.parse('$_baseUrl/api/obras'));
    if (resp.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(resp.body);
      return jsonList
          .map((e) => Obra.fromDtoJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Erro ao buscar obras (${resp.statusCode})');
    }
  }

  // 2) GET /api/obras/{id} → busca obra por ID
  Future<Obra> buscarObraPorId(int id) async {
    final resp = await http.get(Uri.parse('$_baseUrl/api/obras/$id'));
    if (resp.statusCode == 200) {
      return Obra.fromDtoJson(jsonDecode(resp.body) as Map<String, dynamic>);
    } else {
      throw Exception('Erro ao buscar obra (${resp.statusCode})');
    }
  }

  // 3) POST /api/obras → cria nova obra
  Future<Obra> criarObra(Obra obra) async {
    final payload = obra.toJson(); // monta { “cliente”:{“id”:...}, ... }
    final resp = await http.post(
      Uri.parse('$_baseUrl/api/obras'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );
    if (resp.statusCode == 201) {
      return Obra.fromDtoJson(jsonDecode(resp.body) as Map<String, dynamic>);
    } else {
      throw Exception('Falha ao criar obra (${resp.statusCode})');
    }
  }

  // 4) PUT /api/obras/{id} → atualiza obra (sem alterar status)
  Future<Obra> atualizarObra(int id, Obra obra) async {
    final payload = obra.toJson();
    final resp = await http.put(
      Uri.parse('$_baseUrl/api/obras/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );
    if (resp.statusCode == 200) {
      return Obra.fromDtoJson(jsonDecode(resp.body) as Map<String, dynamic>);
    } else {
      throw Exception('Falha ao atualizar obra (${resp.statusCode})');
    }
  }

  // 5) DELETE /api/obras/{id}
  Future<void> deleteObra(int id) async {
    final resp = await http.delete(Uri.parse('$_baseUrl/api/obras/$id'));
    if (resp.statusCode != 204) {
      throw Exception('Erro ao deletar obra $id: ${resp.statusCode}');
    }
  }

  // 6) PUT /api/obras/{id}/status/{novoStatus}
  Future<Obra> changeStatus(int id, String novoStatus) async {
    final resp = await http.put(
      Uri.parse('$_baseUrl/api/obras/$id/status/$novoStatus'),
    );
    if (resp.statusCode == 200) {
      return Obra.fromDtoJson(jsonDecode(resp.body) as Map<String, dynamic>);
    } else {
      throw Exception('Erro ao alterar status da obra $id: ${resp.statusCode}');
    }
  }

  // 7) GET /api/obras/kanban
  Future<Map<String, List<Obra>>> fetchKanban() async {
    final resp = await http.get(Uri.parse('$_baseUrl/api/obras/kanban'));
    if (resp.statusCode == 200) {
      final Map<String, dynamic> mapaJson = jsonDecode(resp.body);
      final Map<String, List<Obra>> resultado = {};
      mapaJson.forEach((status, lista) {
        resultado[status] =
            (lista as List)
                .map((e) => Obra.fromDtoJson(e as Map<String, dynamic>))
                .toList();
      });
      return resultado;
    } else {
      throw Exception('Erro ao buscar Kanban: ${resp.statusCode}');
    }
  }

  // 8) GET /api/obras/calendario?dataInicio=YYYY-MM-DD&dataFim=YYYY-MM-DD
  Future<List<Obra>> fetchByPeriod(String dataInicio, String dataFim) async {
    final uri = Uri.parse(
      '$_baseUrl/api/obras/calendario',
    ).replace(queryParameters: {'dataInicio': dataInicio, 'dataFim': dataFim});
    final resp = await http.get(uri);
    if (resp.statusCode == 200) {
      final List<dynamic> listaJson = jsonDecode(resp.body);
      return listaJson
          .map((e) => Obra.fromDtoJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Erro ao buscar por período: ${resp.statusCode}');
    }
  }

  // 9) GET /api/obras/{obraId}/diarios
  Future<List<DiarioDeObra>> fetchDiarios(int obraId) async {
    final resp = await http.get(
      Uri.parse('$_baseUrl/api/obras/$obraId/diarios'),
    );
    if (resp.statusCode == 200) {
      final List<dynamic> listaJson = jsonDecode(resp.body);
      return listaJson
          .map((e) => DiarioDeObra.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
        'Erro ao buscar diários da obra $obraId: ${resp.statusCode}',
      );
    }
  }

  // 10) POST /api/obras/{obraId}/diarios
  Future<DiarioDeObra> createDiario(int obraId, DiarioDeObra diario) async {
    final resp = await http.post(
      Uri.parse('$_baseUrl/api/obras/$obraId/diarios'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(diario.toJson()),
    );
    if (resp.statusCode == 201) {
      return DiarioDeObra.fromJson(
        jsonDecode(resp.body) as Map<String, dynamic>,
      );
    } else {
      throw Exception(
        'Erro ao criar diário na obra $obraId: ${resp.statusCode}',
      );
    }
  }

  // 11) PUT /api/obras/{obraId}/diarios/{id}
  Future<DiarioDeObra> updateDiario(
    int obraId,
    int diarioId,
    DiarioDeObra diario,
  ) async {
    final resp = await http.put(
      Uri.parse('$_baseUrl/api/obras/$obraId/diarios/$diarioId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(diario.toJson()),
    );
    if (resp.statusCode == 200) {
      return DiarioDeObra.fromJson(
        jsonDecode(resp.body) as Map<String, dynamic>,
      );
    } else {
      throw Exception('Erro ao atualizar diário $diarioId: ${resp.statusCode}');
    }
  }

  // 12) DELETE /api/obras/{obraId}/diarios/{id}
  Future<void> deleteDiario(int obraId, int diarioId) async {
    final resp = await http.delete(
      Uri.parse('$_baseUrl/api/obras/$obraId/diarios/$diarioId'),
    );
    if (resp.statusCode != 204) {
      throw Exception('Erro ao deletar diário $diarioId: ${resp.statusCode}');
    }
  }
}
