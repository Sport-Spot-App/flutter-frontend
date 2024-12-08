import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/widgets/primary_button.dart';
import 'package:flutter_application_1/common/widgets/input_field.dart';
import 'package:flutter_application_1/common/constants/app_text_styles.dart';
import 'package:flutter_application_1/common/constants/app_colors.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Bem-vindo(a)!",
                style: AppTextStyles.mediumText.copyWith(
                  color: AppColors.darkOrange,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Image.asset(
                'assets/images/soccer_players.png',
                height: 200,
              ),
              const SizedBox(height: 20),
              const InputField(
                label: "EMAIL",
              ),
              const SizedBox(height: 20),
              const InputField(
                label: "SENHA",
                isPassword: true,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    print("Esqueceu a senha pressionado");
                  },
                  child: const Text(
                    "Esqueceu a senha?",
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              PrimaryButton(
                text: "Entrar",
                onPressed: () {
                  Navigator.pushNamed(context, '/users');
                  print("Entrar pressionado");
                },
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register-role');
                },
                child: const Text.rich(
                  TextSpan(
                    text: "Não Possui Uma Conta? ",
                    style: TextStyle(color: Colors.black54),
                    children: [
                      TextSpan(
                        text: "Registrar",
                        style: TextStyle(color: Color(0xFFF85B00)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
