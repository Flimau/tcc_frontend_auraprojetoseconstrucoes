// lib/features/agenda/models/agenda_item.dart

class AgendaItem {
  final int? id;
  final String titulo;
  final String descricao;
  final DateTime data;
  final String horario;

  AgendaItem({
    this.id,
    required this.titulo,
    required this.descricao,
    required this.data,
    required this.horario,
  });

  factory AgendaItem.fromJson(Map<String, dynamic> json) {
    return AgendaItem(
      id: (json['id'] as num).toInt(),
      titulo: json['titulo'] as String,
      descricao: json['descricao'] as String,
      data: DateTime.parse(json['data'] as String),
      horario: json['horario'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'data': data.toIso8601String(),
      'horario': horario,
    };
  }
}
