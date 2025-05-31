import 'package:flutter/material.dart';

class ObraCadastroController extends ChangeNotifier {
  final nomeObraController = TextEditingController();
  final enderecoController = TextEditingController();
  final clienteController = TextEditingController(); // nome ou ID do cliente
  final orcamentoController = TextEditingController(); // vincular orçamento

  // Campos opcionais, como status
  String status = 'PENDENTE';

  final List<String> statusObra = [
    'PENDENTE',
    'EM ANDAMENTO',
    'PAUSADA',
    'CONCLUÍDA',
  ];

  void atualizarStatus(String novoStatus) {
    status = novoStatus;
    notifyListeners();
  }

  void salvarObra(BuildContext context, Function mostrarMensagem) {
    // Aqui futuramente vai chamada à API

    mostrarMensagem(context, 'Obra salva com sucesso!');
  }
}
