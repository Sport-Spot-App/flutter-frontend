import 'package:flutter/material.dart';
import 'package:sport_spot/routes/routing_constants.dart';
import 'package:sport_spot/screens/auth/login_page.dart';
import 'package:sport_spot/screens/auth/onboarding_page.dart';
import 'package:sport_spot/screens/auth/register_page.dart';
import 'package:sport_spot/screens/profile/profile_page.dart';
import 'package:sport_spot/screens/auth/role_page.dart';
import 'package:sport_spot/screens/splash/splash_page.dart';
import 'package:sport_spot/screens/user/user_page.dart';

RouteFactory rotas() {
  return (settings) {
    Object? obj = settings.arguments;
    Widget screen;

    switch (settings.name) {
      case splash:
        screen = SplashPage();
        break;
      case onboarding:
        screen = OnboardingPage();
        break;
      case login:
        screen = LoginPage();
        break;
      case registerRole:
        screen = RegisterRoleSelectionPage();
        break;
      case registerForm:
        int role = (obj as Map<String, int>)["role"] ?? 0;
        screen = RegisterPage(role: role);
        break;
      case profile:
        screen = ProfilePage();
        break;
      case users:
        screen = UserListPage();
        break;
      default:
        screen = OnboardingPage();
    }

    return MaterialPageRoute(builder: (BuildContext context) => screen);
  };
}