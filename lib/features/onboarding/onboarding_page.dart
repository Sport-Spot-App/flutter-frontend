import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/constants/app_colors.dart';
import 'package:flutter_application_1/common/constants/app_text_styles.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex:2,
            child: 
            Container(
              color: AppColors.lightOrange,
              child: Image.asset('assets/images/basketball_court.png')
            )
          ),
          Text('Organize suas', style: AppTextStyles.mediumText.copyWith(
            color: AppColors.charcoalBlue)
          ),
          const Text('partidas em minutos', style: AppTextStyles.mediumText)
        ],
      ),
    );
  }
}