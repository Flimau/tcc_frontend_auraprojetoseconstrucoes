import 'package:flutter/material.dart';

import '../../../shared/services/obra_service.dart';
import '../models/obra.dart';

class ObraCadastroController extends ChangeNotifier {
  final ObraService _service = ObraService();

  final TextEditingController clienteIdController = TextEditingController();
  final TextEditingController orcamentoIdController = TextEditingController();
  final TextEditingController dataInicioController = TextEditingController();
  final TextEditingController dataFimController = TextEditingController();
  final TextEditingController contratoUrlController = TextEditingController();
  final TextEditingController executorIdController = TextEditingController();

  int? obraIdExistente;
  String statusExistente = 'PLANEJADA'; // default para novo

  bool isLoading = false;

  final List<String> statusObra = [
    'PLANEJADA',
    'EM_ANDAMENTO',
    'CONCLUIDA',
    'CANCELADA',
  ];

  

  Future<void> carregarObraExistente(int id) async {
    isLoading = true;
    notifyListeners();
    try {
      final obra = await _service.buscarObraPorId(id);
      obraIdExistente = obra.id;
      clienteIdController.text = obra.clienteId.toString();
      orcamentoIdController.text = obra.orcamentoId.toString();
      dataInicioController.text = obra.dataInicio;
      dataFimController.text = obra.dataFim;
      contratoUrlController.text = obra.contratoUrl ?? '';
      executorIdController.text = obra.executorId?.toString() ?? '';
      statusExistente = obra.status;
    } catch (_) {
      obraIdExistente = null;
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> salvarObra(BuildContext context) async {
    final cliId = int.tryParse(clienteIdController.text.trim());
    final orcId = int.tryParse(orcamentoIdController.text.trim());
    final dataIni = dataInicioController.text.trim();
    final dataFi = dataFimController.text.trim();
    if (cliId == null || orcId == null || dataIni.isEmpty || dataFi.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preencha todos os campos obrigatórios.')),
      );
      return;
    }
    isLoading = true;
    notifyListeners();

    // Monta o objeto Obra
    final obra = Obra(
      id: obraIdExistente,
      clienteId: cliId,
      clienteNome: '', // o back retorna, não enviamos aqui
      orcamentoId: orcId,
      status: statusExistente,
      dataInicio: dataIni,
      dataFim: dataFi,
      contratoUrl:
          contratoUrlController.text.trim().isEmpty
              ? null
              : contratoUrlController.text.trim(),
      executorId:
          executorIdController.text.trim().isEmpty
              ? null
              : int.parse(executorIdController.text.trim()),
      executorNome: null,
    );

    try {
      if (obraIdExistente == null) {
        // Cria nova obra
        await _service.criarObra(obra);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Obra criada com sucesso.')));
      } else {
        // Atualiza obra existente (sem mudar status aqui)
        await _service.atualizarObra(obraIdExistente!, obra);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Obra atualizada com sucesso.')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar obra: ${e.toString()}')),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

}
