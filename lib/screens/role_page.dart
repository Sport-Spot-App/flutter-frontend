import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/constants/app_colors.dart';
import 'package:flutter_application_1/common/constants/app_text_styles.dart';
import 'package:flutter_application_1/common/widgets/role_button.dart';

class RegisterRoleSelectionPage extends StatelessWidget {
  const RegisterRoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Título da página
              Text(
                "Como deseja se cadastrar?",
                style: AppTextStyles.mediumText.copyWith(
                  color: AppColors.darkOrange,
                  height: 1,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              RoleButton(
                title: "Dono de Quadra",
                imagePath: 'assets/images/basketball_court.png',
                onPressed: () {
                  print("Dono de Quadra selecionado");
                  Navigator.pushNamed(context, '/register-form',
                      arguments: {'role': 2});
                },
              ),
              const SizedBox(height: 20),
              RoleButton(
                title: "Atleta",
                imagePath: 'assets/images/soccer_players.png',
                onPressed: () {
                  print("Atleta selecionado");
                  Navigator.pushNamed(context, '/register-form',
                      arguments: {'role': 3});
                },
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
