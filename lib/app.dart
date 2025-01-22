import 'package:flutter/material.dart';
import 'package:sport_spot/routes/router.dart';
import 'package:sport_spot/routes/routing_constants.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: rotas(),
      initialRoute: splash,
    );
  }
}
