import 'dart:io';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sport_spot/api/api.dart';
import 'package:sport_spot/common/constants/app_colors.dart';
import 'package:sport_spot/common/widgets/cep_field.dart';
import 'package:sport_spot/common/widgets/checkbox_field.dart';
import 'package:sport_spot/common/widgets/input_field.dart';
import 'package:sport_spot/models/cep_model.dart';
import 'package:sport_spot/models/court_model.dart';
import 'package:sport_spot/models/sport_model.dart';
import 'package:sport_spot/repositories/cep_repository.dart';
import 'package:sport_spot/repositories/sport_repository.dart';
import 'package:sport_spot/routes/routing_constants.dart';
import 'package:sport_spot/stores/cep_store.dart';
import 'package:sport_spot/stores/sport_store.dart';

class CreateCourtPage extends StatefulWidget {
  final CourtModel? court;
  const CreateCourtPage({this.court, super.key});

  @override
  State<CreateCourtPage> createState() => _CreateCourtPageState();
}

class _CreateCourtPageState extends State<CreateCourtPage> {
  final CepStore cepStore = CepStore(repository: CepRepository(Api()));
  final SportStore courtStore = SportStore(repository: SportRepository(Api()));
  List<SportModel> sportList = [];
  bool canExit = true;
  int pass = 0;
  bool isEditing = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController valueController =
      TextEditingController(text: "R\$ 0,00");
  TextEditingController descriptionController = TextEditingController();
  TextEditingController hourController = TextEditingController();
  TextEditingController cepController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController complementController = TextEditingController();
  TextEditingController neighborhoodController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  List<int> sportsSelected = [];
  List<File> photos = [];

  Future<void> _pickImage() async {
    List<XFile> pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        photos.addAll(pickedFiles.map((file) => File(file.path)));
      });
    }
  }

  Future<void> _selectTime(
      BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        controller.text = picked.format(context);
      });
    }
  }

  @override
  void initState() {
    _fetchSports();
    if (widget.court != null) {
      isEditing = true;
      nameController.text = widget.court!.name;
      valueController.text = widget.court!.price_per_hour;
      descriptionController.text = widget.court!.description;
      cepController.text = widget.court!.zip_code;
      addressController.text = widget.court!.street;
      numberController.text = widget.court!.number;
      complementController.text = widget.court!.cep.complemento;
      neighborhoodController.text = widget.court!.cep.bairro;
      cityController.text = widget.court!.cep.localidade;
      stateController.text = widget.court!.cep.estado;
    }
    super.initState();
  }

  Future<void> _fetchSports() async {
    await courtStore.getSports();
    setState(() {
      sportList = courtStore.state.value;
    });
  }

  Future<void> _fetchCEP(String cep) async {
    if (cep.length > 8) {
      await cepStore.findCep(cep);
      CepModel? cepLocation = cepStore.state.value;
      if (cepLocation != null) {
        setState(() {
          cepController.text = cepLocation.cep;
          addressController.text = cepLocation.logradouro;
          complementController.text = cepLocation.complemento;
          neighborhoodController.text = cepLocation.bairro;
          cityController.text = cepLocation.localidade;
          stateController.text = cepLocation.estado;
        });
      }
    }
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
          title:
              Text("Cadastrar quadra", style: TextStyle(color: Colors.white)),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Builder(builder: (_) {
              if (pass == 0) {
                return _buildDataCourtPage();
              } else if (pass == 1) {
                return _buildAddressCourtPage();
              } else {
                return _buildPhotosCourtPage();
              }
            }),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton(
              onPressed: () {
                if (pass == 2) {
                  if (isEditing) {
                    print("Editar quadra");
                  } else {
                    Navigator.of(context).pushNamed(courtSchedule);
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
              child: Text(
                pass == 2 ? "Salvar" : "Continuar",
                style: TextStyle(fontSize: 20, color: Colors.white),
              )),
        ),
      ),
    );
  }

  _buildCheckboxOptions() {
    List<Widget> checkboxList = [];

    for (var sport in sportList) {
      int sportId = sport.id;
      String sportName = sport.name;

      Widget wdgt = CheckboxField(sportId, sportName, sportsSelected);
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
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        InputField(label: "NOME", controller: nameController),
        InputField(label: "DESCRIÇÃO", controller: descriptionController),
        InputField(
          label: "VALOR POR HORA",
          controller: valueController,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            TextInputFormatter.withFunction((oldValue, newValue) {
              String newText = newValue.text;
              if (newText.isEmpty) {
                return newValue.copyWith(text: "R\$ 0,00");
              }
              newText = newText.replaceAll(RegExp(r'[^\d]'), '');
              double value = double.parse(newText) / 100;
              String formattedValue =
                  "R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}";
              return newValue.copyWith(
                text: formattedValue,
                selection:
                    TextSelection.collapsed(offset: formattedValue.length),
              );
            }),
          ],
        ),
        SizedBox(height: 20),
        Text(
          "Esportes",
          style: TextStyle(
            fontSize: 18,
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
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
        CepField(onChanged: _fetchCEP),
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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkOrange),
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
              shrinkWrap: true,
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
