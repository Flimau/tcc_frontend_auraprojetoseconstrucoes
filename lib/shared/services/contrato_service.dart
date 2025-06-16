import 'dart:convert';
import 'dart:typed_data';

import 'package:front_application/constants/constants.dart';
import 'package:front_application/features/contrato/models/contrato_dto.dart';
import 'package:front_application/features/contrato/models/contrato_resumo.dart';
import 'package:http/http.dart' as http;

import 'http_client_utf8.dart';

class ContratoService {
  String get _baseUrl => AppConstants.baseUrl;
  static final _client = HttpClientUtf8();
  final http.Client _pureClient = http.Client();

  /// Listar contratos resumo
  Future<List<ContratoResumo>> listarContratosResumo() async {
    final url = Uri.parse('$_baseUrl/api/contrato');
    final response = await _client.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> decoded = jsonDecode(response.body);
      return decoded.map((e) => ContratoResumo.fromJson(e)).toList();
    } else {
      throw Exception(
        'Falha ao listar contratos (status ${response.statusCode})',
      );
    }
  }

  /// Buscar contrato por ID
  Future<ContratoDTO> buscarContratoPorId(int id) async {
    final url = Uri.parse('$_baseUrl/api/contrato/$id');
    final response = await _client.get(url);

    if (response.statusCode == 200) {
      return ContratoDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'Falha ao buscar contrato (status ${response.statusCode})',
      );
    }
  }

  /// Buscar contrato por orçamento
  Future<ContratoDTO> buscarContratoPorOrcamento(int orcamentoId) async {
    final url = Uri.parse('$_baseUrl/api/orcamento/$orcamentoId/contrato');
    final response = await _client.get(url);

    if (response.statusCode == 200) {
      return ContratoDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'Falha ao buscar contrato por orçamento (status ${response.statusCode})',
      );
    }
  }

  /// Criar contrato
  Future<ContratoDTO> criarContrato(ContratoDTO contrato) async {
    final url = Uri.parse('$_baseUrl/api/contrato');
    final response = await _client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(contrato.toJson()),
    );

    if (response.statusCode == 201) {
      return ContratoDTO.fromJson(jsonDecode(response.body));
    } else {
      final Map<String, dynamic> jsonError = jsonDecode(response.body);
      final String? message = jsonError['message'];
      throw Exception('Erro: $message (status ${response.statusCode})');
    }
  }

  /// Atualizar contrato
  Future<ContratoDTO> atualizarContrato(int id, ContratoDTO contrato) async {
    final url = Uri.parse('$_baseUrl/api/contrato/$id');
    final response = await _client.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(contrato.toJson()),
    );

    if (response.statusCode == 200) {
      return ContratoDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'Falha ao atualizar contrato (status ${response.statusCode})',
      );
    }
  }

static Future<Uint8List> gerarPdfContrato(int id) async {
  final uri = Uri.parse('${AppConstants.baseUrl}/api/contrato/$id/pdf');

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    return response.bodyBytes;
  } else {
    throw Exception('Erro ao gerar PDF. Código: ${response.statusCode}');
  }
}

  /// Buscar contrato por ID
  Future<void> deletarContrato(int id) async {
    final url = Uri.parse('$_baseUrl/api/contrato/$id');
    final response = await _client.delete(url);

    if (response.statusCode == 204 || response.statusCode == 200) {
      return;
    } else {
      throw Exception(
        'Erro ao excluir contrato ID $id. Código: ${response.statusCode}',
      );
    }
  }
}
