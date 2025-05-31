import 'package:flutter/material.dart';

class ContratoCadastroController extends ChangeNotifier {
  final clienteController = TextEditingController();
  final obraController = TextEditingController();
  final orcamentoController = TextEditingController();
  final valorTotalController = TextEditingController();
  final dataInicioController = TextEditingController();
  final dataFimController = TextEditingController();

  String statusContrato = 'EM ABERTO';

  final List<String> statusDisponiveis = [
    'EM ABERTO',
    'EM EXECUÇÃO',
    'FINALIZADO',
    'CANCELADO',
  ];

  void atualizarStatus(String novoStatus) {
    statusContrato = novoStatus;
    notifyListeners();
  }

  void salvarContrato(BuildContext context, Function mostrarMensagem) {
    // Aqui entraria a lógica de integração com backend

    mostrarMensagem(context, 'Contrato salvo com sucesso!');
  }
}
