import 'package:flutter/material.dart';
import 'package:sport_spot/common/constants/app_colors.dart';
import 'package:sport_spot/common/widgets/input_field.dart';

class AddressCourtPage extends StatefulWidget {
  const AddressCourtPage({super.key});

  @override
  State<AddressCourtPage> createState() => _AddressCourtPageState();
}

class _AddressCourtPageState extends State<AddressCourtPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkOrange,
        title: Text("Endereço da quadra", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InputField(label: "LOGRADOURO"),
              InputField(label: "NÚMERO"),
              InputField(label: "COMPLEMENTO"),
              InputField(label: "BAIRRO"),
              InputField(label: "CIDADE"),
              InputField(label: "ESTADO"),
              InputField(label: "CEP"),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: () {
            
          },
          style: ElevatedButton.styleFrom(
            minimumSize: Size.fromHeight(50),
            backgroundColor: AppColors.darkOrange,
          ),
          child: Text("Salvar", style: TextStyle(fontSize: 20, color: Colors.white),)
        ),
      ),
    );
  }
}