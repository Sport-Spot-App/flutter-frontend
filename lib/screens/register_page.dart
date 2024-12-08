import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/constants/app_colors.dart';
import 'package:flutter_application_1/common/constants/app_text_styles.dart';
import 'package:flutter_application_1/common/widgets/input_field.dart';
import 'package:flutter_application_1/common/widgets/primary_button.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Comece a reservar sua quadra agora!',
                      style: AppTextStyles.mediumText.copyWith(
                        color: AppColors.darkOrange,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    const InputField(
                      label: "NOME",
                      hintText: "moses@email.com",
                    ),
                    const InputField(
                      label: "EMAIL",
                      hintText: "moses@email.com",
                    ),
                    const InputField(
                      label: "CPF",
                      hintText: "moses@email.com",
                    ),
                    const InputField(
                      label: "CELULAR",
                      hintText: "moses@email.com",
                    ),
                    const InputField(
                      label: "SENHA",
                      hintText: "moses@email.com",
                      isPassword: true,
                    ),
                    const InputField(
                      label: "CONFIRME SUA SENHA",
                      hintText: "moses@email.com",
                      isPassword: true,
                    ),
                    const SizedBox(height: 20),
                    PrimaryButton(
                        text: 'Cadastrar',
                        onPressed: () {
                          print('cadatrou');
                        })
                  ],
                ))));
  }
}
