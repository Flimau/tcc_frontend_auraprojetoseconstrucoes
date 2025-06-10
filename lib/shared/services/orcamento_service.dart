// lib/features/orcamento/services/orcamento_service.dart

import 'dart:convert'; // Para jsonEncode e jsonDecode
import 'dart:typed_data';

import 'package:front_application/constants/constants.dart'; // Base URL da API
import 'package:front_application/features/orcamento/models/orcamento.dart'; // Modelo do Orcamento
import 'package:http/http.dart' as http; // Para chamadas HTTP

class OrcamentoService {
  // Construtor privado para impedir instância
  OrcamentoService._();

  /// Busca todos os orçamentos cadastrados no back-end.
  static Future<List<Orcamento>> fetchAllOrcamentos() async {
    // Monta a URL: <baseUrl>/api/orcamento
    final uri = Uri.parse('${AppConstants.baseUrl}/api/orcamento');

    // Chama GET
    final response = await http.get(uri);

    // Se status 200, decodifica e mapeia cada JSON para Orcamento
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
      return jsonList
          .map((item) => Orcamento.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      // Caso contrário, lança exceção com o código HTTP
      throw Exception(
        'Erro ao carregar orçamentos. Código: ${response.statusCode}',
      );
    }
  }

  /// Busca um orçamento específico pelo seu ID.
  static Future<Orcamento> fetchOrcamentoById(int id) async {
    // URL: <baseUrl>/api/orcamento/<id>
    final uri = Uri.parse('${AppConstants.baseUrl}/api/orcamento/$id');

    // Chama GET
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap =
          jsonDecode(response.body) as Map<String, dynamic>;
      return Orcamento.fromJson(jsonMap);
    } else {
      throw Exception(
        'Erro ao buscar orçamento ID $id. Código: ${response.statusCode}',
      );
    }
  }

  /// Cria um novo orçamento no back-end.
  static Future<Orcamento> createOrcamento(Orcamento orcamento) async {
    // URL de POST: <baseUrl>/api/orcamento
    final uri = Uri.parse('${AppConstants.baseUrl}/api/orcamento');

    // Prepara o corpo JSON usando toCadastroJson (DTO de criação)
    final bodyJson = jsonEncode(orcamento.toCadastroJson());

    // Chama POST com cabeçalho JSON
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: bodyJson,
    );

    // Se status 201 ou 200, converte o JSON de resposta em Orcamento
    if (response.statusCode == 201 || response.statusCode == 200) {
      final Map<String, dynamic> jsonMap =
          jsonDecode(response.body) as Map<String, dynamic>;
      return Orcamento.fromJson(jsonMap);
    } else {
      throw Exception(
        'Erro ao criar orçamento. Código: ${response.statusCode}',
      );
    }
  }

  /// Atualiza um orçamento existente (identificado pelo orcamento.id).
  static Future<Orcamento> updateOrcamento(Orcamento orcamento) async {
    // Extrai o ID do objeto para montar a rota
    final int id = orcamento.id;
    final uri = Uri.parse('${AppConstants.baseUrl}/api/orcamento/$id');

    // Prepara o JSON para envio (DTO de criação/atualização)
    final bodyJson = jsonEncode(orcamento.toCadastroJson());

    // Chama PUT
    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: bodyJson,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap =
          jsonDecode(response.body) as Map<String, dynamic>;
      return Orcamento.fromJson(jsonMap);
    } else {
      throw Exception(
        'Erro ao atualizar orçamento ID $id. Código: ${response.statusCode}',
      );
    }
  }

  /// Exclui um orçamento pelo ID.
  static Future<void> deleteOrcamento(int id) async {
    // URL: <baseUrl>/api/orcamento/<id>
    final uri = Uri.parse('${AppConstants.baseUrl}/api/orcamento/$id');

    // Chama DELETE
    final response = await http.delete(uri);

    // Se status 204 (No Content) ou 200 (OK), considera sucesso
    if (response.statusCode == 204 || response.statusCode == 200) {
      return;
    } else {
      throw Exception(
        'Erro ao excluir orçamento ID $id. Código: ${response.statusCode}',
      );
    }
  }

  /// Gera e baixa o PDF do orçamento pelo ID.
  static Future<Uint8List> gerarPdfOrcamento(int id) async {
    final uri = Uri.parse('${AppConstants.baseUrl}/api/orcamento/$id/pdf');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return response.bodyBytes; // PDF binário
    } else {
      throw Exception('Erro ao gerar PDF. Código: ${response.statusCode}');
    }
  }
}
