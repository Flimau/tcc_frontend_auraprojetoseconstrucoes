import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:front_application/theme/theme.dart';

class TelaLogin extends StatelessWidget {
  const TelaLogin({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
          //child: CardContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              // LOGO
              Image.asset('assets/images/logo_aura_removebg.png', width: 180),

              const SizedBox(height: 20),
              // TÍTULOS
              Text('AURA CONSTRUÇÕES', style: AppTextStyles.headline),
              Text(
                'PROJETOS | CONSTRUÇÕES | ACABAMENTOS',
                style: AppTextStyles.subtitle,
              ),
              const SizedBox(height: 16),
              const Text(
                'Bem-vindo(a) de volta!',
                style: AppTextStyles.headline,
              ),

              const SizedBox(height: 40),

              // CAMPO EMAIL
              TextField(
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: Icon(Icons.mail, color: AppColors.accent),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              // CAMPO SENHA
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: Icon(Icons.lock, color: AppColors.accent),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 8),

              // TEXTO "Esqueceu a senha?"
              Align(
                alignment: Alignment.centerRight,
                child: Text('Esqueceu a senha?', style: AppTextStyles.link),
              ),

              const SizedBox(height: 24),

              // BOTÃO LOGIN
              ElevatedButton(
                onPressed: () {},
                child: const Text('Entrar', style: AppTextStyles.fontButton),
              ),

              // TEXTO DE CADASTRO
              const SizedBox(height: 24),

              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Não tem uma conta? ',
                      style: AppTextStyles.body,
                    ),
                    TextSpan(
                      text: 'Cadastre-se aqui!',
                      style: AppTextStyles.link,
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(context, '/cadastro');
                            },
                    ),
                  ],
                ),
              ),
            ],
          ),
          //),
        ),
      ),
    );
  }
}
