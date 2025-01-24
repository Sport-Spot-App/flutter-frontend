import 'package:flutter/material.dart';
import 'package:sport_spot/common/constants/app_colors.dart';

class CheckboxField extends StatefulWidget {
  final int id;
  final String label;
  final List<int> listValues;

  const CheckboxField(this.id, this.label, this.listValues, {super.key});

  @override
  State<CheckboxField> createState() => _CheckboxFieldState();
}

class _CheckboxFieldState extends State<CheckboxField> {
  bool? isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          activeColor: AppColors.darkOrange,
          checkColor: Colors.white,
          value: isChecked,
          onChanged: (newValue) {
            setState(() {
              isChecked = newValue;
            });
            if (newValue == true) {
              widget.listValues.add(widget.id);
            } else {
              widget.listValues.remove(widget.id);
            }
          },
        ),
        Text(widget.label),
      ],
    );
  }
}