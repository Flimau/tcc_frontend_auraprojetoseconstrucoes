class EnderecoDTO {
  final String cep;
  final String logradouro;
  final String numero;
  final String complemento;
  final String bairro;
  final String cidade;
  final String siglaEstado;
  final double? latitude;
  final double? longitude;

  EnderecoDTO({
    required this.cep,
    required this.logradouro,
    required this.numero,
    required this.complemento,
    required this.bairro,
    required this.cidade,
    required this.siglaEstado,
    this.latitude,
    this.longitude,
  });

  factory EnderecoDTO.fromJson(Map<String, dynamic> json) {
    return EnderecoDTO(
      cep: json['cep'] as String? ?? '',
      logradouro: json['logradouro'] as String? ?? '',
      numero: json['numero']?.toString() ?? '',
      complemento: json['complemento'] as String? ?? '',
      bairro: json['bairro'] as String? ?? '',
      cidade: json['cidade'] as String? ?? '',
      siglaEstado: json['siglaEstado'] as String? ?? '',
      latitude:
          (json['latitude'] != null)
              ? (json['latitude'] as num).toDouble()
              : null,
      longitude:
          (json['longitude'] != null)
              ? (json['longitude'] as num).toDouble()
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cep': cep,
      'logradouro': logradouro,
      'numero': numero,
      'complemento': complemento,
      'bairro': bairro,
      'cidade': cidade,
      'siglaEstado': siglaEstado,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
    };
  }
}

class Visita {
  final String id;
  final int clienteId;
  final String clienteNome;
  final EnderecoDTO endereco;
  final String descricao;
  final String dataVisita;
  final List<String> fotos;
  final List<String> videos;
  final bool usadaEmOrcamento;

  Visita({
    required this.id,
    required this.clienteId,
    required this.clienteNome,
    required this.endereco,
    required this.descricao,
    required this.dataVisita,
    required this.fotos,
    required this.videos,
    required this.usadaEmOrcamento,
  });

  factory Visita.fromJson(Map<String, dynamic> json) {
    final fotosJson = json['fotos'] as List<dynamic>? ?? [];
    final videosJson = json['videos'] as List<dynamic>? ?? [];
    final enderecoJson = json['endereco'] as Map<String, dynamic>? ?? {};

    return Visita(
      id: json['id'].toString(),
      clienteId: json['clienteId']?.toInt() ?? 0,
      clienteNome: json['clienteNome'] as String? ?? '',
      endereco: EnderecoDTO.fromJson(enderecoJson),
      descricao: json['descricao'] as String? ?? '',
      dataVisita: json['dataVisita'] as String? ?? '',
      fotos: fotosJson.map((e) => e as String).toList(),
      videos: videosJson.map((e) => e as String).toList(),
      usadaEmOrcamento: json['usadaEmOrcamento'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toCadastroJson() {
    return {
      'clienteId': clienteId,
      'endereco': endereco.toJson(),
      'descricao': descricao,
      'dataVisita': dataVisita,
      'fotos': fotos,
      'videos': videos,
    };
  }
}
