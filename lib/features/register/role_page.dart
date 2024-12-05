import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/widgets/role_button.dart';

class RegisterRoleSelectionPage extends StatelessWidget {
  const RegisterRoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              // Título da página
              const Text(
                "Como deseja se cadastrar?",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF85B00),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              // Botão "Dono de Quadra"
              RoleButton(
                title: "Dono de Quadra",
                imagePath: 'assets/images/basketball_court.png',
                onPressed: () {
                  print("Dono de Quadra selecionado");
                  // Navegar para a próxima página ou lógica
                },
              ),
              const SizedBox(height: 20),
              // Botão "Atleta"
              RoleButton(
                title: "Atleta",
                imagePath: 'assets/images/soccer_players.png',
                onPressed: () {
                  print("Atleta selecionado");
                  // Navegar para a próxima página ou lógica
                },
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}