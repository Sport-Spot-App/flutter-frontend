import 'package:flutter/material.dart';
import 'package:sport_spot/common/constants/app_colors.dart';
import 'package:sport_spot/common/constants/app_text_styles.dart';
import 'package:sport_spot/common/widgets/role_button.dart';
import 'package:sport_spot/routes/routing_constants.dart';

class RegisterRoleSelectionPage extends StatelessWidget {
  const RegisterRoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  }, 
                  icon: Icon(Icons.arrow_back),
                ),
              ),
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
                  Navigator.of(context).pushNamed(registerForm, arguments: {'role': 2});
                },
              ),
              const SizedBox(height: 20),
              RoleButton(
                title: "Atleta",
                imagePath: 'assets/images/soccer_players.png',
                onPressed: () {
                  Navigator.of(context).pushNamed(registerForm, arguments: {'role': 3});
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
