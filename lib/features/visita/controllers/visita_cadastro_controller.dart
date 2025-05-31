import 'package:flutter/material.dart';

class VisitaCadastroController extends ChangeNotifier {
  final dataVisitaController = TextEditingController();
  final enderecoController = TextEditingController();
  final descricaoController = TextEditingController();
  final metragemController = TextEditingController();
  final necessidadesController = TextEditingController();
  final observacoesController = TextEditingController();

  // Futuro suporte a imagens/vídeos
  final List<String> midias = []; // paths ou urls simuladas

  void salvarVisita(BuildContext context, Function mostrarMensagem) {
    // Aqui entraria integração com backend
    mostrarMensagem(context, 'Visita registrada com sucesso!');
  }

  void adicionarMidia(String midia) {
    midias.add(midia);
    notifyListeners();
  }
}
