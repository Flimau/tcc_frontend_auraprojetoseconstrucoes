import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front_application/shared/services/cep_service.dart';
import 'package:front_application/shared/services/geolocalizacao_service.dart';
import 'package:front_application/shared/utils/converters.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../constants/constants.dart';

class UsuarioCadastroController extends ChangeNotifier {
  BuildContext? _contextInterno;
  Function? _mostrarMensagemInterna;
  Function? get mostrarMensagemInterna => _mostrarMensagemInterna;

  final FocusNode cepFocus = FocusNode();

  bool usuarioCarregado = false;
  String? idUsuario;
  bool? ativo;

  // Controladores de campo
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final telefoneController = TextEditingController();
  final cpfController = TextEditingController();
  final cnpjController = TextEditingController();
  final nascimentoController = TextEditingController();
  final numeroController = TextEditingController();
  final cepController = TextEditingController();
  final ruaController = TextEditingController();
  final complementoController = TextEditingController();
  final bairroController = TextEditingController();
  final cidadeController = TextEditingController();
  final estadoController = TextEditingController();

  String? sexoSelecionado;
  String? tipoUsuarioSelecionado;
  String? tipoPessoaSelecionado;
  String? enderecoId;

  void atualizar() => notifyListeners();

  Future<void> cadastrarUsuario(
    BuildContext context,
    Function mostrarMensagem,
  ) async {
    _contextInterno = context;
    _mostrarMensagemInterna = mostrarMensagem;

    final url = Uri.parse('${AppConstants.baseUrl}/api/usuario/cadastrar');
    final coordenadas = await GeolocalizacaoService.buscarCoordenadas(
      logradouro: ruaController.text,
      numero: numeroController.text,
      cidade: cidadeController.text,
      estado: estadoController.text,
    );

    final body = {
      "login": emailController.text,
      "senha": "senha123",
      "tipoUsuario": tipoUsuarioSelecionado ?? "CLIENTE",
      "pessoaCadastroDTO": {
        "nome": nomeController.text,
        "cpf": cpfController.text,
        "cnpj": cnpjController.text,
        "tipoPessoa": tipoPessoaSelecionado == '1' ? "FISICA" : "JURIDICA",
        "dataNascimento": formatarDataParaIso(nascimentoController.text),
        "sexo": sexoSelecionado ?? "INDEFINIDO",
        "endereco": {
          "logradouro": ruaController.text,
          "numero": numeroController.text,
          "bairro": bairroController.text,
          "cep": cepController.text,
          "complemento": complementoController.text,
          "cidade": cidadeController.text,
          "siglaEstado": estadoController.text,
          "latitude": coordenadas?['latitude'],
          "longitude": coordenadas?['longitude'],
        },
        "contato": {
          "celular": telefoneController.text,
          "email": emailController.text,
        },
      },
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        mostrarMensagem(context, 'Usuário cadastrado com sucesso!');
        Navigator.pop(context);
      } else if (response.statusCode == 409) {
        mostrarMensagem(context, 'Este login já está em uso.', erro: true);
      } else {
        mostrarMensagem(context, 'Erro: ${response.body}', erro: true);
      }
    } catch (e) {
      mostrarMensagem(context, 'Erro de conexão: $e', erro: true);
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
      notifyListeners();
    } else {
      mostrarMensagem(context, 'CEP não encontrado ou inválido', erro: true);
    }
  }

  Future<void> carregarPessoaPorId(String id) async {
    if (usuarioCarregado) return;
    usuarioCarregado = true;

    try {
      final url = Uri.parse('${AppConstants.baseUrl}/api/usuario/$id');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final pessoa = data['pessoa'];
        enderecoId = pessoa['endereco']['id']?.toString();

        idUsuario = data['id'].toString();
        ativo = data['ativo'] ?? true;

        nomeController.text = pessoa['nome'] ?? '';
        emailController.text = data['login'] ?? '';
        telefoneController.text = pessoa['contato']['celular'] ?? '';

        if (pessoa['tipoPessoa'] == 'FISICA') {
          tipoPessoaSelecionado = '1';
          cpfController.text = pessoa['cpf'] ?? '';
        } else {
          tipoPessoaSelecionado = '2';
          cnpjController.text = pessoa['cnpj'] ?? '';
        }

        if (pessoa['dataNascimento'] != null) {
          try {
            final DateTime dataNasc = DateTime.parse(pessoa['dataNascimento']);
            nascimentoController.text = DateFormat(
              'dd/MM/yyyy',
            ).format(dataNasc);
          } catch (_) {
            nascimentoController.text = pessoa['dataNascimento'];
          }
        }

        sexoSelecionado = pessoa['sexo']?.toUpperCase();
        tipoUsuarioSelecionado = data['tipoUsuario']?.toUpperCase();

        ruaController.text = pessoa['endereco']['logradouro'] ?? '';
        numeroController.text = pessoa['endereco']['numero'] ?? '';
        bairroController.text = pessoa['endereco']['bairro'] ?? '';
        complementoController.text = pessoa['endereco']['complemento'] ?? '';
        cepController.text = pessoa['endereco']['cep'] ?? '';
        cidadeController.text = pessoa['endereco']['cidade']?.toString() ?? '';
        estadoController.text = pessoa['endereco']['siglaEstado'] ?? '';

        notifyListeners();
      } else {
        throw Exception('Erro ao carregar usuário: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro na requisição: $e');
    }
  }

  /// Altera status do usuário: desativa ou reativa.
  /// Reativar CLIENTE retorna token no dialog; ADM/EXECUTOR só SnackBar.
  Future<void> alterarStatusUsuario(bool ativar, BuildContext context) async {
    if (!usuarioCarregado || idUsuario == null) return;

    final acao = ativar ? 'reativar' : 'desativar';
    final url = Uri.parse(
      '${AppConstants.baseUrl}/api/usuario/$idUsuario/$acao',
    );

    try {
      final response = await http.put(url);

      if (response.statusCode == 204) {
        // Desativação ou reativação sem token
        ativo = ativar;
        notifyListeners();
        mostrarMensagemInterna?.call(
          context,
          'Usuário ${ativar ? "reativado" : "inativado"} com sucesso!',
        );
      } else if (response.statusCode == 200) {
        // Reativação de CLIENTE retorna token
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final token = body['token'] as String?;

        ativo = false; // continua inativo até cliente ativar
        notifyListeners();

        showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                title: const Text('Token de Reativação'),
                content: SelectableText(token ?? '—'),
                actions: [
                  TextButton(
                    onPressed: () {
                      if (token != null) {
                        Clipboard.setData(ClipboardData(text: token));
                        mostrarMensagemInterna?.call(context, 'Token copiado!');
                      }
                      Navigator.pop(context);
                    },
                    child: const Text('Copiar'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Fechar'),
                  ),
                ],
              ),
        );
      } else {
        mostrarMensagemInterna?.call(
          context,
          'Erro ao ${ativar ? "reativar" : "desativar"}: ${response.statusCode}',
          erro: true,
        );
      }
    } catch (e) {
      mostrarMensagemInterna?.call(context, 'Erro de conexão: $e', erro: true);
    }
  }

  Future<void> atualizarUsuario(BuildContext context) async {
    if (idUsuario == null) return;

    final url = Uri.parse('${AppConstants.baseUrl}/api/usuario/$idUsuario');
    final coordenadas = await GeolocalizacaoService.buscarCoordenadas(
      logradouro: ruaController.text,
      numero: numeroController.text,
      cidade: cidadeController.text,
      estado: estadoController.text,
    );

    final body = {
      "login": emailController.text,
      "senha": "senha123",
      "tipoUsuario": tipoUsuarioSelecionado ?? "CLIENTE",
      "pessoaCadastroDTO": {
        "nome": nomeController.text,
        "cpf": cpfController.text,
        "cnpj": cnpjController.text,
        "tipoPessoa": tipoPessoaSelecionado == '1' ? "FISICA" : "JURIDICA",
        "dataNascimento": formatarDataParaIso(nascimentoController.text),
        "sexo": sexoSelecionado ?? "INDEFINIDO",
        "endereco": {
          "id" : enderecoId,
          "logradouro": ruaController.text,
          "numero": numeroController.text,
          "bairro": bairroController.text,
          "cep": cepController.text,
          "complemento": complementoController.text,
          "cidade": cidadeController.text,
          "siglaEstado": estadoController.text,
          "latitude": coordenadas?['latitude'],
          "longitude": coordenadas?['longitude'],
        },
        "contato": {
          "celular": telefoneController.text,
          "email": emailController.text,
        },
      },
    };

    try {
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 204) {
        mostrarMensagemInterna?.call(context, 'Usuário atualizado com sucesso');
        Navigator.pop(context);
      } else {
        mostrarMensagemInterna?.call(
          context,
          'Erro: ${response.statusCode}',
          erro: true,
        );
      }
    } catch (e) {
      mostrarMensagemInterna?.call(context, 'Erro de conexão: $e', erro: true);
    }
  }
}
