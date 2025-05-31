import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../constants/constants.dart';
import '../../../shared/components/form_widgets.dart';
import '../../../theme/theme.dart';

class TelaAtivacaoUsuario extends StatefulWidget {
  const TelaAtivacaoUsuario({Key? key}) : super(key: key);

  @override
  State<TelaAtivacaoUsuario> createState() => _TelaAtivacaoUsuarioState();
}

class _TelaAtivacaoUsuarioState extends State<TelaAtivacaoUsuario> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController tokenController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  bool isLoading = false;

  Future<void> _ativar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);
    final uri = Uri.parse('${AppConstants.baseUrl}/api/usuario/ativar');
    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'token': tokenController.text.trim(),
          'novaSenha': senhaController.text.trim(),
        }),
      );

      if (response.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Conta ativada com sucesso!'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Falha na ativação (${response.statusCode})'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao ativar: ${e.toString()}'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    tokenController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCustom(titulo: 'Ativar Conta'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: tokenController,
                decoration: const InputDecoration(
                  labelText: 'Token de ativação',
                ),
                validator:
                    (v) => v == null || v.isEmpty ? 'Token obrigatório' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: senhaController,
                decoration: const InputDecoration(labelText: 'Nova senha'),
                obscureText: true,
                validator:
                    (v) =>
                        v == null || v.length < 6
                            ? 'Mínimo 6 caracteres'
                            : null,
              ),
              const SizedBox(height: 32),
              isLoading
                  ? const CircularProgressIndicator()
                  : BotaoPadrao(texto: 'Ativar Conta', onPressed: _ativar),
            ],
          ),
        ),
      ),
    );
  }
}
