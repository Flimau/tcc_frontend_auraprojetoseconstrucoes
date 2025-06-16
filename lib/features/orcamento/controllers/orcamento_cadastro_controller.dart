// lib/features/orcamento/controllers/orcamento_cadastro_controller.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:front_application/constants/constants.dart';
import 'package:front_application/features/orcamento/models/orcamento.dart';
import 'package:front_application/features/usuario/models/usuario.dart';
import 'package:front_application/features/visita/models/visita.dart';
import 'package:front_application/shared/services/orcamento_service.dart';
import 'package:front_application/shared/services/visita_service.dart';
import 'package:http/http.dart' as http;

class OrcamentoCadastroController extends ChangeNotifier {
  final int? orcamentoId;
  DateTime? dataSelecionada = DateTime.now();

  final clienteIdController = TextEditingController();
  final visitaIdController = TextEditingController();
  final descricaoController = TextEditingController();

  String? tipoSelecionado;
  String? subtipoSelecionado;
  bool comMaterial = false;
  double totalOrcamento = 0;

  final List<OrcamentoItem> itens = [];

  List<Usuario> clientes = [];
  bool carregandoClientes = false;
  String? erroClientes;

  List<Visita> visitas = [];
  bool carregandoVisitas = false;
  String? erroVisitas;

  final List<String> tipos = [
    'PROJETO',
    'REFORMA',
    'CONSTRUCAO',
    'DRYWALL',
    'ACABAMENTO',
  ];
  final Map<String, List<String>> subtiposPorTipo = {
    'PROJETO': ['ARQUITETONICO', 'INTERIORES', 'REGULARIZACAO'],
    'REFORMA': [
      'BANHEIRO',
      'COZINHA',
      'LAVANDERIA',
      'SALA',
      'DORMITORIO',
      'COMERCIAL',
    ],
    'CONSTRUCAO': [],
    'DRYWALL': ['FORRO', 'PAREDE', 'AMBOS'],
    'ACABAMENTO': ['PISO', 'PINTURA', 'RODAPE', 'REVESTIMENTO'],
  };

  bool carregando = false;
  String? erro;
  String? sucesso;

  bool _isDisposed = false;

  OrcamentoCadastroController({this.orcamentoId}) {
    _fetchClientes();
    _fetchVisitas();
    if (orcamentoId != null) {
      _fetchOrcamentoParaEdicao(orcamentoId!);
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    clienteIdController.dispose();
    visitaIdController.dispose();
    descricaoController.dispose();
    super.dispose();
  }

  void _safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  Future<void> _fetchClientes() async {
    carregandoClientes = true;
    erroClientes = null;
    _safeNotify();

    try {
      final uri = Uri.parse(
        '${AppConstants.baseUrl}/api/usuario/listar',
      ).replace(queryParameters: {'tipoUsuario': 'CLIENTE'});
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> listaJson = json.decode(response.body);
        clientes = listaJson.map((json) => Usuario.fromJson(json)).toList();
      } else {
        erroClientes =
            'Erro ao carregar clientes: código ${response.statusCode}';
        clientes = [];
      }
    } catch (e) {
      erroClientes = 'Erro de rede ao carregar clientes: $e';
      clientes = [];
    } finally {
      carregandoClientes = false;
      _safeNotify();
    }
  }

  Future<void> _fetchVisitas() async {
    carregandoVisitas = true;
    erroVisitas = null;
    _safeNotify();

    try {
      visitas = await VisitaService.fetchAllVisitas();
    } catch (e) {
      erroVisitas = 'Erro ao carregar visitas: $e';
      visitas = [];
    } finally {
      carregandoVisitas = false;
      _safeNotify();
    }
  }

  Future<void> _fetchOrcamentoParaEdicao(int id) async {
    carregando = true;
    erro = null;
    _safeNotify();

    try {
      final orc = await OrcamentoService.fetchOrcamentoById(id);

      clienteIdController.text = orc.clienteId.toString();
      visitaIdController.text = orc.visitaId?.toString() ?? '';
      descricaoController.text = orc.descricao;
      tipoSelecionado = orc.tipo;
      subtipoSelecionado = orc.subtipo;
      comMaterial = orc.comMaterial;
      dataSelecionada = orc.dataCriacao;

      itens.clear();
      itens.addAll(
        orc.itens.map(
          (i) => OrcamentoItem(
            id: i.id,
            descricao: i.descricao,
            quantidade: i.quantidade,
            valorUnitario: i.valorUnitario,
            subtotal: i.subtotal,
          ),
        ),
      );
    } catch (e) {
      erro = 'Erro ao carregar orçamento: $e';
    } finally {
      carregando = false;
      _safeNotify();
    }
  }

  void addItem({
    required String descricao,
    required int quantidade,
    required double valorUnitario,
  }) {
    itens.add(
      OrcamentoItem(
        id: null,
        descricao: descricao,
        quantidade: quantidade,
        valorUnitario: valorUnitario,
        subtotal: quantidade * valorUnitario,
      ),
    );
    recalcularTotal();
    _safeNotify();
  }

  void removeItem(OrcamentoItem item) {
    itens.remove(item);
    recalcularTotal();
    _safeNotify();
  }

  void recalcularTotal() {
    totalOrcamento = itens.fold(
      0.0,
      (sum, item) => sum + (item.subtotal ?? 0.0),
    );
    _safeNotify();
  }

  Future<void> saveOrcamento(
    BuildContext context,
    void Function(BuildContext, String, {bool erro}) mostrarMensagem,
  ) async {
    final clienteIdText = clienteIdController.text.trim();
    final descricaoText = descricaoController.text.trim();
    final tipo = tipoSelecionado;
    final subtipo = subtipoSelecionado;

    if (clienteIdText.isEmpty ||
        descricaoText.isEmpty ||
        tipo == null ||
        subtipo == null) {
      mostrarMensagem(
        context,
        'Preencha todos os campos obrigatórios.',
        erro: true,
      );
      return;
    }

    final clienteId = int.tryParse(clienteIdText);
    if (clienteId == null) {
      mostrarMensagem(context, 'ID de cliente inválido.', erro: true);
      return;
    }

    final visitaId =
        visitaIdController.text.trim().isNotEmpty
            ? int.tryParse(visitaIdController.text.trim())
            : null;
    if (visitaIdController.text.trim().isNotEmpty && visitaId == null) {
      mostrarMensagem(context, 'ID de visita inválido.', erro: true);
      return;
    }

    final orc = Orcamento(
      id: orcamentoId ?? 0,
      clienteId: clienteId,
      clienteNome: '',
      visitaId: visitaId,
      descricao: descricaoText,
      tipo: tipo,
      subtipo: subtipo,
      comMaterial: comMaterial,
      itens: itens,
      dataCriacao: dataSelecionada ?? DateTime.now(),
      totalOrcamento: totalOrcamento,
    );

    carregando = true;
    erro = null;
    sucesso = null;
    _safeNotify();

    try {
      if (orcamentoId == null) {
        final novo = await OrcamentoService.createOrcamento(orc);
        sucesso = 'Orçamento criado com sucesso! ID: ${novo.id}';
        mostrarMensagem(context, sucesso!);
      } else {
        final atualizado = await OrcamentoService.updateOrcamento(orc);
        sucesso = 'Orçamento atualizado com sucesso!';
        mostrarMensagem(context, sucesso!);
      }
    } catch (e) {
      erro = 'Erro ao salvar orçamento: $e';
      mostrarMensagem(context, erro!, erro: true);
    } finally {
      carregando = false;
      _safeNotify();
    }
  }
}
