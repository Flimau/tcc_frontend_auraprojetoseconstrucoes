import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // <- importa o provider
import 'features/acompanhamento/provider.dart'; // <- importa teu AcompanhamentoProvider

import 'routes/route_generator.dart';

void main() {
  runApp(const AuraApp());
}

class AuraApp extends StatelessWidget {
  const AuraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AcompanhamentoProvider()),
        // Aqui tu pode ir adicionando outros Providers no futuro
      ],
      child: MaterialApp(
        title: 'Aura Projetos e Construções',
        initialRoute: '/login',
        onGenerateRoute: RouteGenerator.generateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
