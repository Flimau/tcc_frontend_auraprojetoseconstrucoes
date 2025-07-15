import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/acompanhamento/provider.dart';
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
