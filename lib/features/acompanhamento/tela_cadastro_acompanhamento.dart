import 'package:flutter/material.dart';

class TelaCadastroDia extends StatefulWidget {
  final int obraId;
  final DateTime dataRegistro;

  const TelaCadastroDia({super.key, required this.obraId, required this.dataRegistro});

  @override
  State<TelaCadastroDia> createState() => _TelaCadastroDiaState();
}

class _TelaCadastroDiaState extends State<TelaCadastroDia> {
  final _tarefaController = TextEditingController();
  List<String> tarefas = [];
  List<String> concluidas = [];
  String observacao = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dia ${widget.dataRegistro.day}/${widget.dataRegistro.month}"),
        backgroundColor: const Color(0xFF3B2626),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: _tarefaController,
              decoration: const InputDecoration(labelText: "Adicionar tarefa"),
              onSubmitted: (value) {
                setState(() {
                  tarefas.add(value);
                  _tarefaController.clear();
                });
              },
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
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4AF37)),
              onPressed: () {
                // Aqui chamaria o service para salvar
                Navigator.pop(context);
              },
              child: const Text("Salvar"),
            ),
          ],
        ),
      ),
    );
  }
}
