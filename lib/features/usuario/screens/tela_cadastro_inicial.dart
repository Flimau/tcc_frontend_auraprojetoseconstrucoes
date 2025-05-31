import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../theme/theme.dart';

class TelaCadastro extends StatelessWidget {
  const TelaCadastro({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                Text('AURA CONSTRUÇÕES', style: AppTextStyles.headline),
                Text(
                  'PROJETOS | CONSTRUÇÕES | ACABAMENTOS',
                  style: AppTextStyles.subtitle,
                ),
                const SizedBox(height: 16),

                const Text('Crie sua conta', style: AppTextStyles.headline),

                const SizedBox(height: 32),

                // CAMPO EMAIL/TELEFONE
                TextField(
                  decoration: InputDecoration(
                    labelText: 'E-mail ou telefone',
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

                const SizedBox(height: 24),

                // BOTÃO CRIAR CONTA
                ElevatedButton(
                  onPressed: () {
                    //print('Conta criada!');
                  },
                  child: const Text(
                    'Criar conta',
                    style: AppTextStyles.fontButton,
                  ),
                ),

                const SizedBox(height: 24),

                // BOTÃO LOGIN COM GOOGLE (simples por enquanto)
                OutlinedButton.icon(
                  onPressed: () {
                    print('Login com Google');
                  },
                  icon: Image.asset(
                    'assets/images/google_icon.png',
                    width: 24,
                    height: 24,
                  ),
                  label: const Text('Entrar com Google'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    foregroundColor: AppColors.primary,
                    side: BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // LINK JÁ TEM CONTA
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Já tem uma conta? ',
                        style: AppTextStyles.body,
                      ),
                      TextSpan(
                        text: 'Faça login',
                        style: AppTextStyles.link,
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pop(
                                  context,
                                ); // volta pra tela de login
                              },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
