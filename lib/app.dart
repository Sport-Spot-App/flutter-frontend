import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/register/register_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: RegisterRoleSelectionPage()
    );
  }
}