import 'package:flutter/material.dart';
import 'package:sport_spot/common/widgets/input_field.dart';
import 'package:sport_spot/common/widgets/primary_button.dart';
import 'package:sport_spot/common/widgets/half_clipper.dart';
import 'package:sport_spot/models/user_model.dart';
import 'package:sport_spot/stores/user_store.dart';
import 'package:sport_spot/common/constants/app_colors.dart';

class EditUserPage extends StatefulWidget {
  final UserModel user;
  final UserStore userStore;

  const EditUserPage({super.key, required this.user, required this.userStore});

  @override
  _EditUserPageState createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _photoController;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _cellphoneController;
  late TextEditingController _documentController;

  @override
  void initState() {
    super.initState();
    _photoController = TextEditingController(text: widget.user.photo);
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _cellphoneController = TextEditingController(text: widget.user.cellphone);
    _documentController = TextEditingController(text: widget.user.document);
  }

  @override
  void dispose() {
    _photoController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _cellphoneController.dispose();
    _documentController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      final updatedUser = widget.user.copyWith(
        photo: _photoController.text,
        name: _nameController.text,
        email: _emailController.text,
        cellphone: _cellphoneController.text,
        document: _documentController.text,
      );

      await widget.userStore.updateUser(updatedUser);

      if (widget.userStore.erro.value.isEmpty) {
        Navigator.pop(context); // Fecha a tela se tudo deu certo
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuário atualizado com sucesso!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: ${widget.userStore.erro.value}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Editar Usuário'),
        backgroundColor: AppColors.darkOrange,
      ),
      body: Column(
        children: [
          // Degradê na parte superior com o clipper
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
            child: Align(
              alignment: Alignment.topCenter,  // Alinha a foto para o topo
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0), // Ajuste da margem superior
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: widget.user.photo != null
                      ? NetworkImage(widget.user.photo!)
                      : const AssetImage('assets/images/default_user.png')
                          as ImageProvider,
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt, color: Colors.white),
                    onPressed: () {
                      // Ação para alterar a foto
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
          // Campos de input
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  InputField(
                    controller: _nameController,
                    label: 'NOME',
                  ),
                  InputField(
                    controller: _emailController,
                    label: 'EMAIL',
                  ),
                  InputField(
                    controller: _documentController,
                    label: 'CPF',
                  ),
                  InputField(
                    controller: _cellphoneController,
                    label: 'CELULAR',
                  ),
                  const SizedBox(height: 20),
                  PrimaryButton(
                    onPressed: _saveChanges,
                    text: 'Salvar',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
