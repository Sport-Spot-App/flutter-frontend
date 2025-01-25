import 'package:flutter/material.dart';
import 'package:sport_spot/api/api.dart';
import 'package:sport_spot/common/constants/app_colors.dart';
import 'package:sport_spot/common/widgets/input_field.dart';
import 'package:sport_spot/common/widgets/primary_button.dart';
import 'package:sport_spot/models/user_model.dart';
import 'package:sport_spot/repositories/auth_repository.dart';
import 'package:sport_spot/repositories/user_repository.dart';
import 'package:sport_spot/screens/profile/profile_page.dart';
import 'package:sport_spot/stores/auth_store.dart';
import 'package:sport_spot/stores/user_store.dart';

class EditProfilePage extends StatefulWidget {
  final UserModel user;

  const EditProfilePage(this.user, {super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final AuthStore authSstore = AuthStore(repository: AuthRepository(Api()));
  final UserStore userStore = UserStore(repository: UserRepository(Api()));

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController documentController = TextEditingController();
  final TextEditingController cellphoneController = TextEditingController();

  void _handleUser(BuildContext context) async {
    UserModel updateUser = widget.user.copyWith(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        document: documentController.text.trim(),
        cellphone: cellphoneController.text.trim());

    await userStore.updateUser(updateUser);

    if (userStore.erro.value.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(userStore.erro.value)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil editado com sucesso!')),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    nameController.text = widget.user.name;
    emailController.text = widget.user.email;
    documentController.text = widget.user.document;
    cellphoneController.text = widget.user.cellphone;
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
          "Editar Perfil",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                    backgroundImage:
                        const AssetImage('assets/images/default_user.png')
                            as ImageProvider,
                  ),
                ),
                Positioned(
                  top: 200,
                  left: MediaQuery.of(context).size.width / 2 + 40,
                  child: IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.mediumOrange,
                    ),
                    color: Colors.white,
                    onPressed: () {
                      // TODO: Selecionar foto
                    },
                    icon: Icon(Icons.photo_camera),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 100),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  InputField(label: "NOME", controller: nameController),
                  InputField(label: "EMAIL", controller: emailController),
                  InputField(
                      label: widget.user.role == 3 ? "CPF" : "CNPJ",
                      controller: documentController),
                  InputField(label: "CELULAR", controller: cellphoneController),
                  PrimaryButton(
                    text: "Salvar",
                    onPressed: () {
                      _handleUser(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
