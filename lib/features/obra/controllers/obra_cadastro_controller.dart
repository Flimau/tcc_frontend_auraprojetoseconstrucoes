import 'package:flutter/material.dart';

import '../../../shared/services/obra_service.dart';
import '../models/obra.dart';

class ObraCadastroController extends ChangeNotifier {
  /// Se null → estamos criando; se não null → estamos editando a obra de ID igual a obraId
  String? obraId;

  // Controllers para os campos do formulário (todos como texto, pois vêm de TextField)
  final clienteIdController = TextEditingController();
  final orcamentoIdController = TextEditingController();
  final executorIdController = TextEditingController(); // opcional

  final dataInicioController =
      TextEditingController(); // formato "DD/MM/AAAA" no input
  final dataFimController =
      TextEditingController(); // formato "DD/MM/AAAA" no input

  final contratoUrlController = TextEditingController(); // opcional

  // Campo status
  String status = 'PLANEJADA'; // default ao criar
  final List<String> statusObra = [
    'PLANEJADA',
    'EM_ANDAMENTO',
    'PENDENTE',
    'CONCLUIDA',
    'CANCELADA',
  ];

  bool carregando = false;
  String? erro; // mensagem de erro ao salvar
  String? sucesso; // mensagem de sucesso ao salvar

  ObraCadastroController({this.obraId});

  /// Se estivermos em modo "edição", carrega os dados da obra existente
  /// para popular os campos do formulário:
  Future<void> carregarObraParaEdicao() async {
    if (obraId == null) return;

    carregando = true;
    notifyListeners();

    try {
      final Obra obra = await ObraService.fetchObraById(obraId!);
      // Preenche controllers com valores atuais
      clienteIdController.text = obra.clienteId.toString();
      orcamentoIdController.text = obra.orcamentoId.toString();
      executorIdController.text = obra.executorId?.toString() ?? '';
      dataInicioController.text = _formatarDataDeTela(obra.dataInicio);
      dataFimController.text = _formatarDataDeTela(obra.dataFim);
      contratoUrlController.text = obra.contratoUrl ?? '';
      status = obra.status;
    } catch (e) {
      erro = 'Erro ao carregar dados da obra para edição: $e';
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  void atualizarStatus(String novoStatus) {
    status = novoStatus;
    notifyListeners();
  }

  /// Salva a obra: se obraId == null → CREATE; se não → UPDATE
  Future<void> salvarObra(
    BuildContext context,
    void Function(BuildContext, String, {bool erro}) mostrarMensagem,
  ) async {
    final String clienteIdText = clienteIdController.text.trim();
    final String orcamentoIdText = orcamentoIdController.text.trim();
    final String executorIdText = executorIdController.text.trim();
    final String dataInicioText = dataInicioController.text.trim();
    final String dataFimText = dataFimController.text.trim();
    final String contratoUrlText = contratoUrlController.text.trim();

    // 1) Validações básicas
    if (clienteIdText.isEmpty ||
        orcamentoIdText.isEmpty ||
        dataInicioText.isEmpty ||
        dataFimText.isEmpty) {
      mostrarMensagem(
        context,
        'Preencha todos os campos obrigatórios (cliente, orçamento, datas).',
        erro: true,
      );
      return;
    }

    final DateTime? dataInicioParsed = _parseData(dataInicioText);
    final DateTime? dataFimParsed = _parseData(dataFimText);

    if (dataInicioParsed == null || dataFimParsed == null) {
      mostrarMensagem(
        context,
        'Formato de data inválido (use DD/MM/AAAA).',
        erro: true,
      );
      return;
    }
    if (dataFimParsed.isBefore(dataInicioParsed)) {
      mostrarMensagem(
        context,
        'Data final não pode ser anterior à data inicial.',
        erro: true,
      );
      return;
    }

    // 2) Monta o payload JSON para enviar ao back
    Map<String, dynamic> payload = {
      'cliente': {'id': int.parse(clienteIdText)},
      'orcamento': {'id': int.parse(orcamentoIdText)},
      'dataInicio': _toIsoDate(dataInicioParsed),
      'dataFim': _toIsoDate(dataFimParsed),
      'contratoUrl': contratoUrlText.isNotEmpty ? contratoUrlText : null,
      'status':
          status, // sempre informamos o status (mesmo na criação, back já inicializa como PLANEJADA, mas aqui passamos explicitamente)
    };

    // Se houver executorId preenchido, adicionamos ao payload
    if (executorIdText.isNotEmpty) {
      payload['executor'] = {'id': int.parse(executorIdText)};
    }

    carregando = true;
    erro = null;
    sucesso = null;
    notifyListeners();

    try {
      Obra obraRetornada;
      if (obraId == null) {
        // Criação
        obraRetornada = await ObraService.createObra(payload);
        sucesso = 'Obra criada com sucesso! ID: ${obraRetornada.id}';
      } else {
        // Edição
        obraRetornada = await ObraService.updateObra(obraId!, payload);
        sucesso = 'Obra atualizada com sucesso!';

        // Se usuário alterou/selecionou executor, chamar endpoint específico de atribuição de executor
        if (executorIdText.isNotEmpty) {
          try {
            await ObraService.assignExecutor(obraId!, executorIdText);
          } catch (_) {
            // Se falhar ao atribuir executor, apenas mostramos mensagem de erro mas não interrompemos
            mostrarMensagem(
              context,
              'Obra atualizada, mas falha ao atribuir executor.',
              erro: true,
            );
          }
        }
      }

      // Exibe a mensagem de sucesso
      mostrarMensagem(context, sucesso!);

      // (Opcional) Aqui você pode limpar FORM ou navegar de volta, dependendo de como sua UI está estruturada
    } catch (e) {
      erro = 'Erro ao salvar obra: $e';
      mostrarMensagem(context, erro!, erro: true);
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  /// Converte string “DD/MM/AAAA” para DateTime ou retorna null se inválida
  DateTime? _parseData(String data) {
    try {
      final partes = data.split('/');
      return DateTime(
        int.parse(partes[2]),
        int.parse(partes[1]),
        int.parse(partes[0]),
      );
    } catch (_) {
      return null;
    }
  }

  /// Converte DateTime para “YYYY-MM-DD”
  String _toIsoDate(DateTime d) {
    final ano = d.year.toString().padLeft(4, '0');
    final mes = d.month.toString().padLeft(2, '0');
    final dia = d.day.toString().padLeft(2, '0');
    return '$ano-$mes-$dia';
  }

  /// Recebe uma data no formato ISO “YYYY-MM-DD” e converte para “DD/MM/AAAA”
  String _formatarDataDeTela(String isoDate) {
    try {
      final parts = isoDate.split('-'); // [YYYY, MM, DD]
      return '${parts[2].padLeft(2, '0')}/${parts[1].padLeft(2, '0')}/${parts[0]}';
    } catch (_) {
      return isoDate;
    }
  }
}
