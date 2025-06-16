enum StatusAcompanhamento { VAZIO, PREVISTO, CONCLUIDO, ATRASADO }

class AcompanhamentoCadastroDTO {
  final int? id;
  final int obraId;
  final DateTime dataRegistro;
  final List<String> tarefas;
  final List<String> tarefasConcluidas;
  final String? observacoes;

  AcompanhamentoCadastroDTO({
    this.id,
    required this.obraId,
    required this.dataRegistro,
    required this.tarefas,
    required this.tarefasConcluidas,
    this.observacoes,
  });

  factory AcompanhamentoCadastroDTO.fromJson(Map<String, dynamic> json) {
    return AcompanhamentoCadastroDTO(
      id: json['id'],
      obraId: json['obraId'],
      dataRegistro: DateTime.parse(json['dataRegistro']),
      tarefas: List<String>.from(json['tarefas']),
      tarefasConcluidas: List<String>.from(json['tarefasConcluidas']),
      observacoes: json['observacoes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'obraId': obraId,
      'dataRegistro': dataRegistro.toIso8601String(),
      'tarefas': tarefas,
      'tarefasConcluidas': tarefasConcluidas,
      'observacoes': observacoes,
    };
  }
}

class AcompanhamentoListagemDTO {
  final int id;
  final DateTime dataRegistro;
  final StatusAcompanhamento status;

  AcompanhamentoListagemDTO({
    required this.id,
    required this.dataRegistro,
    required this.status,
  });

  factory AcompanhamentoListagemDTO.fromJson(Map<String, dynamic> json) {
    return AcompanhamentoListagemDTO(
      id: json['id'],
      dataRegistro: DateTime.parse(json['dataRegistro']),
      status: StatusAcompanhamento.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
      ),
    );
  }
}
