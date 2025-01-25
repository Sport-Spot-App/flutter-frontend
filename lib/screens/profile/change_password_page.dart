import 'package:flutter/material.dart';
import 'package:sport_spot/common/constants/app_colors.dart';
import 'package:sport_spot/common/widgets/input_field.dart';
import 'package:sport_spot/screens/profile/profile_page.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkOrange,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Trocar senha",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
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
              ],
            ),
            const SizedBox(height: 100),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  InputField(label: "SENHA ATUAL"),
                  InputField(label: "NOVA SENHA"),
                  InputField(label: "CONFIRMAR NOVA SENHA"),
                  ElevatedButton(
                      onPressed: () {
                        // TODO: Alterar Senha
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size.fromHeight(50),
                        backgroundColor: AppColors.darkOrange,
                      ),
                      child: Text(
                        "Alterar senha",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
