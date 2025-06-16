class ContratoDTO {
  final int? id;
  final int orcamentoId;
  final DateTime? dataInicio;
  final DateTime? dataFim;

  ContratoDTO({
    this.id,
    required this.orcamentoId,
    this.dataInicio,
    this.dataFim,
  });

  factory ContratoDTO.fromJson(Map<String, dynamic> json) {
    return ContratoDTO(
      id: json['id'],
      orcamentoId: json['orcamentoId'],
      dataInicio: json['dataInicio'] != null ? DateTime.parse(json['dataInicio']) : null,
      dataFim: json['dataFim'] != null ? DateTime.parse(json['dataFim']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'orcamentoId': orcamentoId,
      if (dataInicio != null) 'dataInicio': dataInicio!.toIso8601String(),
      if (dataFim != null) 'dataFim': dataFim!.toIso8601String(),
    };
  }
}
