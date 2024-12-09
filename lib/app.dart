import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/onboarding_page.dart';
import 'package:flutter_application_1/screens/login_page.dart';
import 'package:flutter_application_1/screens/register_page.dart';
import 'package:flutter_application_1/screens/role_page.dart';
import 'package:flutter_application_1/screens/user_page.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    await Future.delayed(const Duration(seconds: 5));
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const OnboardingPage(),
        '/login': (context) => LoginPage(),
        '/register-role': (context) => const RegisterRoleSelectionPage(),
        '/register-form': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map?;
          final role = args?['role'] as int? ?? 0;
          return RegisterPage(role: role);
        },
        '/users': (context) => const UserListPage(),
      },
    );
  }
}
