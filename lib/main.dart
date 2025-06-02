import 'package:flutter/material.dart';

import 'features/agenda/screens/tela_kanban_obras.dart';
import 'features/contrato/screens/tela_cadastro_contrato.dart';
import 'features/contrato/screens/tela_listar_contratos.dart';
import 'features/home/screens/tela_home.dart';
import 'features/obra/screens/tela_acompanhamento_obra.dart';
import 'features/obra/screens/tela_cadastro_obra.dart';
import 'features/obra/screens/tela_listar_obras.dart';
import 'features/orcamento/screens/tela_listar_orcamentos.dart';
import 'features/usuario/screens/tela_ativacao_usuario.dart';
import 'features/usuario/screens/tela_cadastro_usuario.dart';
import 'features/usuario/screens/tela_listar_usuarios.dart';
import 'features/usuario/screens/tela_login.dart';
import 'features/visita/screens/tela_cadastro_visita.dart';
import 'features/visita/screens/tela_listar_visitas.dart';
import 'theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TCC Construção',
      theme: AppTheme.theme,
      initialRoute: '/home',
      routes: {
        '/login': (context) => const TelaLogin(),
        '/home': (context) => const TelaHome(),

        // Usuário
        '/cadastro_usuario': (context) => const TelaCadastroUsuario(),
        '/tela_listar_usuarios': (context) => const TelaListarUsuarios(),
        '/tela_ativacao_usuario': (context) => const TelaAtivacaoUsuario(),

        // Orçamento
        '/orcamento': (context) => const TelaListarOrcamentos(),

        // Obra
        '/cadastro_obra': (context) => const TelaCadastroObra(),
        '/tela_listar_obras': (context) => const TelaListarObras(),
        '/acompanhamento_obra': (context) {
          final obraId = ModalRoute.of(context)!.settings.arguments as String;
          return TelaAcompanhamentoObra(obraId: obraId);
        },
        '/kanban_obras': (context) => const TelaKanbanObras(),

        // Contrato
        '/cadastro_contrato': (context) => const TelaCadastroContrato(),
        '/tela_listar_contratos': (context) => const TelaListarContratos(),

        // Visita
        '/registro_visita': (context) => const TelaCadastroVisita(),
        '/tela_listar_visitas': (context) => const TelaListarVisitas(),
      },
    );
  }
}
