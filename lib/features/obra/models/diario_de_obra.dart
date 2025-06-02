class Diario {
  final String id;
  final int obraId;
  final String dataRegistro;
  final List<String> itens;
  final String? observacoes;

  Diario({
    required this.id,
    required this.obraId,
    required this.dataRegistro,
    required this.itens,
    this.observacoes,
  });

  factory Diario.fromJson(Map<String, dynamic> json) {
    return Diario(
      id: json['id'].toString(),
      obraId: json['obraId'] as int,
      dataRegistro: json['dataRegistro'] as String,
      itens: (json['itens'] as List<dynamic>).map((e) => e as String).toList(),
      observacoes:
          json['observacoes'] != null ? json['observacoes'] as String : null,
    );
  }
}
