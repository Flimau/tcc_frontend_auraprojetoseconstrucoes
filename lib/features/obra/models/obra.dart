// lib/features/obra/models/obra.dart

class Obra {
  final int? id;
  final int clienteId;
  final String clienteNome;
  final int orcamentoId;
  final String status;
  final String dataInicio; // “YYYY-MM-DD”
  final String dataFim; // “YYYY-MM-DD”
  final String? contratoUrl;
  final int? executorId;
  final String? executorNome;

  Obra({
    this.id,
    required this.clienteId,
    required this.clienteNome,
    required this.orcamentoId,
    required this.status,
    required this.dataInicio,
    required this.dataFim,
    this.contratoUrl,
    this.executorId,
    this.executorNome,
  });

  factory Obra.fromDtoJson(Map<String, dynamic> json) {
    return Obra(
      id: (json['id'] as num).toInt(),
      clienteId: (json['clienteId'] as num).toInt(),
      clienteNome: json['clienteNome'] as String,
      orcamentoId: (json['orcamentoId'] as num).toInt(),
      status: json['status'] as String,
      dataInicio: json['dataInicio'] as String,
      dataFim: json['dataFim'] as String,
      contratoUrl: json['contratoUrl'] as String?,
      executorId:
          json['executorId'] != null
              ? (json['executorId'] as num).toInt()
              : null,
      executorNome: json['executorNome'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cliente': {'id': clienteId},
      'orcamento': {'id': orcamentoId},
      'dataInicio': dataInicio,
      'dataFim': dataFim,
      if (contratoUrl != null) 'contratoUrl': contratoUrl,
      if (executorId != null) 'executor': {'id': executorId},
    };
  }

  Obra copyWith({String? status}) {
    return Obra(
      id: id,
      clienteId: clienteId,
      clienteNome: clienteNome,
      orcamentoId: orcamentoId,
      status: status ?? this.status,
      dataInicio: dataInicio,
      dataFim: dataFim,
      contratoUrl: contratoUrl,
      executorId: executorId,
      executorNome: executorNome,
    );
  }
}
