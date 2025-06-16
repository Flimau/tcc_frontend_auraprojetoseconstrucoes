import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../constants/constants.dart';
import '../../../theme/theme.dart';
import '../../shared/services/http_client_utf8.dart';

class TelaVisualizarObra extends StatefulWidget {
  final int? obraId;
  const TelaVisualizarObra({super.key, this.obraId});

  @override
  State<TelaVisualizarObra> createState() => _TelaVisualizarObraState();
}

class _TelaVisualizarObraState extends State<TelaVisualizarObra> {
  String nomeCliente = '';
  String statusObra = '';
  String? executor;
  String dataIniObra = '';
  String dataFimObra = '';

  static final _client = HttpClientUtf8();

  @override
  void initState() {
    super.initState();
    carregarObra(widget.obraId!);
  }

  Future<void> carregarObra(int id) async {
    final url = Uri.parse("${AppConstants.baseUrl}/api/obras/$id");
    final resp = await _client.get(url);
    if (resp.statusCode == 200) {
      final data = json.decode(resp.body);
      setState(() {
        nomeCliente = data['nomeCliente'] ?? '';
        statusObra = data['status'] ?? '';
        executor = data['nomeExecutor'] ?? '-';
        dataIniObra = data['dataInicio'] ?? '';
        dataFimObra = data['dataFim'] ?? '';
      });
    }
  }

  Future<Map<String, dynamic>> buscarObraDetalhada() async {
    final url = Uri.parse("${AppConstants.baseUrl}/api/obras/${widget.obraId}");
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      return json.decode(resp.body);
    } else {
      throw Exception("Erro ao buscar obra detalhada.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text("Detalhes da Obra", style: AppTextStyles.headline),
        iconTheme: const IconThemeData(color: AppColors.accent),
      ),
      body: Padding(padding: const EdgeInsets.all(24), child: _cabecalhoObra()),
    );
  }

  Widget _cabecalhoObra() {
    final dataIni = _formatarData(dataIniObra);
    final dataFim = _formatarData(dataFimObra);
    return Container(
      decoration: AppTheme.cardBox,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Cliente: $nomeCliente", style: AppTextStyles.body),
          Text("Executor: ${executor ?? '—'}", style: AppTextStyles.body),
          Text("Status: $statusObra", style: AppTextStyles.body),
          Text("Data início previsto: $dataIni", style: AppTextStyles.body),
          Text("Data conclusão prevista: $dataFim", style: AppTextStyles.body),
          const SizedBox(height: 20),
          _buildAcaoObra(),
        ],
      ),
    );
  }

  Widget _buildAcaoObra() {
    if (statusObra == 'PLANEJADA') {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD4AF37),
        ),
        onPressed: () async {
          final obraDetalhada = await buscarObraDetalhada();
          _abrirDialogIniciarObra(obraDetalhada);
        },
        child: const Text("Iniciar Obra"),
      );
    }

    if (statusObra == 'EM_ANDAMENTO') {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD4AF37),
        ),
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/tela_acompanhamento_obra',
            arguments: widget.obraId,
          );
        },
        child: const Text("Acompanhamento de Obra"),
      );
    }

    return const SizedBox.shrink();
  }

  void _abrirDialogIniciarObra(Map<String, dynamic> obraDetalhada) {
    DateTime? dataInicio;
    DateTime? dataFim;

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Iniciar Obra'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDatePickerButton(
                    label: 'Selecionar Início',
                    selectedDate: dataInicio,
                    onDateSelected: (date) => setState(() => dataInicio = date),
                  ),
                  _buildDatePickerButton(
                    label: 'Selecionar Fim',
                    selectedDate: dataFim,
                    onDateSelected: (date) => setState(() => dataFim = date),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancelar"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (dataInicio != null && dataFim != null) {
                      _salvarInicioObra(dataInicio!, dataFim!);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Salvar"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildDatePickerButton({
    required String label,
    required DateTime? selectedDate,
    required Function(DateTime) onDateSelected,
  }) {
    return ElevatedButton(
      child: Text(
        selectedDate == null
            ? label
            : DateFormat("dd/MM/yyyy").format(selectedDate),
      ),
      onPressed: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2023),
          lastDate: DateTime(2030),
        );
        if (date != null) {
          onDateSelected(date);
        }
      },
    );
  }

  void _salvarInicioObra(DateTime inicio, DateTime fim) async {
    final dto = {
      "dataInicio": inicio.toIso8601String().split("T").first,
      "dataFim": fim.toIso8601String().split("T").first,
      "status": "EM_ANDAMENTO",
    };

    final url = Uri.parse(
      "${AppConstants.baseUrl}/api/obras/${widget.obraId}/iniciar",
    );
    final resp = await http.patch(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(dto),
    );

    if (resp.statusCode == 200 || resp.statusCode == 204) {
      await carregarObra(widget.obraId!);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Erro ao iniciar obra.")));
    }
  }

  String _formatarData(String? data) {
    if (data == null || data.isEmpty) return "—";
    try {
      final date = DateTime.parse(data);
      return DateFormat("dd/MM/yyyy").format(date);
    } catch (_) {
      return data;
    }
  }
}
