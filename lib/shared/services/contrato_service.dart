// lib/shared/services/contrato_service.dart

import 'dart:convert';
import 'dart:typed_data';

import 'package:front_application/constants/constants.dart';
import 'package:front_application/features/contrato/models/contrato.dart';
import 'package:http/http.dart' as http;

class ContratoService {
  String get _baseUrl => AppConstants.baseUrl;

  /// 1) Lista todos contratos (resumos) → GET /api/contrato
  Future<List<Contrato>> listarContratosResumo() async {
    final url = Uri.parse('$_baseUrl/api/contrato');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> decoded = jsonDecode(response.body);
      return decoded
          .map((e) => Contrato.fromResumoJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
        'Falha ao listar contratos (status ${response.statusCode})',
      );
    }
  }

  /// 2) Busca contrato completo por ID → GET /api/contrato/{id}
  Future<Contrato> buscarContratoPorId(int id) async {
    final url = Uri.parse('$_baseUrl/api/contrato/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      return Contrato.fromJson(json);
    } else {
      throw Exception(
        'Falha ao buscar contrato (status ${response.statusCode})',
      );
    }
  }

  /// 3) Busca contrato por orçamento → GET /api/orcamento/{orcamentoId}/contrato
  Future<Contrato> buscarContratoPorOrcamento(int orcamentoId) async {
    final url = Uri.parse('$_baseUrl/api/orcamento/$orcamentoId/contrato');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      return Contrato.fromJson(json);
    } else {
      throw Exception(
        'Falha ao buscar contrato por orçamento (status ${response.statusCode})',
      );
    }
  }

  /// 4) Cria um novo contrato → POST /api/contrato
  Future<Contrato> criarContrato(Contrato contrato) async {
    final url = Uri.parse('$_baseUrl/api/contrato');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(contrato.toJson()),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      return Contrato.fromJson(json);
    } else {
      throw Exception(
        'Falha ao criar contrato (status ${response.statusCode})',
      );
    }
  }

  /// 5) Atualiza um contrato existente → PUT /api/contrato/{id}
  Future<Contrato> atualizarContrato(int id, Contrato contrato) async {
    final url = Uri.parse('$_baseUrl/api/contrato/$id');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(contrato.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      return Contrato.fromJson(json);
    } else {
      throw Exception(
        'Falha ao atualizar contrato (status ${response.statusCode})',
      );
    }
  }

  /// 6) Baixa o PDF do contrato → GET /api/orcamento/{orcamentoId}/contrato (Accept: application/pdf)
  Future<Uint8List> baixarContratoPdf(int orcamentoId) async {
    final url = Uri.parse('$_baseUrl/api/orcamento/$orcamentoId/contrato');
    final response = await http.get(
      url,
      headers: {'Accept': 'application/pdf'},
    );

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception(
        'Falha ao baixar contrato (status ${response.statusCode})',
      );
    }
  }
}
