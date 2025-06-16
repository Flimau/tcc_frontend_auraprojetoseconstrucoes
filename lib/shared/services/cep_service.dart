//lib/shared/services/cep_service.dart
import 'dart:convert';

import 'package:http/http.dart' as http;

class CepService {
  static Future<Map<String, String>?> buscarEndereco(String cep) async {
    final url = Uri.parse('https://viacep.com.br/ws/$cep/json/');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (!data.containsKey('erro')) {
          return {
            'logradouro': data['logradouro'] ?? '',
            'bairro': data['bairro'] ?? '',
            'cidade': data['localidade'] ?? '',
            'estado': data['uf'] ?? '',
          };
        }
      }
    } catch (_) {
      return null;
    }

    return null;
  }
}
