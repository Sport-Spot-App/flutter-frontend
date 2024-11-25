import 'package:flutter/material.dart';

import '../../common/constants/app_colors.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.orangeGradient,
          ),
        ),
        child: Image.asset('assets/images/SPORT_SPOT.png'),
      ),
    );
  }
}