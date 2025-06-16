// lib/features/orcamento/models/orcamento.dart

/// Representa um item de orçamento (equivalente a OrcamentoItemDTO no back).
class OrcamentoItem {
  /// ID do item (pode vir null no momento de criar, pois o back gera o ID).
  final int? id;

  /// Descrição do item (ex.: “Tijolo Cerâmico 6 furos”).
  final String descricao;

  /// Quantidade do item.
  final int quantidade;

  /// Valor unitário (ex.: 5.50).
  final double valorUnitario;

  /// Subtotal calculado (quantidade * valorUnitario).
  /// No back, é calculado automaticamente, mas recebemos no JSON.
  final double? subtotal;

  OrcamentoItem({
    this.id,
    required this.descricao,
    required this.quantidade,
    required this.valorUnitario,
    this.subtotal,
  });

  /// Constrói OrcamentoItem a partir de um JSON (Map<String, dynamic>).
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

  /// Converte OrcamentoItem para um JSON (Map<String, dynamic>).
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'descricao': descricao,
      'quantidade': quantidade,
      'valorUnitario': valorUnitario,
      // subtotal geralmente não enviamos no cadastro, pois o back calcula.
      if (subtotal != null) 'subtotal': subtotal,
    };
  }
}

/// Representa o orçamento completo (equivalente a OrcamentoDTO no back).
class Orcamento {
  /// ID do orçamento (gerado pelo banco).
  final int id;

  /// ID do cliente associado.
  final int clienteId;

  /// Nome do cliente (campo informado pelo back).
  final String clienteNome;

  /// ID da visita técnica (pode ser null).
  final int? visitaId;

  /// Descrição geral do orçamento.
  final String descricao;

  /// Tipo do orçamento (ex.: "PROJETO", "REFORMA", conforme enum TipoOrcamento).
  final String tipo;

  /// Subtipo do orçamento (ex.: "ARQUITETONICO", "BANHEIRO", conforme enum SubtipoOrcamento).
  final String subtipo;

  /// Se true, significa que existem itens de material.
  final bool comMaterial;

  /// Lista de itens do orçamento.
  final List<OrcamentoItem> itens;

  /// Data de criação, recebida como ISO 8601 pelo back.
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

  /// Constrói Orcamento a partir de um JSON (Map<String, dynamic>).
  factory Orcamento.fromJson(Map<String, dynamic> json) {
    // Parse da lista de itens (pode ser vazia)
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

  /// Converte Orcamento completo para JSON (Map<String, dynamic>).
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

  /// Converte o objeto para o formato de envio (OrcamentoCadastroDTO).
  ///
  /// Este método retorna somente os campos que o back espera no POST/PUT:
  /// {
  ///   clienteId: ...,
  ///   visitaId: ...,
  ///   descricao: ...,
  ///   tipo: ...,
  ///   subtipo: ...,
  ///   comMaterial: ...,
  ///   itens: [ { descricao, quantidade, valorUnitario }, ... ]
  /// }
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
