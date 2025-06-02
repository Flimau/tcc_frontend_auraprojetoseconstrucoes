import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../features/obra/models/diario_de_obra.dart';
import '../../features/obra/models/obra.dart';

class ObraService {
  // Se você tiver uma constante, por exemplo:
  // static const String _baseUrl = Constants.apiBaseUrl + '/obras';
  // Ajuste o caminho conforme configurar o Constants.
  static const String _baseUrl = 'http://localhost:8080/api/obras';

  /// Busca todas as obras
  static Future<List<Obra>> fetchAllObras() async {
    final resp = await http.get(Uri.parse(_baseUrl));
    if (resp.statusCode == 200) {
      final List<dynamic> listaJson = json.decode(resp.body);
      return listaJson.map((e) => Obra.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao buscar obras: ${resp.statusCode}');
    }
  }

  /// Busca uma obra por ID
  static Future<Obra> fetchObraById(String id) async {
    final resp = await http.get(Uri.parse('$_baseUrl/$id'));
    if (resp.statusCode == 200) {
      return Obra.fromJson(json.decode(resp.body));
    } else {
      throw Exception('Erro ao buscar obra $id: ${resp.statusCode}');
    }
  }

  /// Cria uma nova obra (sem executor e sem status, o back já inicializa status=PLANEJADA)
  static Future<Obra> createObra(Map<String, dynamic> payload) async {
    final resp = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(payload),
    );
    if (resp.statusCode == 200 || resp.statusCode == 201) {
      return Obra.fromJson(json.decode(resp.body));
    } else {
      throw Exception('Erro ao criar obra: ${resp.statusCode} ${resp.body}');
    }
  }

  /// Atualiza a obra (campos gerais: cliente, orçamento, executor, datas, contratoUrl)
  static Future<Obra> updateObra(
    String id,
    Map<String, dynamic> payload,
  ) async {
    final resp = await http.put(
      Uri.parse('$_baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(payload),
    );
    if (resp.statusCode == 200) {
      return Obra.fromJson(json.decode(resp.body));
    } else {
      throw Exception(
        'Erro ao atualizar obra $id: ${resp.statusCode} ${resp.body}',
      );
    }
  }

  /// Deleta a obra
  static Future<void> deleteObra(String id) async {
    final resp = await http.delete(Uri.parse('$_baseUrl/$id'));
    if (resp.statusCode != 204 && resp.statusCode != 200) {
      throw Exception('Erro ao deletar obra $id: ${resp.statusCode}');
    }
  }

  /// Atribui um executor à obra, validando datas
  static Future<Obra> assignExecutor(String obraId, String executorId) async {
    final resp = await http.put(
      Uri.parse('$_baseUrl/$obraId/executor/$executorId'),
    );
    if (resp.statusCode == 200) {
      return Obra.fromJson(json.decode(resp.body));
    } else {
      throw Exception(
        'Erro ao atribuir executor $executorId à obra $obraId: ${resp.statusCode} ${resp.body}',
      );
    }
  }

  /// Altera apenas o status da obra (PLANEJADA, EM_ANDAMENTO, PENDENTE, CONCLUIDA, CANCELADA)
  static Future<Obra> changeStatus(String obraId, String novoStatus) async {
    final resp = await http.put(
      Uri.parse('$_baseUrl/$obraId/status/$novoStatus'),
    );
    if (resp.statusCode == 200) {
      return Obra.fromJson(json.decode(resp.body));
    } else {
      throw Exception(
        'Erro ao alterar status da obra $obraId: ${resp.statusCode} ${resp.body}',
      );
    }
  }

  /// Retorna dados do Kanban (mapa de listas agrupadas por status)
  static Future<Map<String, List<Obra>>> fetchKanban() async {
    final resp = await http.get(Uri.parse('$_baseUrl/kanban'));
    if (resp.statusCode == 200) {
      final Map<String, dynamic> mapaJson = json.decode(resp.body);
      final Map<String, List<Obra>> resultado = {};
      mapaJson.forEach((status, lista) {
        resultado[status] =
            (lista as List).map((e) => Obra.fromJson(e)).toList();
      });
      return resultado;
    } else {
      throw Exception('Erro ao buscar Kanban: ${resp.statusCode}');
    }
  }

  /// Retorna obras cujo cronograma se sobrepõe a um período
  static Future<List<Obra>> fetchByPeriod(
    String dataInicio,
    String dataFim,
  ) async {
    final uri = Uri.parse(
      '$_baseUrl/calendario',
    ).replace(queryParameters: {'dataInicio': dataInicio, 'dataFim': dataFim});
    final resp = await http.get(uri);
    if (resp.statusCode == 200) {
      final List<dynamic> listaJson = json.decode(resp.body);
      return listaJson.map((e) => Obra.fromJson(e)).toList();
    } else {
      throw Exception(
        'Erro ao buscar obras no período: ${resp.statusCode} ${resp.body}',
      );
    }
  }

  /// DIÁRIOS DE OBRA – listar
  static Future<List<DiarioModel>> fetchDiarios(String obraId) async {
    final resp = await http.get(Uri.parse('$_baseUrl/$obraId/diarios'));
    if (resp.statusCode == 200) {
      final List<dynamic> listaJson = json.decode(resp.body);
      return listaJson.map((e) => DiarioModel.fromJson(e)).toList();
    } else {
      throw Exception(
        'Erro ao buscar diários da obra $obraId: ${resp.statusCode}',
      );
    }
  }

  /// DIÁRIOS DE OBRA – criar
  static Future<DiarioModel> createDiario(
    String obraId,
    Map<String, dynamic> payload,
  ) async {
    final resp = await http.post(
      Uri.parse('$_baseUrl/$obraId/diarios'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(payload),
    );
    if (resp.statusCode == 200 || resp.statusCode == 201) {
      return DiarioModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(
        'Erro ao criar diário na obra $obraId: ${resp.statusCode} ${resp.body}',
      );
    }
  }

  /// DIÁRIOS DE OBRA – atualizar
  static Future<DiarioModel> updateDiario(
    String obraId,
    String diarioId,
    Map<String, dynamic> payload,
  ) async {
    final resp = await http.put(
      Uri.parse('$_baseUrl/$obraId/diarios/$diarioId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(payload),
    );
    if (resp.statusCode == 200) {
      return DiarioModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(
        'Erro ao atualizar diário $diarioId na obra $obraId: ${resp.statusCode} ${resp.body}',
      );
    }
  }

  /// DIÁRIOS DE OBRA – deletar
  static Future<void> deleteDiario(String obraId, String diarioId) async {
    final resp = await http.delete(
      Uri.parse('$_baseUrl/$obraId/diarios/$diarioId'),
    );
    if (resp.statusCode != 204 && resp.statusCode != 200) {
      throw Exception(
        'Erro ao deletar diário $diarioId da obra $obraId: ${resp.statusCode}',
      );
    }
  }
}
