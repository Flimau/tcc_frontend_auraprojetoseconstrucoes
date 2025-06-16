import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HttpClientUtf8 extends http.BaseClient {
  final http.Client _inner = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null && token.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    request.headers.putIfAbsent('Content-Type', () => 'application/json');

    return _inner.send(request);
  }

  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    final response = await _inner.get(url, headers: headers);
    return _processResponse(response);
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
    return _processResponse(response);
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
    return _processResponse(response);
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
    return _processResponse(response);
  }

  http.Response _processResponse(http.Response response) {
    final contentType = response.headers['content-type'] ?? '';

    if (contentType.contains('application/json') ||
        contentType.contains('text')) {
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

    // qualquer outra coisa (binário), retorna como veio
    return response;
  }
}
