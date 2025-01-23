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
        Navigator.of(context).pushNamedAndRemoveUntil(profile, (route) => false);
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil(onboarding, (route) => false);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset('assets/images/background_gradient.png'),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Center(
              child: Column(
                children: [
                  Image.asset('assets/images/logo-sportspot.png', width: 250),
                  Image.asset('assets/images/branding-sportspot.png', width: 250),
                ],
              ) 
            ),
          ],
        ),
      ],
    );
  }
}