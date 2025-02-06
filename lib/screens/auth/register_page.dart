import 'dart:convert';
import 'dart:typed_data';

import 'package:cpf_cnpj_validator/cnpj_validator.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sport_spot/api/api.dart';
import 'package:sport_spot/common/constants/app_colors.dart';
import 'package:sport_spot/common/constants/app_text_styles.dart';
import 'package:sport_spot/common/utils/masks.dart';
import 'package:sport_spot/common/widgets/input_field.dart';
import 'package:sport_spot/common/widgets/primary_button.dart';
import 'package:sport_spot/models/user_model.dart';
import 'package:sport_spot/repositories/user_repository.dart';
import 'package:sport_spot/routes/routing_constants.dart';
import 'package:sport_spot/stores/user_store.dart';

class RegisterPage extends StatefulWidget {
  final int role;

  const RegisterPage({required this.role, super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final userRepository = UserRepository(Api());
  final userStore = UserStore(repository: UserRepository(Api()));

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController cellphoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String? documentError;

  _validateDocument(text) {
    if (widget.role == 3 && !CPFValidator.isValid(text)) {
      setState(() {
        documentError = "CPF inválido";
      });
      return;
    }

    if (widget.role == 2 && !CNPJValidator.isValid(text)) {
      setState(() {
        documentError = "CNPJ inválido";
      });
      return;
    }

    setState(() {
      documentError = null;
    });
  }

  Future<void> _handleRegister(BuildContext context) async {
    if (userStore.isLoading.value) return;

    if (passwordController.text != confirmPasswordController.text) {
      userStore.erro.value = 'Senhas não coincidem';
      return;
    }

    final user = UserModel(
      id: 0,
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
      document: cpfController.text.trim(),
      cellphone: cellphoneController.text.trim(),
      role: widget.role,
      status: true,
      is_approved: false,
      created_at: DateTime.now(),
      updated_at: DateTime.now(),
    );

    await userStore.registerUser(user);

    if (userStore.erro.value.isEmpty) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuário cadastrado com sucesso!'),
        ),
      );
      Navigator.of(context).pushNamedAndRemoveUntil(
        confirmRegister,
        (route) => false,
        arguments: {'role': widget.role},
      );
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(userStore.erro.value),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Comece a reservar sua quadra agora!',
                style: AppTextStyles.bigText.copyWith(
                  color: AppColors.darkOrange,
                  height: 1,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              InputField(
                controller: nameController,
                label: "NOME",
              ),
              InputField(
                controller: emailController,
                label: "EMAIL",
              ),
              InputField(
                controller: cpfController,
                label: widget.role == 2 ? "CNPJ" : "CPF",
                inputFormatters: [widget.role == 2 ? maskCNPJ : maskCPF],
                onChanged: _validateDocument,
                errorText: documentError,
              ),
              InputField(
                controller: cellphoneController,
                label: "CELULAR",
                inputFormatters: [maskPhone],
              ),
              InputField(
                controller: passwordController,
                label: "SENHA",
                isPassword: true,
              ),
              InputField(
                controller: confirmPasswordController,
                label: "CONFIRME SUA SENHA",
                isPassword: true,
              ),
              const SizedBox(height: 20),
              ValueListenableBuilder<bool>(
                valueListenable: userStore.isLoading,
                builder: (context, isLoading, child) {
                  return PrimaryButton(
                    text: isLoading ? 'Carregando...' : 'Cadastrar',
                    onPressed:
                        isLoading ? null : () => _handleRegister(context),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
