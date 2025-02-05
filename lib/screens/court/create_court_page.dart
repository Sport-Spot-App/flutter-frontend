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
import 'package:sport_spot/repositories/court_repository.dart';
import 'package:sport_spot/repositories/sport_repository.dart';
import 'package:sport_spot/routes/routing_constants.dart';
import 'package:sport_spot/stores/cep_store.dart';
import 'package:sport_spot/stores/court_store.dart';
import 'package:sport_spot/stores/sport_store.dart';

class CreateCourtPage extends StatefulWidget {
  final CourtModel? court;
  const CreateCourtPage({this.court, super.key});

  @override
  State<CreateCourtPage> createState() => _CreateCourtPageState();
}

class _CreateCourtPageState extends State<CreateCourtPage> {
  final CepStore cepStore = CepStore(repository: CepRepository(Api()));
  final SportStore sportStore = SportStore(repository: SportRepository(Api()));
  final CourtStore courtStore = CourtStore(repository: CourtRepository(Api()));
  List<SportModel> sportList = [];
  bool canExit = true;
  int pass = 0;
  bool isEditing = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController valueController = TextEditingController(text: "0,00");
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

  Map<String, bool> diasSelecionados = {
    'Monday': false,
    'Tuesday': false,
    'Wednesday': false,
    'Thursday': false,
    'Friday': false,
    'Saturday': false,
    'Sunday': false,
  };
  TimeOfDay? horarioInicio;
  TimeOfDay? horarioFim;
  List<String> blockedDays = [];

  //Método para criar quadra
  Future<void> _createCourt() async {
    CepModel cep = CepModel(
      cep: cepController.text,
      logradouro: addressController.text,
      complemento: complementController.text,
      bairro: neighborhoodController.text,
      localidade: cityController.text,
      estado: stateController.text,
    );

    CourtModel court = CourtModel(
      name: nameController.text,
      price_per_hour: valueController.text,
      description: descriptionController.text,
      zip_code: cep.cep,
      street: cep.logradouro,
      number: numberController.text,
      sports: sportsSelected
          .map((id) => sportList.firstWhere((sport) => sport.id == id))
          .toList(),
      photos: photos,
      cep: cep,
      logradouro: cep.logradouro,
      complemento: cep.complemento,
      bairro: cep.bairro,
      estado: cep.estado,
      localidade: cep.localidade,
      initial_hour: horarioInicio?.format(context) ?? '',
      final_hour: horarioFim?.format(context) ?? '',
      work_days: diasSelecionados.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList(),
    );

    await courtStore.registerCourt(court);
    Navigator.of(context).pushNamedAndRemoveUntil(courtPage, (route) => false);
  }

  Future<void> _pickImage() async {
    List<XFile> pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        photos.addAll(pickedFiles.map((file) => File(file.path)));
      });
    }
  }

  Future<void> _selecionarHorario(
      BuildContext context, Function(TimeOfDay) onSelected) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final roundedTime = TimeOfDay(hour: picked.hour, minute: 0);
      setState(() {
        onSelected(roundedTime);
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
      complementController.text = widget.court!.complemento ?? '';
      neighborhoodController.text = widget.court!.bairro ?? '';
      cityController.text = widget.court!.localidade ?? '';
      stateController.text = widget.court!.estado ?? '';
      sportsSelected = widget.court!.sports.map((sport) => sport.id).toList();
      photos = widget.court!.photos!.map((photo) => File(photo.path)).toList();
    }
    super.initState();
  }

  Future<void> _fetchSports() async {
    await sportStore.getSports();
    setState(() {
      sportList = sportStore.state.value;
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
              } else if (pass == 2) {
                return _buildPhotosCourtPage();
              } else {
                return _buildCourtSchedulePage();
              }
            }),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton(
              onPressed: () {
                if (pass == 3) {
                  if (isEditing) {
                    print("Editar quadra");
                  } else {
                    _createCourt();
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
                pass == 3 ? "Salvar" : "Continuar",
                style: TextStyle(fontSize: 20, color: Colors.white),
              )),
        ),
      ),
    );
  }

  _buildCourtSchedulePage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Horários de Funcionamento",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Column(
          children: diasSelecionados.keys.map((dia) {
            return CheckboxListTile(
              title: Text(dia),
              value: diasSelecionados[dia],
              onChanged: (value) {
                setState(() {
                  diasSelecionados[dia] = value ?? false;
                });
              },
              activeColor: Colors.green,
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _horarioButton(
              'Início',
              horarioInicio,
              (value) => setState(() => horarioInicio = value),
            ),
            _horarioButton(
              'Fim',
              horarioFim,
              (value) => setState(() => horarioFim = value),
            ),
          ],
        ),
      ],
    );
  }

  Widget _horarioButton(
      String label, TimeOfDay? horario, Function(TimeOfDay) onSelected) {
    return SizedBox(
      width: 150,
      child: GestureDetector(
        onTap: () => _selecionarHorario(context, onSelected),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            horario != null ? horario.format(context) : label,
            style: const TextStyle(fontSize: 16, color: Colors.black),
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
                return newValue.copyWith(text: "0,00");
              }
              newText = newText.replaceAll(RegExp(r'[^\d]'), '');
              double value = double.parse(newText) / 100;
              String formattedValue =
                  value.toStringAsFixed(2).replaceAll('.', ',');
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
        CepField(onChanged: _fetchCEP, controller: cepController),
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
