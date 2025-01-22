import 'package:flutter/material.dart';
import 'package:sport_spot/api/api.dart';
import 'package:sport_spot/common/constants/app_colors.dart';
import 'package:sport_spot/common/utils/user_map.dart';
import 'package:sport_spot/models/user_model.dart';
import 'package:sport_spot/repositories/auth_repository.dart';
import 'package:sport_spot/routes/routing_constants.dart';
import 'package:sport_spot/screens/profile/change_password.dart';
import 'package:sport_spot/screens/profile/edit_profile.dart';
import 'package:sport_spot/stores/auth_store.dart';

class ProfilePage extends StatefulWidget {

  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthStore store = AuthStore(repository: AuthRepository(Api()));
  UserModel? user;

  @override
  void initState() {
    UserMap.getUserMap().then((value) {
      setState(() {
        user = value;
      });
    });
    super.initState();
  }

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
                top: 110,
                left: MediaQuery.of(context).size.width / 2 - 70,
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage: user?.photo != null && user?.photo != ""
                      ? NetworkImage(user!.photo!)
                      : const AssetImage('assets/images/default_user.png') as ImageProvider,
                ),
              ),
            ],
          ),
          const SizedBox(height: 60), // Espaço abaixo da foto
          Text(
            user?.name ?? "",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
           user?.email ?? "",
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.gray,
            ),
          ),
          const SizedBox(height: 40),

          // Menu items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(left: 20, right: 20,),
              shrinkWrap: true,
              children: [
                ListTile(
                  leading: const Icon(Icons.person, color: AppColors.charcoalBlue),
                  title: const Text("Editar perfil"),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => EditProfilePage(user!)));
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
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ChangePasswordPage()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: AppColors.gray),
                  title: const Text("Sair"),
                  onTap: () async {
                    await store.logout();
                    Navigator.of(context).pushNamedAndRemoveUntil(onboarding, (route) => false);
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
