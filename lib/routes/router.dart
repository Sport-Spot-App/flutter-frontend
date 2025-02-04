import 'package:flutter/material.dart';
import 'package:sport_spot/models/court_model.dart';
import 'package:sport_spot/routes/routing_constants.dart';
import 'package:sport_spot/screens/auth/confirm_register.dart';
import 'package:sport_spot/screens/auth/login_page.dart';
import 'package:sport_spot/screens/auth/onboarding_page.dart';
import 'package:sport_spot/screens/auth/register_page.dart';
import 'package:sport_spot/screens/court/courts_page.dart';
import 'package:sport_spot/screens/court/favorites_page.dart';
import 'package:sport_spot/screens/court/view_court_page.dart';
import 'package:sport_spot/screens/home/app_navigation.dart';
import 'package:sport_spot/screens/home/home_page.dart';
import 'package:sport_spot/screens/profile/court_owner.dart';
import 'package:sport_spot/screens/profile/profile_page.dart';
import 'package:sport_spot/screens/auth/role_page.dart';
import 'package:sport_spot/screens/splash/splash_page.dart';
import 'package:sport_spot/screens/user/adm_users.dart';

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
      case confirmRegister:
        int role = (obj as Map<String, int>)["role"] ?? 0;
        screen = RegistrationCompletedPage(role: role);
        break;
      case appNavigation:
        screen = AppNavigation();
        break;
      case home:
        screen = HomePage();
        break;
      case favorites:
        screen = FavoritesPage();
        break;
      case profile:
        screen = ProfilePage();
        break;
      case viewCourt:
        final court = obj as CourtModel;
        screen = ViewCourtPage(court: court);
        break;
      case courtOwner:
        screen = CourtOwnerApprovalPage();
        break;
      case 'admUsers':
        screen = AdmUsersScreen();
        break;
      case courtPage:
        screen = CourtsPage();
        break;
      default:
        screen = OnboardingPage();
    }

    return MaterialPageRoute(builder: (BuildContext context) => screen);
  };
}
