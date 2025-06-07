// lib/features/obra/models/diario_de_obra.dart

class DiarioDeObra {
  final int id;
  final int obraId;
  final String dataRegistro; // “YYYY-MM-DD”
  final List<String> itens; // lista de strings
  final String? observacoes; // pode ser nulo

  const DiarioDeObra({
    required this.id,
    required this.obraId,
    required this.dataRegistro,
    required this.itens,
    this.observacoes,
  });

  factory DiarioDeObra.fromJson(Map<String, dynamic> json) {
    return DiarioDeObra(
      id: (json['id'] as num).toInt(),
      obraId: (json['obraId'] as num).toInt(),
      dataRegistro: json['dataRegistro'] as String,
      itens: (json['itens'] as List<dynamic>).map((e) => e as String).toList(),
      observacoes:
          json['observacoes'] != null ? json['observacoes'] as String : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dataRegistro': dataRegistro,
      'itens': itens,
      if (observacoes != null) 'observacoes': observacoes,
    };
  }
}
