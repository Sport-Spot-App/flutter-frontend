import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/onboarding/onboarding_page.dart';
import 'package:flutter_application_1/features/login/login_page.dart';
import 'package:flutter_application_1/features/register/role_page.dart';
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

  void initialization() async{
    print('pausing...');
    await Future.delayed(const Duration(seconds: 3));
    print('unpausing');
    FlutterNativeSplash.remove();

  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const OnboardingPage(),
        '/login': (context) => const LoginPage(),
        '/register-role': (context) => const RegisterRoleSelectionPage(),
      },
    );
  }
}