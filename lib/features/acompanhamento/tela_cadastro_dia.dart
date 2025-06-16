import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'acompanhamento_dtos.dart';
import 'provider.dart';

class TelaCadastroDia extends StatefulWidget {
  final int obraId;
  final DateTime dataRegistro;

  const TelaCadastroDia({
    super.key,
    required this.obraId,
    required this.dataRegistro,
  });

  @override
  State<TelaCadastroDia> createState() => _TelaCadastroDiaState();
}

class _TelaCadastroDiaState extends State<TelaCadastroDia> {
  final _tarefaController = TextEditingController();
  List<String> tarefas = [];
  List<String> concluidas = [];
  String observacao = "";
  bool carregado = false;
  int? idRegistro;

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  void carregarDados() async {
    final provider = Provider.of<AcompanhamentoProvider>(
      context,
      listen: false,
    );
    final dto = await provider.buscarPorData(
      widget.obraId,
      widget.dataRegistro,
    );

    if (dto != null) {
      idRegistro = dto.id;
      tarefas = List<String>.from(dto.tarefas);
      concluidas = List<String>.from(dto.tarefasConcluidas);
      observacao = dto.observacoes ?? "";
    }
    setState(() {
      carregado = true;
    });
  }

  void adicionarTarefa() {
    final texto = _tarefaController.text.trim();
    if (texto.isNotEmpty) {
      setState(() {
        tarefas.add(texto);
        _tarefaController.clear();
      });
    }
  }

  void salvar() async {
    final provider = Provider.of<AcompanhamentoProvider>(
      context,
      listen: false,
    );
    final dto = AcompanhamentoCadastroDTO(
      id: idRegistro,
      obraId: widget.obraId,
      dataRegistro: widget.dataRegistro,
      tarefas: tarefas,
      tarefasConcluidas: concluidas,
      observacoes: observacao,
    );

    if (idRegistro == null) {
      await provider.salvar(dto);
    } else {
      await provider.editar(dto);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (!carregado) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Dia ${widget.dataRegistro.day}/${widget.dataRegistro.month}",
          style: TextStyle(
            color: Color(0xFFD4AF37),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF3B2626),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _tarefaController,
                    decoration: const InputDecoration(labelText: "Nova tarefa"),
                    onSubmitted: (_) => adicionarTarefa(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: adicionarTarefa,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: tarefas.length,
                itemBuilder: (context, index) {
                  final tarefa = tarefas[index];
                  final isConcluida = concluidas.contains(tarefa);
                  return CheckboxListTile(
                    title: Text(tarefa),
                    value: isConcluida,
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          concluidas.add(tarefa);
                        } else {
                          concluidas.remove(tarefa);
                        }
                      });
                    },
                  );
                },
              ),
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Observações"),
              onChanged: (value) => observacao = value,
              controller: TextEditingController(text: observacao),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4AF37),
              ),
              onPressed: salvar,
              child: const Text("Salvar"),
            ),
          ],
        ),
      ),
    );
  }
}
