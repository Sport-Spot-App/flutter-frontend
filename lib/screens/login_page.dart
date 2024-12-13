import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/constants/app_colors.dart';
import 'package:flutter_application_1/common/constants/app_text_styles.dart';
import 'package:flutter_application_1/common/widgets/input_field.dart';
import 'package:flutter_application_1/common/widgets/primary_button.dart';
import 'package:flutter_application_1/repositories/auth_repository.dart';
import 'package:flutter_application_1/screens/stores/auth_store.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthStore store = AuthStore(repository: AuthRepository());

  LoginPage({super.key});

  void _handleLogin(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos')),
      );
      return;
    }

    await store.login(email, password);

    if (store.error.value.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(store.error.value)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login realizado com sucesso!')),
      );
      Navigator.pushReplacementNamed(
          context, '/users'); // Navegar para a próxima tela
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.transparent,),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Bem-vindo(a)!',
                style: AppTextStyles.mediumText.copyWith(
                  color: AppColors.darkOrange,
                  height: 1,
                ),
              ),
              Image.asset('assets/images/soccer_players.png'),
              InputField(
                controller: emailController,
                label: 'EMAIL',
              ),
              InputField(
                controller: passwordController,
                isPassword: true,
                label: 'SENHA',
              ),
              const SizedBox(height: 16),
              ValueListenableBuilder<bool>(
                valueListenable: store.isLoading,
                builder: (context, isLoading, child) {
                  return PrimaryButton(
                    text: isLoading ? 'Carregando...' : 'Entrar',
                    onPressed: isLoading ? null : () => _handleLogin(context),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
