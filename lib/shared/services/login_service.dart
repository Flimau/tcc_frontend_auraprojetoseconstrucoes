import 'dart:convert';

import 'package:front_application/constants/constants.dart';

import '../../features/auth/models/login_response.dart';
import 'http_client_utf8.dart';

class LoginService {
  static final _client = HttpClientUtf8();

  Future<LoginResponse?> fazerLogin(String login, String senha) async {
    try {
      final response = await _client.post(
        Uri.parse('${AppConstants.baseUrl}/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'login': login, 'senha': senha}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return LoginResponse.fromJson(data);
      }

      return null;
    } catch (e, s) {
      print('Erro ao fazer login: $e');
      print(s);
      return null;
    }
  }
}
