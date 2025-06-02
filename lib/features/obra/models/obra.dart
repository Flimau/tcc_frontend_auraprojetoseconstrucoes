class Obra {
  final String id;
  final int clienteId;
  final String clienteNome;
  final int orcamentoId;
  final int? executorId;
  final String? executorNome;
  final String status;
  final String dataInicio;
  final String dataFim;
  final String? contratoUrl;

  Obra({
    required this.id,
    required this.clienteId,
    required this.clienteNome,
    required this.orcamentoId,
    this.executorId,
    this.executorNome,
    required this.status,
    required this.dataInicio,
    required this.dataFim,
    this.contratoUrl,
  });

  factory Obra.fromJson(Map<String, dynamic> json) {
    return Obra(
      id: json['id'].toString(),
      clienteId: json['clienteId'] as int,
      clienteNome: json['clienteNome'] as String,
      orcamentoId: json['orcamentoId'] as int,
      executorId: json['executorId'] != null ? json['executorId'] as int : null,
      executorNome:
          json['executorNome'] != null ? json['executorNome'] as String : null,
      status: json['status'] as String,
      dataInicio: json['dataInicio'] as String,
      dataFim: json['dataFim'] as String,
      contratoUrl:
          json['contratoUrl'] != null ? json['contratoUrl'] as String : null,
    );
  }
}
