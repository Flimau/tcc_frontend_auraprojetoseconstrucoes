class OrcamentoItem {
  
  final int? id;
  final String descricao;
  final int quantidade;
  final double valorUnitario;
  final double? subtotal;

  OrcamentoItem({
    this.id,
    required this.descricao,
    required this.quantidade,
    required this.valorUnitario,
    this.subtotal,
  });

  factory OrcamentoItem.fromJson(Map<String, dynamic> json) {
    return OrcamentoItem(
      id: json['id'] != null ? (json['id'] as num).toInt() : null,
      descricao: json['descricao'] as String,
      quantidade: (json['quantidade'] as num).toInt(),
      valorUnitario: (json['valorUnitario'] as num).toDouble(),
      subtotal:
          json['subtotal'] != null
              ? (json['subtotal'] as num).toDouble()
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'descricao': descricao,
      'quantidade': quantidade,
      'valorUnitario': valorUnitario,
      if (subtotal != null) 'subtotal': subtotal,
    };
  }
}
class Orcamento {
  final int id;
  final int clienteId;
  final String clienteNome;
  final int? visitaId;
  final String descricao;
  final String tipo;
  final String subtipo;
  final bool comMaterial;
  final List<OrcamentoItem> itens;
  final DateTime dataCriacao;
  final double totalOrcamento;

  Orcamento({
    required this.id,
    required this.clienteId,
    required this.clienteNome,
    this.visitaId,
    required this.descricao,
    required this.tipo,
    required this.subtipo,
    required this.comMaterial,
    required this.itens,
    required this.dataCriacao,
    required this.totalOrcamento,
  });

  factory Orcamento.fromJson(Map<String, dynamic> json) {
    final itensJson =
        (json['itens'] as List<dynamic>?)
            ?.map(
              (item) => OrcamentoItem.fromJson(item as Map<String, dynamic>),
            )
            .toList() ??
        [];

    return Orcamento(
      id: (json['id'] as num).toInt(),
      clienteId: (json['clienteId'] as num).toInt(),
      clienteNome: json['clienteNome'] as String,
      visitaId:
          json['visitaId'] != null ? (json['visitaId'] as num).toInt() : null,
      descricao: json['descricao'] as String,
      tipo: json['tipo'] as String,
      subtipo: json['subtipo'] as String,
      comMaterial: json['comMaterial'] as bool,
      totalOrcamento: json['valorTotal'] as double,
      itens: itensJson,
      dataCriacao: DateTime.parse(json['dataCriacao'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clienteId': clienteId,
      'clienteNome': clienteNome,
      if (visitaId != null) 'visitaId': visitaId,
      'descricao': descricao,
      'tipo': tipo,
      'subtipo': subtipo,
      'comMaterial': comMaterial,
      'itens': itens.map((i) => i.toJson()).toList(),
      'dataCriacao': dataCriacao.toIso8601String(),
    };
  }

  Map<String, dynamic> toCadastroJson() {
    return {
      'clienteId': clienteId,
      if (visitaId != null) 'visitaId': visitaId,
      'descricao': descricao,
      'tipo': tipo,
      'subtipo': subtipo,
      'comMaterial': comMaterial,
      'itens':
          itens
              .map(
                (i) => {
                  'descricao': i.descricao,
                  'quantidade': i.quantidade,
                  'valorUnitario': i.valorUnitario,
                },
              )
              .toList(),
      'totalOrcamento': totalOrcamento,
    };
  }
}
