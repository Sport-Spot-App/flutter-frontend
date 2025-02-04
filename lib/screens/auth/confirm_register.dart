import 'package:flutter/material.dart';
import 'package:sport_spot/common/constants/app_colors.dart';
import 'package:sport_spot/common/constants/app_text_styles.dart';
import 'package:sport_spot/common/widgets/primary_button.dart';
import 'package:sport_spot/routes/routing_constants.dart';

class RegistrationCompletedPage extends StatelessWidget {
  final int role;
  const RegistrationCompletedPage({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Container para a imagem circular de fundo e a imagem principal
          Expanded(
            child: Container(
              color: AppColors.lightOrange,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Imagem de fundo (círculos)
                  Image.asset(
                    'assets/images/circles.png', // Substitua pelo caminho correto
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  // Imagem principal
                  Image.asset(
                    'assets/images/sport-family-amico.png', // Substitua pelo caminho correto
                    fit: BoxFit.contain,
                    width: 200,
                    height: 200,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 50),
          Text(
            'Cadastro Concluído!',
            style: AppTextStyles.bigText.copyWith(
              color: AppColors.charcoalBlue,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          if (role == 2)
            const Text(
              'Aguarde a Aprovação de um Administrador',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 50),
          PrimaryButton(
            text: 'Realizar Login',
            onPressed: () {
              Navigator.of(context).pushNamed(login);
            },
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
