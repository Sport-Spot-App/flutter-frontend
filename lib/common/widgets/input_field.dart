import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/constants/app_colors.dart';

class InputField extends StatefulWidget {
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final bool isPassword;
  final ValueChanged<String>? onChanged;

  const InputField({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.onChanged,
    this.isPassword = false,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: TextFormField(
        controller: widget.controller,
        onChanged: widget.onChanged,
        obscureText: widget.isPassword ? _obscureText : false,
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: const TextStyle(
            color: AppColors.gray,
            fontSize: 14,
          ),
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Color.fromARGB(96, 139, 139, 139)),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.black54,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
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
    );
  }
}
