import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:front_application/shared/components/botao_padrao.dart';
//import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../constants/constants.dart';
import '../../../theme/theme.dart';
import '../../shared/services/http_client_utf8.dart';

class Obra {
  final int id;
  final String nomeCliente;
  final String? nomeExecutor;
  final String? dataInicio;
  final String? dataFim;
  final String status;

  Obra({
    required this.id,
    required this.nomeCliente,
    this.nomeExecutor,
    this.dataInicio,
    this.dataFim,
    required this.status,
  });

  factory Obra.fromJson(Map<String, dynamic> json) {
    return Obra(
      id: json['id'],
      nomeCliente: json['nomeCliente'] ?? '',
      nomeExecutor: json['nomeExecutor'],
      dataInicio: json['dataInicio'],
      dataFim: json['dataFim'],
      status: json['status'] ?? '',
    );
  }
}

class ObraListController extends ChangeNotifier {
  List<Obra> obras = [];
  bool carregando = true;
  final clienteFiltroController = TextEditingController();
  static final _client = HttpClientUtf8();

  Future<void> carregarObras() async {
    carregando = true;
    notifyListeners();

    final url = Uri.parse('${AppConstants.baseUrl}/api/obras');
    final response = await _client.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      obras = data.map((e) => Obra.fromJson(e)).toList();
    } else {
      obras = [];
    }

    carregando = false;
    notifyListeners();
  }

  Future<void> buscarObrasPorCliente() async {
    carregando = true;
    notifyListeners();

    final filtro = clienteFiltroController.text.trim();
    final url =
        filtro.isEmpty
            ? Uri.parse('${AppConstants.baseUrl}/api/obras')
            : Uri.parse(
              '${AppConstants.baseUrl}/api/obras/buscar-por-cliente?nomeCliente=${Uri.encodeComponent(filtro)}',
            );

    final response = await _client.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      obras = data.map((e) => Obra.fromJson(e)).toList();
    } else {
      obras = [];
    }

    carregando = false;
    notifyListeners();
  }

  Future<void> deletarObra(int id, BuildContext context) async {
    final url = Uri.parse('${AppConstants.baseUrl}/api/obras/$id');
    final response = await _client.delete(url);

    if (response.statusCode == 200 || response.statusCode == 204) {
      obras.removeWhere((obra) => obra.id == id);
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Obra deletada com sucesso")),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Erro ao deletar obra")));
    }
  }
}

class TelaListarObras extends StatelessWidget {
  const TelaListarObras({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ObraListController()..carregarObras(),
      child: Consumer<ObraListController>(
        builder: (context, controller, _) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.primary,
              title: const Text(
                "Listagem de Obras",
                style: AppTextStyles.headline,
              ),
              iconTheme: const IconThemeData(color: AppColors.accent),
            ),
            body: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildFiltro(controller),
                  const SizedBox(height: 24),
                  Expanded(
                    child:
                        controller.carregando
                            ? const Center(child: CircularProgressIndicator())
                            : controller.obras.isEmpty
                            ? const Center(
                              child: Text("Nenhuma obra encontrada"),
                            )
                            : ListView.separated(
                              itemCount: controller.obras.length,
                              separatorBuilder:
                                  (_, __) => const SizedBox(height: 16),
                              itemBuilder: (context, index) {
                                final obra = controller.obras[index];
                                return Container(
                                  decoration: AppTheme.cardBox,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Obra #${obra.id}",
                                          style: AppTextStyles.headline,
                                        ),
                                        const SizedBox(height: 8),
                                        _linha("Cliente", obra.nomeCliente),
                                        _linha(
                                          "Executor",
                                          obra.nomeExecutor ?? "—",
                                        ),
                                        _linha("Status", obra.status),
                                        _linha(
                                          "Início",
                                          _formatarData(obra.dataInicio),
                                        ),
                                        _linha(
                                          "Fim",
                                          _formatarData(obra.dataFim),
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                Icons.visibility,
                                                color: AppColors.subtitle,
                                              ),
                                              tooltip: "Visualizar",
                                              onPressed: () {
                                                Navigator.pushNamed(
                                                  context,
                                                  '/tela_visualizar_obra',
                                                  arguments: obra.id,
                                                );
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.edit,
                                                color: AppColors.accent,
                                              ),
                                              tooltip: "Editar",
                                              onPressed: () {
                                                Navigator.pushNamed(
                                                  context,
                                                  '/tela_cadastro_obra',
                                                  arguments: obra.id,
                                                ).then(
                                                  (_) =>
                                                      controller
                                                          .carregarObras(),
                                                );
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.delete,
                                                color: AppColors.error,
                                              ),
                                              tooltip: "Excluir",
                                              onPressed:
                                                  () => _confirmarExclusao(
                                                    context,
                                                    controller,
                                                    obra.id,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.accent,
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/tela_cadastro_obra',
                ).then((_) => controller.carregarObras());
              },
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFiltro(ObraListController controller) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller.clienteFiltroController,
            style: AppTextStyles.body,
            decoration: InputDecoration(
              labelText: "Filtrar por Cliente",
              labelStyle: AppTextStyles.body,
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 12),
        BotaoPadrao(
          texto: ("Buscar"),
          onPressed: controller.buscarObrasPorCliente,
        ),
      ],
    );
  }

  Widget _linha(String label, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text("$label: $valor", style: AppTextStyles.body),
    );
  }

  void _confirmarExclusao(
    BuildContext context,
    ObraListController controller,
    int id,
  ) async {
    final confirma = await showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text("Confirmar exclusão"),
            content: const Text("Deseja realmente excluir esta obra?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text("Cancelar"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text("Excluir"),
              ),
            ],
          ),
    );
    if (confirma == true) {
      controller.deletarObra(id, context);
    }
  }

  String _formatarData(String? data) {
    if (data == null) return "—";
    try {
      final date = DateTime.parse(data);
      return DateFormat("dd/MM/yyyy").format(date);
    } catch (_) {
      return data;
    }
  }
}
