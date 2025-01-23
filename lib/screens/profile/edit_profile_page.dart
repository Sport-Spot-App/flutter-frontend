import 'package:flutter/material.dart';
import 'package:sport_spot/api/api.dart';
import 'package:sport_spot/common/constants/app_colors.dart';
import 'package:sport_spot/common/widgets/input_field.dart';
import 'package:sport_spot/models/user_model.dart';
import 'package:sport_spot/repositories/auth_repository.dart';
import 'package:sport_spot/screens/profile/profile_page.dart';
import 'package:sport_spot/stores/auth_store.dart';

class EditProfilePage extends StatefulWidget {
  final UserModel user;

  const EditProfilePage(this.user, {super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
final AuthStore store = AuthStore(repository: AuthRepository(Api()));

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController documentController = TextEditingController();
  final TextEditingController cellphoneController = TextEditingController();

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
        iconTheme: IconThemeData(color: Colors.white,),
      ),
      body: Column(
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
                  backgroundImage: const AssetImage('assets/images/default_user.png') as ImageProvider,
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
                InputField(label: "Nome", controller: nameController),
                InputField(label: "Email", controller: emailController),
                InputField(label: widget.user.role == 3 ?"CPF" : "CNPJ", controller: documentController),
                InputField(label: "Celular", controller: cellphoneController),
                ElevatedButton(
                  onPressed: () {
                    
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                    backgroundColor: AppColors.darkOrange,
                  ),
                  child: Text("Salvar", style: TextStyle(fontSize: 20, color: Colors.white),)
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}