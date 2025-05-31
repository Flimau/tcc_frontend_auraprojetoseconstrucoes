import 'dart:convert';
import 'package:http/http.dart' as http;

class GeolocalizacaoService {
  static const String _apiKey = '5b9a3b84e1024ea4ae240e6741cd3b16';

  static Future<Map<String, double>?> buscarCoordenadas({
    required String logradouro,
    required String numero,
    required String cidade,
    required String estado,
  }) async {
    final endereco = Uri.encodeComponent('$logradouro $numero, $cidade, $estado');
    final url = Uri.parse(
      'https://api.opencagedata.com/geocode/v1/json?q=$endereco&key=$_apiKey&language=pt&pretty=1',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['results'] != null && data['results'].isNotEmpty) {
        final geometry = data['results'][0]['geometry'];
        return {
          'latitude': geometry['lat'],
          'longitude': geometry['lng'],
        };
      }
    }

    return null;
  }
  
}
