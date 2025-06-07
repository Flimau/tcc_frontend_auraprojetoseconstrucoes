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
  // --- Identificador do orçamento (null ao criar, valor ao editar) ---
  final int? orcamentoId;

  // --- Campos do formulário ---
  final clienteIdController = TextEditingController();
  final visitaIdController =
      TextEditingController(); // pode ficar vazio se não vincular
  final descricaoController = TextEditingController();

  // Dropdowns de tipo e subtipo
  String? tipoSelecionado;
  String? subtipoSelecionado;

  // Checkbox “comMaterial”
  bool comMaterial = false;

  // Lista de itens de orçamento (cada item é OrcamentoItem)
  final List<OrcamentoItem> itens = [];

  // --- Dados auxiliares para dropdowns/combos ---
  // Lista de clientes, carregada via HTTP (mesma lógica do VisitaCadastroController)
  List<Usuario> clientes = [];
  bool carregandoClientes = false;
  String? erroClientes;

  // Lista de visitas (se for opcional vincular visita ao orçamento)
  List<Visita> visitas = [];
  bool carregandoVisitas = false;
  String? erroVisitas;

  // Valores possíveis de “tipo” e “subtipo” (baseados nos enums do back-end)
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
    'CONSTRUCAO': [], // sem subtipo no back
    'DRYWALL': ['FORRO', 'PAREDE', 'AMBOS'],
    'ACABAMENTO': ['PISO', 'PINTURA', 'RODAPE', 'REVESTIMENTO'],
  };

  // --- Estados de submissão/sucesso/erro ---
  bool carregando = false;
  String? erro;
  String? sucesso;

  // Para evitar notifyListeners após dispose
  bool _isDisposed = false;

  /// Construtor: se [orcamentoId] não for null, carrega dados para edição
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
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  // ============================
  // 1. Carregar dropdowns de apoio
  // ============================

  /// Reaproveita a lógica de busca de clientes do VisitaCadastroController.
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
        final List<dynamic> listaJson =
            json.decode(response.body) as List<dynamic>;
        clientes =
            listaJson
                .map((json) => Usuario.fromJson(json as Map<String, dynamic>))
                .toList();
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

  /// Carrega lista de visitas via VisitaService (se quiser vincular visita ao orçamento)
  Future<void> _fetchVisitas() async {
    carregandoVisitas = true;
    erroVisitas = null;
    _safeNotify();

    try {
      final lista = await VisitaService.fetchAllVisitas();
      visitas = lista;
    } catch (e) {
      erroVisitas = 'Erro ao carregar visitas: $e';
      visitas = [];
    } finally {
      carregandoVisitas = false;
      _safeNotify();
    }
  }

  // =================================================
  // 2. Carregar orçamento existente para edição (se aplicável)
  // =================================================

  Future<void> _fetchOrcamentoParaEdicao(int id) async {
    carregando = true;
    erro = null;
    _safeNotify();

    try {
      final orc = await OrcamentoService.fetchOrcamentoById(id);

      // Preencher campos do formulário
      clienteIdController.text = orc.clienteId.toString();
      visitaIdController.text = orc.visitaId?.toString() ?? '';
      descricaoController.text = orc.descricao;
      tipoSelecionado = orc.tipo;
      subtipoSelecionado = orc.subtipo;
      comMaterial = orc.comMaterial;

      // Preencher itens (criamos cópias para edição; mantemos subtotal para exibição)
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

      sucesso = null;
      erro = null;
    } catch (e) {
      erro = 'Erro ao carregar orçamento: $e';
    } finally {
      carregando = false;
      _safeNotify();
    }
  }

  // ============================
  // 3. Métodos para manipular itens do orçamento
  // ============================

  /// Adiciona um novo item à lista. [id] será gerado pelo back, então aqui passa null.
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
    _safeNotify();
  }

  /// Remove um [item] específico da lista (por referência ou ID).
  void removeItem(OrcamentoItem item) {
    itens.remove(item);
    _safeNotify();
  }

  // ============================
  // 4. Criar ou atualizar orçamento
  // ============================

  /// Salva o orçamento. Se [orcamentoId] for null, cria; senão, atualiza.
  Future<void> saveOrcamento(
    BuildContext context,
    void Function(BuildContext, String, {bool erro}) mostrarMensagem,
  ) async {
    // Validações básicas de campos obrigatórios
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

    // Visita é opcional; se preencher, converte para int
    final visitaId =
        visitaIdController.text.trim().isNotEmpty
            ? int.tryParse(visitaIdController.text.trim())
            : null;
    if (visitaIdController.text.trim().isNotEmpty && visitaId == null) {
      mostrarMensagem(context, 'ID de visita inválido.', erro: true);
      return;
    }

    // Monta o objeto Orcamento para envio
    final orc = Orcamento(
      id: orcamentoId ?? 0, // no POST este valor é ignorado pelo back
      clienteId: clienteId,
      clienteNome: '', // campo de exibição; o back preenche
      visitaId: visitaId,
      descricao: descricaoText,
      tipo: tipo,
      subtipo: subtipo,
      comMaterial: comMaterial,
      itens: itens,
      dataCriacao: DateTime.now(), // será ignorado em criação
    );

    carregando = true;
    erro = null;
    sucesso = null;
    _safeNotify();

    try {
      if (orcamentoId == null) {
        // Criando novo orçamento
        final novo = await OrcamentoService.createOrcamento(orc);
        sucesso = 'Orçamento criado com sucesso! ID: ${novo.id}';
        mostrarMensagem(context, sucesso!);
      } else {
        // Atualizando orçamento existente
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
