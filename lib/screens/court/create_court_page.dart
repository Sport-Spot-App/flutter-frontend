import 'package:flutter/material.dart';
import 'package:sport_spot/common/constants/app_colors.dart';
import 'package:sport_spot/common/widgets/checkbox_field.dart';
import 'package:sport_spot/common/widgets/input_field.dart';
import 'package:sport_spot/screens/court/address_court_page.dart';

class CreateCourtPage extends StatefulWidget {
  const CreateCourtPage({super.key});

  @override
  State<CreateCourtPage> createState() => _CreateCourtPageState();
}

class _CreateCourtPageState extends State<CreateCourtPage> {
  List<int> sportsCourt = [];
  List<Map<String, dynamic>> sportList = [
    {
      "id": 1,
      "name": "Futsal",
      "photo": "https://sportspott.tech/assets/images/sports/futsal.png",
      "created_at": null,
      "updated_at": null
    },
    {
      "id": 2,
      "name": "Futebol",
      "photo": "https://sportspott.tech/assets/images/sports/futebol.png",
      "created_at": null,
      "updated_at": null
    },
    {
      "id": 3,
      "name": "Vôlei",
      "photo": "https://sportspott.tech/assets/images/sports/volei.png",
      "created_at": null,
      "updated_at": null
    },
    {
      "id": 4,
      "name": "Beach Tênis",
      "photo": "https://sportspott.tech/assets/images/sports/beach-tenis.png",
      "created_at": null,
      "updated_at": null
    },
    {
      "id": 5,
      "name": "Tênis",
      "photo": "https://sportspott.tech/assets/images/sports/tenis.png",
      "created_at": null,
      "updated_at": null
    },
    {
      "id": 6,
      "name": "Handebol",
      "photo": "https://sportspott.tech/assets/images/sports/handebol.png",
      "created_at": null,
      "updated_at": null
    },
    {
      "id": 7,
      "name": "Basquete",
      "photo": "https://sportspott.tech/assets/images/sports/basquete.png",
      "created_at": null,
      "updated_at": null
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkOrange,
        title: Text("Dados da quadra", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InputField(label: "NOME"),
              InputField(label: "VALOR POR HORA"),
              InputField(label: "DESCRIÇÃo"),
              InputField(label: "HORÁRIO DE FUNCIONAMENTO"),
              SizedBox(height: 10),
              Text(
                "Esportes",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                childAspectRatio: 4,
                children: _buildCheckboxOptions(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => AddressCourtPage()));
          },
          style: ElevatedButton.styleFrom(
            minimumSize: Size.fromHeight(50),
            backgroundColor: AppColors.darkOrange,
          ),
          child: Text("Continuar", style: TextStyle(fontSize: 20, color: Colors.white),)
        ),
      ),
    );
  }

  _buildCheckboxOptions() {
    List<Widget> checkboxList = [];

    for (var sport in sportList) {
      int sportId = sport["id"];
      String sportName = sport["name"];

      Widget wdgt = CheckboxField(sportId, sportName, sportsCourt);
      checkboxList.add(wdgt);
    }

    return checkboxList;
  }
}