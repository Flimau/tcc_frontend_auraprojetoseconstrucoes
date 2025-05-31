import 'package:flutter/material.dart';

import '../models/visita.dart';
import '../screens/tela_cadastro_visita.dart';

class VisitaCard extends StatelessWidget {
  final Visita visita;

  const VisitaCard({super.key, required this.visita});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('Endereço: ${visita.endereco}'),
        subtitle: Text('Data: ${visita.data}'),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TelaCadastroVisita()),
            );
          },
        ),
      ),
    );
  }
}
