import 'dart:convert';

import 'package:http/http.dart' as http;
//lib ofc flutter pra armazenar dados simples localmente
import 'package:shared_preferences/shared_preferences.dart';

/// Wrapper de http.Client que força decode UTF-8 e adiciona token automaticamente
class HttpClientUtf8 extends http.BaseClient {
  final http.Client _inner = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // Busca token salvo
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    // Aplica token se existir
    if (token != null && token.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    // Garante content-type também (evita repetir em cada chamada)
    request.headers.putIfAbsent('Content-Type', () => 'application/json');

    return _inner.send(request);
  }

  /// Reimplementa todos os métodos para garantir UTF-8 no corpo
  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    final response = await _inner.get(url, headers: headers);
    return _withUtf8Body(response);
  }

  @override
  Future<http.Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    final response = await _inner.post(
      url,
      headers: headers,
      body: body,
      encoding: encoding,
    );
    return _withUtf8Body(response);
  }

  @override
  Future<http.Response> put(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    final response = await _inner.put(
      url,
      headers: headers,
      body: body,
      encoding: encoding,
    );
    return _withUtf8Body(response);
  }

  @override
  Future<http.Response> delete(
    Uri url, {
    Object? body,
    Encoding? encoding,
    Map<String, String>? headers,
  }) async {
    final response = await _inner.delete(
      url,
      headers: headers,
      body: body,
      encoding: encoding,
    );
    return _withUtf8Body(response);
  }

  http.Response _withUtf8Body(http.Response response) {
    final decoded = utf8.decode(response.bodyBytes);
    return http.Response(
      decoded,
      response.statusCode,
      headers: response.headers,
      request: response.request,
      isRedirect: response.isRedirect,
      persistentConnection: response.persistentConnection,
      reasonPhrase: response.reasonPhrase,
    );
  }
}
