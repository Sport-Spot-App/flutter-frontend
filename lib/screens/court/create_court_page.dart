import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sport_spot/common/constants/app_colors.dart';
import 'package:sport_spot/common/widgets/checkbox_field.dart';
import 'package:sport_spot/common/widgets/input_field.dart';
import 'package:sport_spot/models/court_model.dart';
import 'package:sport_spot/models/sport_model.dart';

class CreateCourtPage extends StatefulWidget {
  final CourtModel? court;
  const CreateCourtPage({this.court, super.key});

  @override
  State<CreateCourtPage> createState() => _CreateCourtPageState();
}

class _CreateCourtPageState extends State<CreateCourtPage> {
  int id = 0;
  bool canExit = true;
  ImagePicker picker = ImagePicker();
  int pass = 0;
  List<int> sportsCourt = [];
  List<File> photos = [];

  TextEditingController nameController = TextEditingController();
  TextEditingController valueController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController hourController = TextEditingController();
  TextEditingController cepController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController complementController = TextEditingController();
  TextEditingController neighborhoodController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();

  List<SportModel> sportList = [
    SportModel(id: 1, name: "Futsal"),
    SportModel(id: 2, name: "Futebol"),
    SportModel(id: 3, name: "Vôlei"),
    SportModel(id: 4, name: "Beach Tênis"),
    SportModel(id: 5, name: "Tênis"),
    SportModel(id: 6, name: "Handebol"),
    SportModel(id: 7, name: "Basquete"),
  ];

  Future<void> _pickImage() async {
    List<XFile> pickedFiles = await picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        photos.addAll(pickedFiles.map((file) => File(file.path)));
      });
    }
  }

  @override
  void initState() {
    if (widget.court != null) {
      id = widget.court!.id;
      nameController.text = widget.court!.name;
      valueController.text = widget.court!.price_per_hour;
      descriptionController.text = widget.court!.description;
      // hourController.text = widget.court!.hour ?? "";
      // cepController.text = widget.court!.cep ?? "";
      addressController.text = widget.court!.street;
      numberController.text = widget.court!.number;
      // complementController.text = widget.court!.complement ?? "";
      // neighborhoodController.text = widget.court!.neighborhood ?? "";
      // cityController.text = widget.court!.city ?? "";
      // stateController.text = widget.court!.state ?? "";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canExit,
      onPopInvokedWithResult: (pop, result) async {
        if (pass != 0) {
          setState(() {
            pass--;
            canExit = pass == 0;
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.darkOrange,
          title: Text("Cadastrar quadra", style: TextStyle(color: Colors.white)),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Builder(
              builder: (_) {
              if (pass == 0) {
                return _buildDataCourtPage();
              } else if (pass == 1) {
                return _buildAddressCourtPage();
              } else {
                return _buildPhotosCourtPage();
              }
              }
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton(
              onPressed: () {
                if (pass == 2) {
                  if (id > 0) {
                    print("Editar quadra");
                  } else {
                    print("Salvar quadra");
                  }
                } else {
                  setState(() {
                    pass++;
                    canExit = false;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(50),
                backgroundColor: AppColors.darkOrange,
              ),
            child: Text(pass == 2 ? "Salvar" : "Continuar", style: TextStyle(fontSize: 20, color: Colors.white),)
          ),
        ),
      ),
    );
  }

  _buildCheckboxOptions() {
    List<Widget> checkboxList = [];

    for (var sport in sportList) {
      int sportId = sport.id;
      String sportName = sport.name;

      Widget wdgt = CheckboxField(sportId, sportName, sportsCourt);
      checkboxList.add(wdgt);
    }

    return checkboxList;
  }

  _buildDataCourtPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Dados da quadra",
          style: TextStyle(
            fontSize:18,
            fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        InputField(label: "NOME", controller: nameController),
        InputField(label: "VALOR POR HORA", controller: valueController),
        InputField(label: "DESCRIÇÃo", controller: descriptionController),
        InputField(label: "HORÁRIO DE FUNCIONAMENTO", controller: hourController),
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
    );
  }

  _buildAddressCourtPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Endereço da quadra",
          style: TextStyle(
            fontSize:18,
            fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        InputField(label: "CEP", controller: cepController),
        InputField(label: "LOGRADOURO", controller: addressController),
        InputField(label: "NÚMERO", controller: numberController),
        InputField(label: "COMPLEMENTO", controller: complementController),
        InputField(label: "BAIRRO", controller: neighborhoodController),
        InputField(label: "CIDADE", controller: cityController),
        InputField(label: "ESTADO", controller: stateController),
      ],
    );
  }

  _buildPhotosCourtPage() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Fotos da quadra",
              style: TextStyle(
                fontSize:18,
                fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkOrange
              ),
              onPressed: () {
                _pickImage();
              },
              child: Row(
                children: [
                  Icon(Icons.add, color: Colors.white),
                  SizedBox(width: 5),
                  Text("Adicionar foto", style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Divider(),
        SizedBox(height: 10),
        Builder(
          builder: (context) {
            if (photos.isEmpty) {
              return Text("Nenhuma foto adicionada");
            }

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: photos.length,
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    photos[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}