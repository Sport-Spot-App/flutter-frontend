import 'package:flutter/material.dart';
import 'package:sport_spot/common/constants/app_colors.dart';
import 'package:sport_spot/common/constants/app_text_styles.dart';
import 'package:sport_spot/common/widgets/primary_button.dart';
import 'package:sport_spot/routes/routing_constants.dart';

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
              child: Image.asset('assets/images/basketball_court.png'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'Organize suas partidas em minutos',
                  style: AppTextStyles.bigText.copyWith(
                    color: AppColors.charcoalBlue,
                    height: 1,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                PrimaryButton(
                  text: "Entrar",
                  onPressed: () {
                    Navigator.of(context).pushNamed(login);
                  },
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(registerRole);
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
        ],
      ),
    );
  }
}
