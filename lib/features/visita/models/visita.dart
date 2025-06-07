// lib/features/visita/models/visita.dart

/// Representa o objeto “Endereço” conforme o DTO usado pelo back-end.
/// Esse endereço corresponde ao EnderecoDTO no servidor, com campos:
///   - cep
///   - logradouro
///   - numero
///   - complemento
///   - bairro
///   - cidade
///   - siglaEstado
///   - latitude (opcional)
///   - longitude (opcional)
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

/// Modelo que representa exatamente a VisitaTécnica conforme o DTO
/// VisitaTecnicaDTO retornado pelo back-end.
/// Contém:
///   - id                  : Long (armazenado como String aqui)
///   - clienteId           : Long
///   - clienteNome         : String
///   - endereco            : EnderecoDTO
///   - descricao           : String
///   - dataVisita          : String (ISO “yyyy-MM-dd”)
///   - fotos               : List<String>
///   - videos              : List<String>
///   - usadaEmOrcamento    : bool
class Visita {
  final String id;
  final int clienteId;
  final String clienteNome;
  final EnderecoDTO endereco;
  final String descricao;
  final String dataVisita; // ISO “yyyy-MM-dd”
  final List<String> fotos; // Lista de URLs ou paths de fotos
  final List<String> videos; // Lista de URLs ou paths de vídeos
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
    // “cliente” no JSON é um objeto com “id” e “nome”
    final clienteJson = json['cliente'] as Map<String, dynamic>? ?? {};
    final fotosJson = json['fotos'] as List<dynamic>? ?? [];
    final videosJson = json['videos'] as List<dynamic>? ?? [];
    final enderecoJson = json['endereco'] as Map<String, dynamic>? ?? {};

    return Visita(
      id: json['id'].toString(),
      clienteId: (clienteJson['id'] as num?)?.toInt() ?? 0,
      clienteNome: clienteJson['nome'] as String? ?? '',
      endereco: EnderecoDTO.fromJson(enderecoJson),
      descricao: json['descricao'] as String? ?? '',
      dataVisita: json['dataVisita'] as String? ?? '',
      fotos: fotosJson.map((e) => e as String).toList(),
      videos: videosJson.map((e) => e as String).toList(),
      usadaEmOrcamento: json['usadaEmOrcamento'] as bool? ?? false,
    );
  }

  /// Monta o JSON para envio na criação/atualização:
  /// - O back-end espera um VisitaTecnicaCadastroDTO, que define:
  ///     clienteId   : Long
  ///     endereco    : EnderecoDTO
  ///     descricao   : String
  ///     dataVisita  : String (ISO)
  ///     fotos       : List<String>
  ///     videos      : List<String>
  ///
  /// Obtenha o Map a ser convertido em JSON chamando este método.
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
