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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              Image.asset('assets/images/logo_aura_removebg.png', width: 180),

              const SizedBox(height: 20),
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

              TextField(
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: Icon(Icons.mail, color: AppColors.accent),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: Icon(Icons.lock, color: AppColors.accent),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 8),

              Align(
                alignment: Alignment.centerRight,
                child: Text('Esqueceu a senha?', style: AppTextStyles.link),
              ),

              const SizedBox(height: 24),

              // BOTÃO LOGIN
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/home');
                },
                child: const Text('Entrar', style: AppTextStyles.fontButton),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
