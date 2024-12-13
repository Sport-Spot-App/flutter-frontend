import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/constants/app_colors.dart';

class ProfilePage extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String? userPhoto;

  const ProfilePage({
    super.key,
    required this.userName,
    required this.userEmail,
    this.userPhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkOrange,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Perfil",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          // Gradient background with user photo
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipPath(
                clipper: HalfClipper(),
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: AppColors.orangeGradient,
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 140,
                left: MediaQuery.of(context).size.width / 2 - 50,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: userPhoto != null
                      ? NetworkImage(userPhoto!)
                      : const AssetImage('assets/images/default_user.png')
                          as ImageProvider,
                ),
              ),
            ],
          ),
          const SizedBox(height: 60), // Espaço abaixo da foto
          Text(
            userName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            userEmail,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.gray,
            ),
          ),
          const SizedBox(height: 20),

          // Menu items
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.person, color: AppColors.charcoalBlue),
                  title: const Text("Editar perfil"),
                  onTap: () {
                    // Navegar para a página de edição
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.favorite, color: Colors.red),
                  title: const Text("Favoritos"),
                  onTap: () {
                    // Navegar para favoritos
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.lock, color: AppColors.charcoalBlue),
                  title: const Text("Trocar senha"),
                  onTap: () {
                    // Navegar para troca de senha
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: AppColors.gray),
                  title: const Text("Sair"),
                  onTap: () {
                    // Sair da aplicação
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Clipper for the gradient header
class HalfClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 50,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
