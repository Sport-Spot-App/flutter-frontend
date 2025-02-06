import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sport_spot/api/api.dart';
import 'package:sport_spot/common/constants/app_colors.dart';
import 'package:sport_spot/common/utils/user_map.dart';
import 'package:sport_spot/models/user_model.dart';
import 'package:sport_spot/repositories/auth_repository.dart';
import 'package:sport_spot/routes/routing_constants.dart';
import 'package:sport_spot/screens/court/courts_page.dart';
import 'package:sport_spot/screens/profile/change_password_page.dart';
import 'package:sport_spot/screens/profile/court_owner.dart';
import 'package:sport_spot/screens/profile/edit_profile_page.dart';
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
    _loadUser();
    super.initState();
  }

  Future<void> _loadUser() async {
    final loadedUser = await UserMap.getUserMap();
    setState(() {
      user = loadedUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      : const AssetImage('assets/images/default_user.png')
                          as ImageProvider,
                ),
              ),
            ],
          ),
          const SizedBox(height: 60),
          Text(
            user?.name ?? "",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            user?.email ?? "",
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.green,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 40),

          // Menu items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              shrinkWrap: true,
              children: [
                ListTile(
                  leading: const Icon(Icons.person, color: AppColors.charcoalBlue),
                  title: const Text("Editar perfil"),
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => EditProfilePage(user!)),
                    );
                    _loadUser();
                  },
                ),
                Builder(
                  builder: (_) {
                    if (user != null && user!.role == 2 && user!.is_approved) {
                      return ListTile(
                        leading: const Icon(CupertinoIcons.sportscourt_fill, color: AppColors.charcoalBlue),
                        title: const Text("Minhas quadras"),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => CourtsPage()));
                        },
                      );
                    }
                    
                    return Container();
                  },
                ),
                Builder(
                  builder: (_) {
                    if (user != null && user!.role == 1) {
                      return ListTile(
                        leading: const Icon(Icons.admin_panel_settings, color: AppColors.charcoalBlue),
                        title: const Text("Aprovar proprietários"),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => CourtOwnerApprovalPage()),
                          );
                        },
                      );
                    }

                    return Container();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.lock, color: AppColors.charcoalBlue),
                  title: const Text("Trocar senha"),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ChangePasswordPage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: AppColors.gray),
                  title: const Text("Sair"),
                  onTap: () async {
                    await store.logout();
                    await UserMap.removeUserMap();
                    if (!context.mounted) return;
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
