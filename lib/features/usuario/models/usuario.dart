class Usuario {
  final String id;
  final String nome;
  final String documento;
  final bool ativo;

  Usuario({
    required this.id,
    required this.nome,
    required this.documento,
    required this.ativo,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'].toString(),
      nome: json['nome'] as String,
      documento: json['documento'] as String,
      ativo: json['ativo'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'nome': nome, 'documento': documento, 'ativo': ativo};
  }
}
