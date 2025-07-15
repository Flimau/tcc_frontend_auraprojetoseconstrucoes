import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:front_application/constants/constants.dart';
import 'package:front_application/shared/services/cep_service.dart';
import 'package:front_application/shared/services/visita_service.dart';
import 'package:http/http.dart' as http;

import '../../usuario/models/usuario.dart';
import '../models/visita.dart';

class VisitaCadastroController extends ChangeNotifier {
  String? visitaId;

  final clienteIdController = TextEditingController();
  final dataVisitaController = TextEditingController();
  final descricaoController = TextEditingController();

  final cepController = TextEditingController();
  final ruaController = TextEditingController();
  final numeroController = TextEditingController();
  final complementoController = TextEditingController();
  final bairroController = TextEditingController();
  final cidadeController = TextEditingController();
  final estadoController = TextEditingController();
  final cepFocus = FocusNode();

  final List<File> imagensSelecionadas = [];
  final List<String> imagensServidor = [];


  List<Usuario> clientes = [];
  bool carregandoClientes = false;
  String? erroClientes;

  bool carregando = false;
  String? erro;
  String? sucesso;
  bool _isDisposed = false;

  BuildContext? _dummyContext;
  void Function(BuildContext, String, {bool erro}) _dummyMostrarMensagem =
      (c, t, {erro = false}) {};

  VisitaCadastroController({this.visitaId}) {
    _fetchClientes();

    cepFocus.addListener(() {
      if (!cepFocus.hasFocus) {
        final cepTexto = cepController.text.trim().replaceAll(RegExp(r'\D'), '');
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

  void _safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  void setContextParaBusca(
    BuildContext context,
    void Function(BuildContext, String, {bool erro}) mostrarMensagem,
  ) {
    _dummyContext = context;
    _dummyMostrarMensagem = mostrarMensagem;
  }

  Future<void> _fetchClientes() async {
    carregandoClientes = true;
    erroClientes = null;
    _safeNotify();

    try {
      final uri = Uri.parse('${AppConstants.baseUrl}/api/usuario/listar')
          .replace(queryParameters: {'tipoUsuario': 'CLIENTE'});
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> listaJson = json.decode(response.body);
        clientes = listaJson
            .map((json) => Usuario.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        erroClientes = 'Erro ao carregar clientes: ${response.statusCode}';
      }
    } catch (e) {
      erroClientes = 'Erro de rede: $e';
    } finally {
      carregandoClientes = false;
      _safeNotify();
    }
  }

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
      mostrarMensagem(context, 'CEP inválido ou não encontrado.', erro: true);
    }
  }

  Future<void> carregarVisitaParaEdicao() async {
    if (visitaId == null) return;
    carregando = true;
    _safeNotify();

    try {
      final visita = await VisitaService.fetchVisitaById(visitaId!);
      clienteIdController.text = visita.clienteId.toString();
      dataVisitaController.text = _formatarDataTela(visita.dataVisita);
      descricaoController.text = visita.descricao;

      final end = visita.endereco;
      cepController.text = end.cep;
      ruaController.text = end.logradouro;
      numeroController.text = end.numero;
      complementoController.text = end.complemento;
      bairroController.text = end.bairro;
      cidadeController.text = end.cidade;
      estadoController.text = end.siglaEstado;

      imagensServidor.clear();
      imagensServidor.addAll(visita.fotos);
    } catch (e) {
      erro = 'Erro ao carregar visita: $e';
    } finally {
      carregando = false;
      _safeNotify();
    }
  }

  void adicionarImagemLocal(File file) {
    imagensSelecionadas.add(file);
    _safeNotify();
  }

  void removerImagemLocal(File file) {
    imagensSelecionadas.remove(file);
    _safeNotify();
  }

  Future<void> removerImagemServidor(String url) async {
    imagensServidor.remove(url);
    _safeNotify();

    try {
      await VisitaService.deleteImagem(url);
    } catch (e) {
      print('Erro ao excluir imagem do servidor: $e');
      _dummyMostrarMensagem(
        _dummyContext!,
        'Imagem removida localmente, mas falha ao excluir no servidor.',
        erro: true,
      );
    }
  }

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

    if (clienteIdText.isEmpty || dataText.isEmpty || cepText.isEmpty) {
      mostrarMensagem(context, 'Preencha Cliente, Data e CEP.', erro: true);
      return;
    }

    final clienteIdInt = int.tryParse(clienteIdText);
    if (clienteIdInt == null) {
      mostrarMensagem(context, 'ID do cliente inválido.', erro: true);
      return;
    }

    final dataParsed = _parseData(dataText);
    if (dataParsed == null || dataParsed.year < 1900) {
      mostrarMensagem(context, 'Data inválida.', erro: true);
      return;
    }

    if (ruaText.isEmpty ||
        bairroText.isEmpty ||
        cidadeText.isEmpty ||
        estadoText.isEmpty) {
      mostrarMensagem(context, 'Endereço incompleto.', erro: true);
      return;
    }

    carregando = true;
    erro = null;
    sucesso = null;
    _safeNotify();

    try {
      final novasUrls = await VisitaService.uploadMultiplasImagens(imagensSelecionadas);

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
        dataVisita: _toIsoDate(dataParsed),
        fotos: [...imagensServidor, ...novasUrls],
        videos: [],
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

      imagensSelecionadas.clear();
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

  String _toIsoDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  String _formatarDataTela(String isoDate) {
    try {
      final parts = isoDate.split('-');
      return '${parts[2]}/${parts[1]}/${parts[0]}';
    } catch (_) {
      return isoDate;
    }
  }
}
