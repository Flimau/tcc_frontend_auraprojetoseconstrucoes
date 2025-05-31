// orcamento_cadastro_controller.dart
import 'package:flutter/material.dart';

class OrcamentoCadastroController extends ChangeNotifier {
  final TextEditingController descritivoController = TextEditingController();
  final TextEditingController enderecoController = TextEditingController();
  final TextEditingController nomeItemController = TextEditingController();
  final TextEditingController valorItemController = TextEditingController();
  final TextEditingController quantidadeController = TextEditingController();

  String? tipoOrcamentoSelecionado;
  bool comMaterial = false;

  final List<Map<String, dynamic>> itensMaterial = [];

  void adicionarItem() {
    itensMaterial.add({
      'nome': nomeItemController.text,
      'valor': double.tryParse(valorItemController.text) ?? 0.0,
      'quantidade': int.tryParse(quantidadeController.text) ?? 1,
    });

    nomeItemController.clear();
    valorItemController.clear();
    quantidadeController.clear();

    notifyListeners();
  }

  double get totalOrcamento {
    if (!comMaterial) return 0.0;

    return itensMaterial.fold(0.0, (total, item) {
      return total + (item['valor'] * item['quantidade']);
    });
  }

  void salvarOrcamento(BuildContext context, Function mostrarMensagem) {
    // Aqui tu pode implementar a lógica de envio para a API
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(mostrarMensagem('Orçamento salvo com sucesso!'));
  }

  void toggleComMaterial(bool? value) {
    comMaterial = value ?? false;
    notifyListeners();
  }

  void setTipoOrcamento(String? value) {
    tipoOrcamentoSelecionado = value;
    notifyListeners();
  }
}
