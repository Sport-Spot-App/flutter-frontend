import 'package:flutter/material.dart';
import 'package:sport_spot/common/constants/app_colors.dart';
import 'package:sport_spot/common/constants/app_text_styles.dart';
import 'package:sport_spot/common/widgets/primary_button.dart';

class CadastroHorariosPage extends StatefulWidget {
  @override
  _CadastroHorariosPageState createState() => _CadastroHorariosPageState();
}

class _CadastroHorariosPageState extends State<CadastroHorariosPage> {
  bool todosDiasIguais = true;
  TimeOfDay? horarioInicio;
  TimeOfDay? horarioFim;
  Map<String, bool> diasSelecionados = {
    'Segunda': false,
    'Terça': false,
    'Quarta': false,
    'Quinta': false,
    'Sexta': false,
    'Sábado': false,
    'Domingo': false,
  };
  Map<String, TimeOfDay?> horariosInicio = {};
  Map<String, TimeOfDay?> horariosFim = {};

  Future<void> _selecionarHorario(BuildContext context, Function(TimeOfDay) onSelected) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      onSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Horários de Funcionamento', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.darkOrange,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildToggleButton('Todos os dias', todosDiasIguais, () => setState(() => todosDiasIguais = true)),
                _buildToggleButton('Horários Personalizados', !todosDiasIguais, () => setState(() => todosDiasIguais = false)),
              ],
            ),
            SizedBox(height: 20),
            todosDiasIguais ? _buildTodosDias() : _buildHorariosPersonalizados(),
            Spacer(),
            Center(
              child: PrimaryButton(
                text: "Cadastrar",
                onPressed: () {
                  // TODO: Salvar horários
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isSelected, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected? AppColors.lightOrange : const Color.fromARGB(255, 247, 247, 247),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? AppColors.darkOrange : AppColors.gray,
        ),
      ),
    );
  }

  Widget _buildTodosDias() {
    return Column(
      
      children: [
        Text("De Segunda à Domingo", style: AppTextStyles.mediumText),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _horarioButton('Início', horarioInicio, (value) => setState(() => horarioInicio = value)),
            SizedBox(width: 20),
            _horarioButton('Fim', horarioFim, (value) => setState(() => horarioFim = value)),
          ],
        ),
      ],
    );
  }

  Widget _buildHorariosPersonalizados() {
    return Column(
      children: diasSelecionados.keys.map((dia) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: diasSelecionados[dia],
                    onChanged: (value) => setState(() => diasSelecionados[dia] = value ?? false),
                    activeColor: Colors.green, 
                  ),
                  Text(dia),
                ],
              ),
              Row(
                children: [
                  _horarioButton('Início', horariosInicio[dia], (value) => setState(() => horariosInicio[dia] = value)),
                  SizedBox(width: 10),
                  _horarioButton('Fim', horariosFim[dia], (value) => setState(() => horariosFim[dia] = value)),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _horarioButton(String label, TimeOfDay? horario, Function(TimeOfDay) onSelected) {
    return SizedBox(
      width: 100,
      child: GestureDetector(
        onTap: () => _selecionarHorario(context, onSelected),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            horario != null ? horario.format(context) : label,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
