import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../constants/constants.dart';
import '../../../theme/theme.dart';
import '../../shared/services/http_client_utf8.dart';

class TelaCadastroObra extends StatefulWidget {
  final int? obraId;
  const TelaCadastroObra({super.key, this.obraId});

  @override
  State<TelaCadastroObra> createState() => _TelaCadastroObraState();
}

class _TelaCadastroObraState extends State<TelaCadastroObra> {
  static final _client = HttpClientUtf8();
  int? obraId;
  List clientes = [], orcamentos = [], executores = [];
  String? clienteSelecionado,
      orcamentoSelecionado,
      contratoSelecionado,
      executorSelecionado;
  String status = "PLANEJADA";

  final dataInicioController = TextEditingController();
  final dataFimController = TextEditingController();
  final cepController = TextEditingController();
  final ruaController = TextEditingController();
  final numeroController = TextEditingController();
  final complementoController = TextEditingController();
  final bairroController = TextEditingController();
  final cidadeController = TextEditingController();
  final estadoController = TextEditingController();
  final FocusNode cepFocus = FocusNode();
  final enderecoIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    cepFocus.addListener(() {
      if (!cepFocus.hasFocus) buscarEnderecoPorCep();
    });

    carregarDadosIniciais();
  }

  Future<void> carregarDadosIniciais() async {
    await carregarClientes();
    await carregarExecutores();

    if (widget.obraId != null) {
      await carregarObraPorId();
    }
  }

  Future<void> carregarClientes() async {
    try {
      final url = Uri.parse(
        '${AppConstants.baseUrl}/api/usuario/listar?tipoUsuario=CLIENTE',
      );
      final resp = await _client.get(url);

      if (resp.statusCode == 200) {
        clientes = json.decode(resp.body);
        setState(() {});
      } else {
        mostrarErro("Erro ao carregar lista de clientes (${resp.statusCode})");
      }
    } catch (e) {
      print("Erro ao carregar clientes: $e");
      mostrarErro("Erro ao carregar lista de clientes.");
    }
  }

  Future<void> carregarExecutores() async {
    try {
      final url = Uri.parse(
        '${AppConstants.baseUrl}/api/usuario/listar?tipoUsuario=EXECUTOR',
      );
      final resp = await _client.get(url);

      if (resp.statusCode == 200) {
        executores = json.decode(resp.body);
        setState(() {});
      } else {
        mostrarErro(
          "Erro ao carregar lista de executores (${resp.statusCode})",
        );
      }
    } catch (e) {
      print("Erro ao carregar executores: $e");
      mostrarErro("Erro ao carregar lista de executores.");
    }
  }

  Future<void> carregarOrcamentosDoCliente() async {
    if (clienteSelecionado == null) {
      orcamentos = [];
      setState(() {});
      return;
    }

    try {
      final clienteId = int.parse(clienteSelecionado!.split(' - ').first);
      final url = Uri.parse(
        '${AppConstants.baseUrl}/api/orcamento/por-cliente/$clienteId',
      );
      final resp = await _client.get(url);

      if (resp.statusCode == 200) {
        orcamentos = json.decode(resp.body);
        setState(() {});
      } else {
        mostrarErro("Erro ao carregar orçamentos (${resp.statusCode})");
      }
    } catch (e) {
      print("Erro ao carregar orçamentos: $e");
      mostrarErro("Erro ao carregar orçamentos do cliente.");
    }
  }

  Future<void> selecionarCliente(String? val) async {
    clienteSelecionado = val;
    orcamentoSelecionado = null;
    contratoSelecionado = null;
    await carregarOrcamentosDoCliente();
  }

  Future<void> selecionarOrcamento(String? val) async {
    orcamentoSelecionado = val;
    contratoSelecionado = null;

    if (val != null) {
      try {
        final orcamentoId = int.parse(val.split(' ')[1]);
        final url = Uri.parse(
          '${AppConstants.baseUrl}/api/orcamento/$orcamentoId/contrato',
        );
        final resp = await _client.get(url);

        if (resp.statusCode == 200) {
          final contrato = json.decode(resp.body);
          contratoSelecionado = "ID: ${contrato['id']}";
        } else {
          mostrarErro("Erro ao carregar contrato (${resp.statusCode})");
        }
      } catch (e) {
        print("Erro ao carregar contrato: $e");
        mostrarErro("Erro ao carregar contrato do orçamento.");
      }
    }

    setState(() {});
  }

  Future<void> carregarObraPorId() async {
    try {
      final url = Uri.parse(
        '${AppConstants.baseUrl}/api/obras/${widget.obraId}',
      );
      final resp = await _client.get(url);

      if (resp.statusCode == 200) {
        final data = json.decode(resp.body);

        // Primeiro carrega as listas antes de setar os selecionados:
        await carregarClientes();
        await carregarExecutores();
        await carregarOrcamentosDoCliente();

        /// CLIENTE (proteção para garantir que o ID existe na lista):
        final clienteId = data['clienteId'];
        final cliente = clientes.firstWhere(
          (c) => c['id'] == clienteId,
          orElse: () => null,
        );
        if (cliente != null) {
          clienteSelecionado = '${cliente['id']} - ${cliente['nome']}';
        } else {
          clienteSelecionado = null;
        }

        /// EXECUTOR:
        final executorId = data['executorId'];
        if (executorId != null) {
          final executor = executores.firstWhere(
            (e) => e['id'] == executorId,
            orElse: () => null,
          );
          if (executor != null) {
            executorSelecionado = '${executor['id']} - ${executor['nome']}';
          }
        } else {
          executorSelecionado = null;
        }

        /// DATAS:
        dataInicioController.text =
            data['dataInicio'] != null
                ? _converterDataParaPTBR(data['dataInicio'])
                : '';
        dataFimController.text =
            data['dataFim'] != null
                ? _converterDataParaPTBR(data['dataFim'])
                : '';

        status = data['status'] ?? "PLANEJADA";

        /// ORCAMENTO:
        if (data['orcamentoId'] != null && data['orcamentoData'] != null) {
          orcamentoSelecionado = 'ID: ${data['orcamentoId']} - ${data['tipo']}';
        } else {
          orcamentoSelecionado = null;
        }

        final endereco = data['endereco'];
        enderecoIdController.text = (endereco['id'] ?? '').toString();
        cepController.text = endereco['cep'] ?? '';
        ruaController.text = endereco['logradouro'] ?? '';
        numeroController.text = endereco['numero'] ?? '';
        complementoController.text = endereco['complemento'] ?? '';
        bairroController.text = endereco['bairro'] ?? '';
        cidadeController.text = endereco['cidade'] ?? '';
        estadoController.text = endereco['siglaEstado'] ?? '';
      } else {
        mostrarErro("Erro ao carregar dados da obra (${resp.statusCode})");
      }
    } catch (e) {
      print("Erro ao carregar obra: $e");
      mostrarErro("Erro ao carregar dados da obra.");
    }

    setState(() {});
  }

  Future<void> buscarEnderecoPorCep() async {
    final cep = cepController.text.replaceAll(RegExp(r'\D'), '');
    if (cep.length != 8) return;

    try {
      final resp = await _client.get(
        Uri.parse("https://viacep.com.br/ws/$cep/json/"),
      );

      if (resp.statusCode == 200) {
        final data = json.decode(resp.body);
        ruaController.text = data['logradouro'] ?? "";
        bairroController.text = data['bairro'] ?? "";
        cidadeController.text = data['localidade'] ?? "";
        estadoController.text = data['uf'] ?? "";
        setState(() {});
      } else {
        mostrarErro("Erro ao buscar CEP (${resp.statusCode})");
      }
    } catch (e) {
      print("Erro ao buscar CEP: $e");
      mostrarErro("Erro ao buscar o endereço.");
    }
  }

  Future<void> salvar() async {
    final idEndereco = int.tryParse(enderecoIdController.text);
    final dto = {
      "clienteId":
          clienteSelecionado != null
              ? int.parse(clienteSelecionado!.split(' - ').first)
              : null,
      "orcamentoId":
          orcamentoSelecionado != null
              ? int.parse(orcamentoSelecionado!.split(' ')[1])
              : null,
      "contratoId":
          contratoSelecionado != null
              ? int.parse(contratoSelecionado!.split(' ')[1])
              : null,
      "executorId":
          executorSelecionado != null
              ? int.parse(executorSelecionado!.split(' - ').first)
              : null,
      "status": status,
      "dataInicio":
          dataInicioController.text.isNotEmpty
              ? _converterDataParaISO(dataInicioController.text)
              : null,
      "dataFim":
          dataFimController.text.isNotEmpty
              ? _converterDataParaISO(dataFimController.text)
              : null,
      "endereco": {
        "id": idEndereco,
        "logradouro": ruaController.text,
        "numero": numeroController.text,
        "complemento": complementoController.text,
        "bairro": bairroController.text,
        "cidade": cidadeController.text,
        "siglaEstado": estadoController.text,
        "cep": cepController.text,
      },
    };

    http.Response resp;
    if (widget.obraId != null) {
      final url = Uri.parse(
        "${AppConstants.baseUrl}/api/obras/${widget.obraId}",
      );
      resp = await _client.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(dto),
      );
    } else {
      final url = Uri.parse("${AppConstants.baseUrl}/api/obras");
      resp = await _client.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(dto),
      );
    }

    if (resp.statusCode == 200 || resp.statusCode == 201) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Obra salva com sucesso!')));
      Navigator.pop(context);
    } else {
      String mensagemErro = 'Erro ao salvar obra.';

      try {
        final data = jsonDecode(resp.body);
        if (data != null &&
            data is Map<String, dynamic> &&
            data.containsKey('message')) {
          mensagemErro = data['message'];
        }
      } catch (_) {
        // Se der erro no jsonDecode, mantém o erro genérico
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(mensagemErro)));
    }
  }

  String _converterDataParaPTBR(String data) {
    final date = DateTime.parse(data);
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String _converterDataParaISO(String data) {
    final partes = data.split("/");
    final novaData = DateTime(
      int.parse(partes[2]),
      int.parse(partes[1]),
      int.parse(partes[0]),
    );
    return novaData.toIso8601String().split("T").first;
  }

  void mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          widget.obraId == null ? "Cadastro de Obra" : "Editar Obra",
          style: AppTextStyles.headline,
        ),
        iconTheme: const IconThemeData(color: AppColors.accent),
      ),
      body:
          clientes.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dados da Obra',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFFBFA33F), // dourado Aura
            ),
          ),
          const SizedBox(height: 16),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: clienteSelecionado,
                  items:
                      clientes.map<DropdownMenuItem<String>>((c) {
                        final id = c['id'].toString();
                        final nome = c['nome'];
                        return DropdownMenuItem(
                          value: "$id - $nome",
                          child: Text(nome),
                        );
                      }).toList(),
                  onChanged: (val) async {
                    await selecionarCliente(val);
                    setState(() {});
                  },
                  decoration: const InputDecoration(labelText: 'Cliente'),
                ),

                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  value: orcamentoSelecionado,
                  items:
                      orcamentos.map<DropdownMenuItem<String>>((o) {
                        final id = o['id'].toString();
                        final tipo = o['tipo'];
                        return DropdownMenuItem(
                          value: "ID $id",
                          child: Text(tipo),
                        );
                      }).toList(),
                  onChanged: (val) async {
                    await selecionarOrcamento(val);
                    setState(() {});
                  },
                  decoration: const InputDecoration(labelText: 'Orçamento'),
                ),

                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  value: contratoSelecionado,
                  items:
                      contratoSelecionado == null
                          ? []
                          : [
                            DropdownMenuItem(
                              value: contratoSelecionado,
                              child: Text(contratoSelecionado!),
                            ),
                          ],
                  onChanged: null,
                  decoration: const InputDecoration(labelText: 'Contrato'),
                ),

                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  value: executorSelecionado,
                  items:
                      executores.map<DropdownMenuItem<String>>((e) {
                        final id = e['id'].toString();
                        final nome = e['nome'];
                        return DropdownMenuItem(
                          value: "$id - $nome",
                          child: Text(nome),
                        );
                      }).toList(),
                  onChanged: (val) {
                    executorSelecionado = val;
                    setState(() {});
                  },
                  decoration: const InputDecoration(labelText: 'Executor'),
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: dataInicioController,
                  decoration: const InputDecoration(labelText: 'Data Início'),
                  readOnly: true,
                  onTap: () async {
                    final data = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2035),
                    );
                    if (data != null) {
                      dataInicioController.text =
                          "${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}";
                    }
                  },
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: dataFimController,
                  decoration: const InputDecoration(labelText: 'Data Fim'),
                  readOnly: true,
                  onTap: () async {
                    final data = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2035),
                    );
                    if (data != null) {
                      dataFimController.text =
                          "${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}";
                    }
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          const Text(
            'Endereço',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFFBFA33F), // dourado Aura
            ),
          ),
          const SizedBox(height: 16),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextFormField(
                  controller: cepController,
                  focusNode: cepFocus,
                  decoration: const InputDecoration(labelText: 'CEP'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: ruaController,
                  decoration: const InputDecoration(labelText: 'Logradouro'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: numeroController,
                  decoration: const InputDecoration(labelText: 'Número'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: complementoController,
                  decoration: const InputDecoration(labelText: 'Complemento'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: bairroController,
                  decoration: const InputDecoration(labelText: 'Bairro'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: cidadeController,
                  decoration: const InputDecoration(labelText: 'Cidade'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: estadoController,
                  decoration: const InputDecoration(labelText: 'Estado'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          Center(
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: salvar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 53, 35, 30),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text("Salvar"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(String titulo, List<Widget> children) {
    return Container(
      decoration: AppTheme.cardBox,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: AppTextStyles.headline),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInput(
    String label,
    TextEditingController controller, {
    FocusNode? focus,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        focusNode: focus,
        controller: controller,
        style: AppTextStyles.body,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppTextStyles.body,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildReadOnly(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        readOnly: true,
        initialValue: value,
        style: AppTextStyles.body,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppTextStyles.body,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String? value,
    List<String> itens,
    Function(String?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: value,
        items:
            itens
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
        onChanged: onChanged,
        style: AppTextStyles.body,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppTextStyles.body,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildCampoData(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        style: AppTextStyles.body,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppTextStyles.body,
          border: const OutlineInputBorder(),
        ),
        onTap: () async {
          final data = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime(2035),
          );
          if (data != null) {
            controller.text =
                "${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}";
          }
        },
      ),
    );
  }
}
