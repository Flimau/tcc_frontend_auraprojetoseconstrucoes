import 'package:flutter/material.dart';

import '../models/usuario.dart';
import '../screens/tela_cadastro_usuario.dart';

class UsuarioCard extends StatelessWidget {
  final Usuario usuario;

  const UsuarioCard({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(usuario.nome),
        subtitle: Text('Tipo: ${usuario.documento}'),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const TelaCadastroUsuario(), // ou com id
              ),
            );
          },
        ),
      ),
    );
  }
}
