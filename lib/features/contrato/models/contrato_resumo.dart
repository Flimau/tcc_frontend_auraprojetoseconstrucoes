class ContratoResumo {
  final int id;
  final int orcamentoId;
  final int clienteId;
  final String clienteNome;

  ContratoResumo({
    required this.id,
    required this.orcamentoId,
    required this.clienteId,
    required this.clienteNome,
  });

  factory ContratoResumo.fromJson(Map<String, dynamic> json) {
    return ContratoResumo(
      id: json['id'],
      orcamentoId: json['orcamentoId'],
      clienteId: json['clienteId'],
      clienteNome: json['clienteNome'],
    );
  }
}
