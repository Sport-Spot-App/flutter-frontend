import 'package:flutter/material.dart';
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
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ValueListenableBuilder<bool>(
                valueListenable: store.isLoading,
                builder: (context, isLoading, child) {
                  return ElevatedButton(
                    onPressed: isLoading ? null : () => _handleLogin(context),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Entrar'),
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
