import 'package:flutter/material.dart';
import 'package:sport_spot/api/api.dart';
import 'package:sport_spot/common/constants/app_colors.dart';
import 'package:sport_spot/common/constants/app_text_styles.dart';
import 'package:sport_spot/common/widgets/input_field.dart';
import 'package:sport_spot/common/widgets/primary_button.dart';
import 'package:sport_spot/repositories/auth_repository.dart';
import 'package:sport_spot/routes/routing_constants.dart';
import 'package:sport_spot/stores/auth_store.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthStore store = AuthStore(repository: AuthRepository(Api()));

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
      Navigator.of(context).pushNamedAndRemoveUntil(profile, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 50),
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
