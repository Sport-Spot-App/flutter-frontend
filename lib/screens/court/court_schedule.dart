import 'package:flutter/material.dart';
import 'package:sport_spot/common/constants/app_colors.dart';
import 'package:sport_spot/common/widgets/primary_button.dart';

class CadastroHorariosPage extends StatefulWidget {
  const CadastroHorariosPage({super.key});

  @override
  State<CadastroHorariosPage> createState() => _CadastroHorariosPageState();
}

class _CadastroHorariosPageState extends State<CadastroHorariosPage> {
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
      onSelected(roundedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Horários de Funcionamento',
            style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.darkOrange,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            ...diasSelecionados.keys.map((dia) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: diasSelecionados[dia],
                          onChanged: (value) => setState(
                              () => diasSelecionados[dia] = value ?? false),
                          activeColor: Colors.green,
                        ),
                        Text(dia),
                      ],
                    ),
                    Row(
                      children: [
                        _horarioButton(
                            'Início',
                            horariosInicio[dia],
                            (value) =>
                                setState(() => horariosInicio[dia] = value),
                            diasSelecionados[dia] == true),
                        SizedBox(width: 10),
                        _horarioButton(
                            'Fim',
                            horariosFim[dia],
                            (value) => setState(() => horariosFim[dia] = value),
                            diasSelecionados[dia] == true),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _horarioButton(String label, TimeOfDay? horario,
      Function(TimeOfDay) onSelected, bool isEnabled) {
    return SizedBox(
      width: 100,
      child: GestureDetector(
        onTap: isEnabled ? () => _selecionarHorario(context, onSelected) : null,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(
                color: isEnabled ? Colors.grey : Colors.grey.shade400),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            horario != null ? horario.format(context) : label,
            style: TextStyle(
                fontSize: 16, color: isEnabled ? Colors.black : Colors.grey),
          ),
        ),
      ),
    );
  }
}
