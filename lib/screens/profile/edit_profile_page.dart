import 'package:cpf_cnpj_validator/cnpj_validator.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sport_spot/api/api.dart';
import 'package:sport_spot/common/constants/app_colors.dart';
import 'package:sport_spot/common/utils/masks.dart';
import 'package:sport_spot/common/widgets/input_field.dart';
import 'package:sport_spot/common/widgets/primary_button.dart';
import 'package:sport_spot/models/user_model.dart';
import 'package:sport_spot/repositories/auth_repository.dart';
import 'package:sport_spot/repositories/user_repository.dart';
import 'package:sport_spot/screens/profile/profile_page.dart';
import 'package:sport_spot/stores/auth_store.dart';
import 'package:sport_spot/stores/user_store.dart';
import 'package:sport_spot/common/utils/user_map.dart';
import 'dart:io';

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

  String? documentError;
  File? _image;

  _validateDocument(text) {
    if (widget.user.role == 3 && !CPFValidator.isValid(text)) {
      setState(() {
        documentError = "CPF inválido";
      });
      return;
    }

    if (widget.user.role == 2 && !CNPJValidator.isValid(text)) {
      setState(() {
        documentError = "CNPJ inválido";
      });
      return;
    }

    setState(() {
      documentError = null;
    });
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _handleUser(BuildContext context) async {
    UserModel updateUser = widget.user.copyWith(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        document: documentController.text.trim(),
        cellphone: cellphoneController.text.trim());

    await userStore.updateUser(updateUser);

    if (userStore.erro.value.isNotEmpty) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(userStore.erro.value)),
      );
    } else {
      await UserMap.setUserMap(updateUser);
      if (!context.mounted) return;
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

    if (widget.user.role == 3) {
      documentController.value = maskCPF.formatEditUpdate(
        TextEditingValue.empty,
        TextEditingValue(text: widget.user.document),
      );
    } else {
      documentController.value = maskCNPJ.formatEditUpdate(
        TextEditingValue.empty,
        TextEditingValue(text: widget.user.document),
      );
    }

    cellphoneController.value = maskPhone.formatEditUpdate(
      TextEditingValue.empty,
      TextEditingValue(text: widget.user.cellphone),
    );
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
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: _image != null
                          ? FileImage(_image!)
                          : (widget.user.photo != null
                                  ? NetworkImage(widget.user.photo!.path)
                                  : const AssetImage(
                                      'assets/images/default_user.png'))
                              as ImageProvider,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 100),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  InputField(
                    label: "NOME",
                    controller: nameController,
                  ),
                  InputField(
                    label: "EMAIL",
                    controller: emailController,
                  ),
                  InputField(
                    label: widget.user.role == 3 ? "CPF" : "CNPJ",
                    controller: documentController,
                    inputFormatters: [
                      widget.user.role == 3 ? maskCPF : maskCNPJ
                    ],
                    onChanged: _validateDocument,
                    errorText: documentError,
                  ),
                  InputField(
                    label: "CELULAR",
                    controller: cellphoneController,
                    inputFormatters: [maskPhone],
                  ),
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
