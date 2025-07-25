import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../constants/constants.dart';
import '../models/usuario.dart';

class UsuarioListController extends ChangeNotifier {
  final TextEditingController campoBuscaController = TextEditingController();
  String chaveSelecionada = 'Nome';
  String? tipoUsuarioSelecionado;
  int? sortColumnIndex;
  bool isAscending = true;

  final List<String> chaves = ['ID', 'CPF', 'CNPJ', 'Nome'];
  final List<String> tiposUsuario = ['ADMINISTRADOR', 'CLIENTE', 'EXECUTOR'];

  List<Usuario> resultados = [];

  Future<void> buscar() async {
    final filtro = campoBuscaController.text.trim();
    if (filtro.isEmpty) {
      await carregarUsuarios();
      return;
    }

    String chaveAPI;
    switch (chaveSelecionada) {
      case 'ID':
        chaveAPI = 'id';
        break;
      case 'CPF':
        chaveAPI = 'cpf';
        break;
      case 'CNPJ':
        chaveAPI = 'cnpj';
        break;
      case 'Nome':
        chaveAPI = 'nome';
        break;
      default:
        chaveAPI = 'nome';
        break;
    }

    try {
      await carregarUsuarios(chave: chaveAPI, valor: filtro);
    } catch (e) {

      resultados = [];
      notifyListeners();
    }
  }

  Future<void> carregarUsuarios({String? chave, String? valor}) async {
    final baseUri = Uri.parse('${AppConstants.baseUrl}/api/usuario/listar');
    final queryParams = <String, String>{};
    if (chave != null && valor != null && valor.isNotEmpty) {
      queryParams[chave] = valor;
    }
    if (tipoUsuarioSelecionado != null && tipoUsuarioSelecionado!.isNotEmpty) {
      queryParams['tipoUsuario'] = tipoUsuarioSelecionado!;
    }
    final url = baseUri.replace(queryParameters: queryParams);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        resultados = data.map((json) => Usuario.fromJson(json)).toList();
      } else {
        resultados = [];
      }
    } catch (_) {
      resultados = [];
    }

    notifyListeners();
  }

  void sortDados(int columnIndex, bool ascending) {
    final chave = chaves[columnIndex];

    if (chave != 'ID') {
      return;
    }

    if (sortColumnIndex == columnIndex) {
      isAscending = !isAscending;
    } else {
      sortColumnIndex = columnIndex;
      isAscending = true;
    }

    resultados.sort((a, b) {
      final int idA = int.tryParse(a.id) ?? 0;
      final int idB = int.tryParse(b.id) ?? 0;
      return isAscending ? idA.compareTo(idB) : idB.compareTo(idA);
    });

    notifyListeners();
  }
}
