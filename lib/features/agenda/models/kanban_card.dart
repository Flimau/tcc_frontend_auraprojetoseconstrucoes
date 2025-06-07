class KanbanCard {
  final int? id;
  final String titulo;
  final String descricao;
  final String status; // "TODO", "IN_PROGRESS", "DONE"

  KanbanCard({
    this.id,
    required this.titulo,
    required this.descricao,
    required this.status,
  });

  factory KanbanCard.fromJson(Map<String, dynamic> json) {
    return KanbanCard(
      id: (json['id'] as num).toInt(),
      titulo: json['titulo'] as String,
      descricao: json['descricao'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'status': status,
    };
  }

  KanbanCard copyWith({String? status}) {
    return KanbanCard(
      id: id,
      titulo: titulo,
      descricao: descricao,
      status: status ?? this.status,
    );
  }
}
