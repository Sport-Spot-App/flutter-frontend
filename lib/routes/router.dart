import 'package:flutter/material.dart';
import 'package:sport_spot/routes/routing_constants.dart';
import 'package:sport_spot/screens/auth/confirm_register.dart';
import 'package:sport_spot/screens/auth/login_page.dart';
import 'package:sport_spot/screens/auth/onboarding_page.dart';
import 'package:sport_spot/screens/auth/register_page.dart';
import 'package:sport_spot/screens/court/favorites_page.dart';
import 'package:sport_spot/screens/home/home_page.dart';
import 'package:sport_spot/screens/profile/court_owner.dart';
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
      case home:
        screen = HomePage();
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
      case favorites:
        screen = FavoritesPage();
        break;
       case confirmRegister:
        screen = RegistrationCompletedPage();
        break;
       case courtOwner:
        screen = CourtOwnerApprovalPage();
        break;
      default:
        screen = OnboardingPage();
    }

    return MaterialPageRoute(builder: (BuildContext context) => screen);
  };
}