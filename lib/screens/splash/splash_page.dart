import 'package:flutter/material.dart';
import 'package:sport_spot/api/api.dart';
import 'package:sport_spot/api/token/token_storage.dart';
import 'package:sport_spot/repositories/auth_repository.dart';
import 'package:sport_spot/routes/routing_constants.dart';
import 'package:sport_spot/stores/auth_store.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final AuthStore store = AuthStore(repository: AuthRepository(Api()));

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () async {
      final tokenStorage = TokenStorage();
      String? token = await tokenStorage.read();
      if (token != null) {
        await store.getAuthData();
        if (!mounted) return;
        Navigator.of(context).pushNamedAndRemoveUntil(home, (route) => false);
      } else {
        if (!mounted) return;
        Navigator.of(context).pushNamedAndRemoveUntil(onboarding, (route) => false);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final maxHeight = constraints.maxHeight;
          final maxWidth = constraints.maxWidth;

          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/background_gradient.png',
                  fit: BoxFit.cover,
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo-sportspot.png',
                      width: maxWidth * 0.6, 
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: maxHeight * 0.02),
                    Image.asset(
                      'assets/images/branding-sportspot.png',
                      width: maxWidth * 0.6,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
