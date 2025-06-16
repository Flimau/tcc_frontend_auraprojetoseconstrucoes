import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../features/acompanhamento/provider.dart';
import '../features/acompanhamento/tela_acompanhamento_obra.dart';
import '../features/acompanhamento/tela_cadastro_dia.dart';
import '../features/auth/screens/tela_ativacao_usuario.dart';
import '../features/auth/screens/tela_login.dart';
import '../features/contrato/screens/tela_cadastro_contrato.dart';
import '../features/contrato/screens/tela_listar_contratos.dart';
import '../features/home/screens/tela_home.dart';
import '../features/obra/tela_cadastro_obra.dart';
import '../features/obra/tela_listar_obras.dart';
import '../features/obra/tela_visualizar_obra.dart';
import '../features/orcamento/screens/tela_cadastro_orcamento.dart';
import '../features/orcamento/screens/tela_listar_orcamentos.dart';
import '../features/usuario/screens/tela_cadastro_usuario.dart';
import '../features/usuario/screens/tela_listar_usuarios.dart';
import '../features/visita/screens/tela_cadastro_visita.dart';
import '../features/visita/screens/tela_listar_visitas.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => const TelaLogin());
      case '/home':
        return MaterialPageRoute(builder: (_) => const TelaHome());
      case '/tela_ativacao_usuario':
        return MaterialPageRoute(builder: (_) => const TelaAtivacaoUsuario());
      case '/tela_listar_usuarios':
        return MaterialPageRoute(builder: (_) => const TelaListarUsuarios());
      case '/tela_cadastro_usuario':
        return MaterialPageRoute(builder: (_) => const TelaCadastroUsuario());
      case '/tela_listar_orcamentos':
        return MaterialPageRoute(builder: (_) => const TelaListarOrcamentos());
      case '/tela_cadastro_orcamento':
        return MaterialPageRoute(builder: (_) => const TelaCadastroOrcamento());
      case '/tela_listar_contratos':
        return MaterialPageRoute(builder: (_) => const TelaListarContratos());
      case '/tela_cadastro_contrato':
        return MaterialPageRoute(builder: (_) => const TelaCadastroContrato());

      case '/tela_listar_visitas':
        return MaterialPageRoute(builder: (_) => const TelaListarVisitas());
      case '/tela_cadastro_visita':
        return MaterialPageRoute(builder: (_) => const TelaCadastroVisita());
      case '/tela_listar_obras':
        return MaterialPageRoute(builder: (_) => const TelaListarObras());
      case '/tela_cadastro_obra':
        final obraId = args as int?;
        return MaterialPageRoute(
          builder: (_) => TelaCadastroObra(obraId: obraId),
        );
      case '/tela_visualizar_obra':
        final obraId = args as int;
        return MaterialPageRoute(
          builder: (_) => TelaVisualizarObra(obraId: obraId),
        );

      case '/tela_acompanhamento_obra':
        final obraId = args as int;
        return MaterialPageRoute(
          builder:
              (_) => ChangeNotifierProvider(
                create: (_) => AcompanhamentoProvider(),
                child: TelaAcompanhamentoObra(obraId: obraId),
              ),
        );

      case '/tela_cadastro_dia':
        final arguments = args as Map<String, dynamic>;
        final obraId = arguments['obraId'] as int;
        final dataRegistro = arguments['dataRegistro'] as DateTime;
        return MaterialPageRoute(
          builder:
              (_) =>
                  TelaCadastroDia(obraId: obraId, dataRegistro: dataRegistro),
        );

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
