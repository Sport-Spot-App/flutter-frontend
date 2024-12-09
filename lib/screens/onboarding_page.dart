import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/constants/app_colors.dart';
import 'package:flutter_application_1/common/constants/app_text_styles.dart';
import 'package:flutter_application_1/common/widgets/primary_button.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              flex: 2,
              child: Container(
                  color: AppColors.lightOrange,
                  child: Image.asset('assets/images/basketball_court.png'))),
          const SizedBox(height: 30),
          Text(
            'Organize suas partidas em minutos',
            style: AppTextStyles.mediumText.copyWith(
              color: AppColors.charcoalBlue,
              height: 1,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            text: "Entrar",
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
          ),
          const SizedBox(height: 10),
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
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
