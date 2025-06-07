// ============================
// lib/shared/services/visita_service.dart
// ============================

import 'dart:convert';

import 'package:front_application/constants/constants.dart';
import 'package:http/http.dart' as http;

import '../../features/visita/models/visita.dart';

class VisitaService {
  static const String _basePath = '/api/visitaTecnica';

  /// Busca todas as visitas (GET /api/visitaTecnica)
  static Future<List<Visita>> fetchAllVisitas() async {
    final uri = Uri.parse('${AppConstants.baseUrl}$_basePath');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> listaJson =
          json.decode(response.body) as List<dynamic>;
      return listaJson
          .map((jsonItem) => Visita.fromJson(jsonItem as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
        'Falha ao carregar visitas: status ${response.statusCode}',
      );
    }
  }

  /// Busca uma visita por ID (GET /api/visitaTecnica/{id})
  static Future<Visita> fetchVisitaById(String id) async {
    final uri = Uri.parse('${AppConstants.baseUrl}$_basePath/$id');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return Visita.fromJson(
        json.decode(response.body) as Map<String, dynamic>,
      );
    } else {
      throw Exception(
        'Visita não encontrada: $id (status ${response.statusCode})',
      );
    }
  }

  /// Busca visitas em um período (GET /api/visitaTecnica?dataInicio=yyyy-MM-dd&dataFim=yyyy-MM-dd)
  static Future<List<Visita>> fetchVisitasByPeriod(
    String isoDataInicio,
    String isoDataFim,
  ) async {
    final uri = Uri.parse('${AppConstants.baseUrl}$_basePath').replace(
      queryParameters: {'dataInicio': isoDataInicio, 'dataFim': isoDataFim},
    );
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> listaJson =
          json.decode(response.body) as List<dynamic>;
      return listaJson
          .map((jsonItem) => Visita.fromJson(jsonItem as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
        'Falha ao buscar por período: status ${response.statusCode}',
      );
    }
  }

  /// Cria nova visita (POST /api/visitaTecnica)
  static Future<Visita> createVisita(Visita visita) async {
    final uri = Uri.parse('${AppConstants.baseUrl}$_basePath');
    final payload = visita.toCadastroJson();
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(payload),
    );

    if (response.statusCode == 201) {
      return Visita.fromJson(
        json.decode(response.body) as Map<String, dynamic>,
      );
    } else {
      throw Exception('Falha ao criar visita: status ${response.statusCode}');
    }
  }

  /// Atualiza uma visita existente (PUT /api/visitaTecnica/{id})
  static Future<Visita> updateVisita(String id, Visita visita) async {
    final uri = Uri.parse('${AppConstants.baseUrl}$_basePath/$id');
    final payload = visita.toCadastroJson();
    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(payload),
    );

    if (response.statusCode == 200) {
      return Visita.fromJson(
        json.decode(response.body) as Map<String, dynamic>,
      );
    } else {
      throw Exception(
        'Falha ao atualizar visita: status ${response.statusCode}',
      );
    }
  }

  /// Exclui uma visita (DELETE /api/visitaTecnica/{id})
  static Future<void> deleteVisita(String id) async {
    final uri = Uri.parse('${AppConstants.baseUrl}$_basePath/$id');
    final response = await http.delete(uri);

    if (response.statusCode != 204) {
      throw Exception('Falha ao excluir visita: status ${response.statusCode}');
    }
  }
}
