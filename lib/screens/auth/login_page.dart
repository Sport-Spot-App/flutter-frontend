import 'package:flutter/material.dart';
import 'package:sport_spot/api/api.dart';
import 'package:sport_spot/common/constants/app_colors.dart';
import 'package:sport_spot/common/constants/app_text_styles.dart';
import 'package:sport_spot/common/widgets/input_field.dart';
import 'package:sport_spot/common/widgets/primary_button.dart';
import 'package:sport_spot/repositories/auth_repository.dart';
import 'package:sport_spot/routes/routing_constants.dart';
import 'package:sport_spot/stores/auth_store.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthStore store = AuthStore(repository: AuthRepository(Api()));

  String? emailError;
  String? passwordError;

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  void _validateEmail() {
    final email = emailController.text.trim();
    setState(() {
      if (email.isEmpty) {
        emailError = 'O campo de e-mail é obrigatório.';
      } else if (!_isValidEmail(email)) {
        emailError = 'Por favor, insira um e-mail válido.';
      } else {
        emailError = null;
      }
    });
  }

  void _validatePassword() {
    final password = passwordController.text.trim();
    setState(() {
      if (password.isEmpty) {
        passwordError = 'O campo de senha é obrigatório.';
      } else if (password.length < 6) {
        passwordError = 'A senha deve ter pelo menos 6 caracteres.';
      } else {
        passwordError = null;
      }
    });
  }

  void _handleLogin(BuildContext context) async {
    _validateEmail();
    _validatePassword();

    if (emailError != null || passwordError != null) {
      return;
    }

    final email = emailController.text.trim();
    final password = passwordController.text;

    await store.login(email, password);

    if (store.error.value.isNotEmpty) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(store.error.value)),
      );
    } else {
      await store.getAuthData();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login realizado com sucesso!')),
      );
      Navigator.of(context).pushNamedAndRemoveUntil(home, (route) => false);
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
              const SizedBox(height: 50),
              Text(
                'Bem-vindo(a)!',
                style: AppTextStyles.bigText.copyWith(
                  color: AppColors.darkOrange,
                  height: 1,
                ),
              ),
              Image.asset('assets/images/soccer_players.png'),
              InputField(
                controller: emailController,
                label: 'EMAIL',
                onChanged: (_) => _validateEmail(),
              ),
              if (emailError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 8),
                  child: Text(
                    emailError!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                ),
              InputField(
                controller: passwordController,
                label: 'SENHA',
                isPassword: true,
                onChanged: (_) => _validatePassword(),
              ),
              if (passwordError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 8),
                  child: Text(
                    passwordError!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
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
