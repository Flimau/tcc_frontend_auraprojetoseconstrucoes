import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../constants/constants.dart';
import 'acompanhamento_dtos.dart';

class AcompanhamentoProvider with ChangeNotifier {
  final String baseUrl = AppConstants.baseUrl;
  List<AcompanhamentoListagemDTO> _acompanhamentos = [];
  List<AcompanhamentoListagemDTO> get acompanhamentos => _acompanhamentos;

  Future<void> carregarPorObra(int obraId) async {
    final response = await http.get(Uri.parse('$baseUrl/api/acompanhamentos/obra/$obraId'));
    if (response.statusCode == 200) {
      final List jsonList = json.decode(response.body);
      _acompanhamentos =
          jsonList.map((e) => AcompanhamentoListagemDTO.fromJson(e)).toList();
      notifyListeners();
    }
  }

  Future<AcompanhamentoCadastroDTO?> buscarPorData(
    int obraId,
    DateTime data,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/obra/$obraId/data/${data.toIso8601String()}'),
    );
    if (response.statusCode == 200) {
      return AcompanhamentoCadastroDTO.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Erro ao buscar data');
    }
  }

  Future<void> salvar(AcompanhamentoCadastroDTO dto) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/acompanhamentos'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(dto.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      await carregarPorObra(dto.obraId);
      notifyListeners();
    } else {
      throw Exception('Erro ao salvar acompanhamento');
    }
  }

  Future<void> editar(AcompanhamentoCadastroDTO dto) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${dto.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(dto.toJson()),
    );

    if (response.statusCode == 200) {
      await carregarPorObra(dto.obraId);
    } else {
      throw Exception('Erro ao editar acompanhamento');
    }
  }
}
