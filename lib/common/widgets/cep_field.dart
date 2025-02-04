import 'package:flutter/material.dart';
import 'package:sport_spot/common/constants/app_colors.dart';
import 'package:sport_spot/common/utils/masks.dart';

class CepField extends StatefulWidget {
  final ValueChanged<String>? onChanged;

  const CepField({super.key, this.onChanged});

  @override
  State<CepField> createState() => _CepFieldState();
}

class _CepFieldState extends State<CepField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          onChanged: widget.onChanged,
          inputFormatters: [ cepFormatter ],
          decoration: InputDecoration(
            labelText: "CEP",
            labelStyle: const TextStyle(
              color: AppColors.gray,
              fontSize: 14,
            ),
            hintStyle: const TextStyle(
              color: Color.fromARGB(96, 139, 139, 139),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.charcoalBlue),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.charcoalBlue),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.darkOrange),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
