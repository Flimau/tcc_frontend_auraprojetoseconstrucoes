// lib/features/visita/controllers/visita_cadastro_controller.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:front_application/constants/constants.dart';
import 'package:front_application/shared/services/cep_service.dart';
import 'package:http/http.dart' as http;

import '../../../shared/services/visita_service.dart';
import '../../usuario/models/usuario.dart';
import '../models/visita.dart';

class VisitaCadastroController extends ChangeNotifier {
  String? visitaId;

  // --- Campos do formulário ---
  final clienteIdController = TextEditingController();
  final dataVisitaController = TextEditingController(); // “DD/MM/AAAA”
  final descricaoController = TextEditingController();

  // --- Campos de endereço ---
  final cepController = TextEditingController();
  final ruaController = TextEditingController();
  final numeroController = TextEditingController();
  final complementoController = TextEditingController();
  final bairroController = TextEditingController();
  final cidadeController = TextEditingController();
  final estadoController = TextEditingController();
  final cepFocus = FocusNode();

  // Callback para exibir Snackbars
  BuildContext? _dummyContext;
  void Function(BuildContext, String, {bool erro}) _dummyMostrarMensagem =
      (c, t, {erro = false}) {};

  // Lista de URLs de fotos
  List<String> fotosPaths = [];

  // Dropdown de clientes
  List<Usuario> clientes = [];
  bool carregandoClientes = false;
  String? erroClientes;

  // Estado de submissão
  bool carregando = false;
  String? erro;
  String? sucesso;

  // Flag para evitar notifyListeners depois de dispose()
  bool _isDisposed = false;

  VisitaCadastroController({this.visitaId}) {
    _fetchClientes();

    // Autofill de endereço ao perder foco no CEP
    cepFocus.addListener(() {
      if (!cepFocus.hasFocus) {
        final cepTexto = cepController.text.trim().replaceAll(
          RegExp(r'\D'),
          '',
        );
        if (cepTexto.length == 8 && _dummyContext != null) {
          buscarEnderecoPorCep(cepTexto, _dummyContext!, _dummyMostrarMensagem);
        }
      }
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    cepFocus.dispose();
    super.dispose();
  }

  // Usar este método em vez de notifyListeners diretamente:
  void _safeNotify() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  /// Fornece context e função de snackbar para buscarEnderecoPorCep
  void setContextParaBusca(
    BuildContext context,
    void Function(BuildContext, String, {bool erro}) mostrarMensagem,
  ) {
    _dummyContext = context;
    _dummyMostrarMensagem = mostrarMensagem;
  }

  /// Carrega todos os usuários do tipo CLIENTE para o dropdown
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

  /// Ao perder foco no CEP, busca o endereço via CEP Service
  Future<void> buscarEnderecoPorCep(
    String cep,
    BuildContext context,
    Function mostrarMensagem,
  ) async {
    final resultado = await CepService.buscarEndereco(cep);
    if (resultado != null) {
      ruaController.text = resultado['logradouro'] ?? '';
      bairroController.text = resultado['bairro'] ?? '';
      cidadeController.text = resultado['cidade'] ?? '';
      estadoController.text = resultado['estado'] ?? '';
      _safeNotify();
    } else {
      mostrarMensagem(context, 'CEP não encontrado ou inválido', erro: true);
    }
  }

  /// Carrega dados para edição (se visitaId != null)
  Future<void> carregarVisitaParaEdicao() async {
    if (visitaId == null) return;
    carregando = true;
    _safeNotify();

    try {
      final visita = await VisitaService.fetchVisitaById(visitaId!);
      clienteIdController.text = visita.clienteId.toString();
      dataVisitaController.text = _formatarDataTela(visita.dataVisita);
      descricaoController.text = visita.descricao;
      fotosPaths = visita.fotos;

      // Preenche campos de endereço
      final end = visita.endereco;
      cepController.text = end.cep;
      ruaController.text = end.logradouro;
      numeroController.text = end.numero;
      complementoController.text = end.complemento;
      bairroController.text = end.bairro;
      cidadeController.text = end.cidade;
      estadoController.text = end.siglaEstado;
    } catch (e) {
      erro = 'Erro ao carregar visita: $e';
    } finally {
      carregando = false;
      _safeNotify();
    }
  }

  /// Adiciona uma foto (URL ou path base64)
  void adicionarFoto(String path) {
    fotosPaths.add(path);
    _safeNotify();
  }

  /// Remove uma foto
  void removerFoto(String path) {
    fotosPaths.remove(path);
    _safeNotify();
  }

  /// Cria ou atualiza visita usando VisitaService
  Future<void> salvarVisita(
    BuildContext context,
    void Function(BuildContext, String, {bool erro}) mostrarMensagem,
  ) async {
    setContextParaBusca(context, mostrarMensagem);

    final clienteIdText = clienteIdController.text.trim();
    final dataText = dataVisitaController.text.trim();
    final descricaoText = descricaoController.text.trim();
    final cepText = cepController.text.trim();
    final ruaText = ruaController.text.trim();
    final numeroText = numeroController.text.trim();
    final compText = complementoController.text.trim();
    final bairroText = bairroController.text.trim();
    final cidadeText = cidadeController.text.trim();
    final estadoText = estadoController.text.trim();

    // Validações
    if (clienteIdText.isEmpty || dataText.isEmpty || cepText.isEmpty) {
      mostrarMensagem(context, 'Preencha Cliente, Data e CEP.', erro: true);
      return;
    }
    final clienteIdInt = int.tryParse(clienteIdText);
    if (clienteIdInt == null) {
      mostrarMensagem(context, 'ID de cliente inválido.', erro: true);
      return;
    }
    final dataParsed = _parseData(dataText);
    if (dataParsed == null) {
      mostrarMensagem(
        context,
        'Formato de data inválido (DD/MM/AAAA).',
        erro: true,
      );
      return;
    }
    final isoDate = _toIsoDate(dataParsed);

    // Validação de endereço
    if (ruaText.isEmpty ||
        bairroText.isEmpty ||
        cidadeText.isEmpty ||
        estadoText.isEmpty) {
      mostrarMensagem(context, 'CEP inválido ou incompleto.', erro: true);
      return;
    }

    carregando = true;
    erro = null;
    sucesso = null;
    _safeNotify();

    try {
      final visitaParaEnvio = Visita(
        id: visitaId ?? '',
        clienteId: clienteIdInt,
        clienteNome: '',
        endereco: EnderecoDTO(
          cep: cepText,
          logradouro: ruaText,
          numero: numeroText,
          complemento: compText,
          bairro: bairroText,
          cidade: cidadeText,
          siglaEstado: estadoText,
        ),
        descricao: descricaoText,
        dataVisita: isoDate,
        fotos: fotosPaths,
        videos: <String>[],
        usadaEmOrcamento: false,
      );

      if (visitaId == null) {
        final nova = await VisitaService.createVisita(visitaParaEnvio);
        sucesso = 'Visita cadastrada com sucesso! ID: ${nova.id}';
        mostrarMensagem(context, sucesso!);
      } else {
        await VisitaService.updateVisita(visitaId!, visitaParaEnvio);
        sucesso = 'Visita atualizada com sucesso!';
        mostrarMensagem(context, sucesso!);
      }
    } catch (e) {
      erro = 'Erro ao salvar visita: $e';
      mostrarMensagem(context, erro!, erro: true);
    } finally {
      carregando = false;
      _safeNotify();
    }
  }

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

  String _toIsoDate(DateTime d) {
    final ano = d.year.toString().padLeft(4, '0');
    final mes = d.month.toString().padLeft(2, '0');
    final dia = d.day.toString().padLeft(2, '0');
    return '$ano-$mes-$dia';
  }

  String _formatarDataTela(String isoDate) {
    try {
      final parts = isoDate.split('-');
      return '${parts[2].padLeft(2, '0')}/${parts[1].padLeft(2, '0')}/${parts[0]}';
    } catch (_) {
      return isoDate;
    }
  }
}
