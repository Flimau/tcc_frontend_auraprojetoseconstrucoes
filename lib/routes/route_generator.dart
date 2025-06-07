import 'package:flutter/material.dart';

import '../features/agenda/screens/tela_cadastro_agenda.dart';
import '../features/agenda/screens/tela_kanban.dart';
import '../features/agenda/screens/tela_kanban_obras.dart';
import '../features/agenda/screens/tela_listar_agenda.dart';
import '../features/contrato/screens/pdf_viewer_page.dart';
import '../features/contrato/screens/tela_cadastro_contrato.dart';
import '../features/contrato/screens/tela_listar_contratos.dart';
import '../features/home/screens/tela_home.dart';
import '../features/obra/screens/tela_cadastro_diario.dart';
import '../features/obra/screens/tela_cadastro_obra.dart';
import '../features/obra/screens/tela_listar_diarios.dart';
import '../features/obra/screens/tela_listar_obras.dart';
import '../features/orcamento/screens/tela_cadastro_orcamento.dart';
import '../features/orcamento/screens/tela_listar_orcamentos.dart';
import '../features/usuario/screens/tela_ativacao_usuario.dart';
import '../features/usuario/screens/tela_cadastro_usuario.dart';
import '../features/usuario/screens/tela_listar_usuarios.dart';
import '../features/usuario/screens/tela_login.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => const TelaLogin());

      case '/home':
        return MaterialPageRoute(builder: (_) => const TelaHome());

      // Usuários
      case '/tela_ativacao_usuario':
        return MaterialPageRoute(builder: (_) => const TelaAtivacaoUsuario());
      case '/tela_listar_usuarios':
        return MaterialPageRoute(builder: (_) => const TelaListarUsuarios());
      case '/tela_cadastro_usuario':
        return MaterialPageRoute(builder: (_) => const TelaCadastroUsuario());

      // Orçamentos
      case '/tela_listar_orcamentos':
        return MaterialPageRoute(builder: (_) => const TelaListarOrcamentos());
      case '/tela_cadastro_orcamento':
        return MaterialPageRoute(builder: (_) => const TelaCadastroOrcamento());

      // Contratos
      case '/tela_listar_contratos':
        return MaterialPageRoute(builder: (_) => const TelaListarContratos());
      case '/tela_cadastro_contrato':
        return MaterialPageRoute(builder: (_) => const TelaCadastroContrato());
      case '/visualizar_pdf':
        final filePath = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => PdfViewerPage(filePath: filePath),
        );

      // Obras
      case '/tela_listar_obras':
        return MaterialPageRoute(builder: (_) => const TelaListarObras());
      case '/tela_cadastro_obra':
        final obraId = args as int?;
        return MaterialPageRoute(
          builder: (_) => TelaCadastroObra(obraId: obraId),
        );
      case '/tela_listar_diarios':
        final obraId = args as int;
        return MaterialPageRoute(
          builder: (_) => TelaListarDiarios(obraId: obraId),
        );
      case '/tela_cadastro_diario':
        final map = args as Map<String, dynamic>;
        final int obraId = map['obraId'];
        final int? diarioId = map['diarioId'];
        return MaterialPageRoute(
          builder:
              (_) => TelaCadastroDiario(obraId: obraId, diarioId: diarioId),
        );

      // Agenda e Kanban
      case '/tela_listar_agenda':
        return MaterialPageRoute(builder: (_) => const TelaListarAgenda());
      case '/tela_cadastro_agenda':
        return MaterialPageRoute(builder: (_) => const TelaCadastroAgenda());
      case '/tela_kanban':
        return MaterialPageRoute(builder: (_) => const TelaKanban());
      case '/tela_kanban_obras':
        return MaterialPageRoute(builder: (_) => const TelaKanbanObras());

      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(
                  child: Text('Rota não encontrada: ${settings.name}'),
                ),
              ),
        );
    }
  }
}
