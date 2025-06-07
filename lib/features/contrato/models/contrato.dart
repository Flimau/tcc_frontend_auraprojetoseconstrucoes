// lib/features/contrato/models/contrato.dart

/// Representa o contrato completo (para edição).
class Contrato {
  final int? id;
  final int orcamentoId;
  final DateTime? dataInicio;
  final DateTime? dataFim;
  final String? status;
  final double? valorTotal;
  final int? clienteId;
  final String? clienteNome;

  Contrato({
    this.id,
    required this.orcamentoId,
    this.dataInicio,
    this.dataFim,
    this.status,
    this.valorTotal,
    this.clienteId,
    this.clienteNome,
  });

  factory Contrato.fromResumoJson(Map<String, dynamic> json) {
    // Para listagem (ContratoResumoDTO)
    return Contrato(
      id: (json['id'] as num).toInt(),
      orcamentoId: (json['orcamentoId'] as num).toInt(),
      clienteId: (json['clienteId'] as num).toInt(),
      clienteNome: json['clienteNome'] as String,
      status: json['status'] as String,
    );
  }

  factory Contrato.fromJson(Map<String, dynamic> json) {
    // Para o DTO completo (ContratoDTO)
    DateTime? parseDate(String? s) => s == null ? null : DateTime.parse(s);
    return Contrato(
      id: (json['id'] as num).toInt(),
      orcamentoId: (json['orcamentoId'] as num).toInt(),
      dataInicio: parseDate(json['dataInicio'] as String?),
      dataFim: parseDate(json['dataFim'] as String?),
      status: json['status'] as String?,
      valorTotal: (json['valorTotal'] as num?)?.toDouble(),
      // Não há campo clienteId/nome no DTO completo, mas podemos opcionalmente
      // deixá-los como nulos. Se quiser, o backend pode incluir.
    );
  }

  Map<String, dynamic> toJson() {
    String? fmtDate(DateTime? d) => d == null ? null : d.toIso8601String();
    return {
      'id': id,
      'orcamentoId': orcamentoId,
      'dataInicio': fmtDate(dataInicio),
      'dataFim': fmtDate(dataFim),
      'status': status,
      'valorTotal': valorTotal,
    };
  }

  Contrato copyWith({
    int? id,
    int? orcamentoId,
    DateTime? dataInicio,
    DateTime? dataFim,
    String? status,
    double? valorTotal,
    int? clienteId,
    String? clienteNome,
  }) {
    return Contrato(
      id: id ?? this.id,
      orcamentoId: orcamentoId ?? this.orcamentoId,
      dataInicio: dataInicio ?? this.dataInicio,
      dataFim: dataFim ?? this.dataFim,
      status: status ?? this.status,
      valorTotal: valorTotal ?? this.valorTotal,
      clienteId: clienteId ?? this.clienteId,
      clienteNome: clienteNome ?? this.clienteNome,
    );
  }
}
