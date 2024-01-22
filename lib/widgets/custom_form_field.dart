import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField({
    super.key,
    required this.controller,
    this.obscureText = false,
    required this.labelText,
    required this.prefixIcon,
    required this.validator, 
    this.textInputAction = TextInputAction.next,
    this.textInputType = TextInputType.text,
  });

  final TextEditingController controller;
  final bool obscureText;
  final String labelText;
  final IconData prefixIcon;
  final Function validator;
  final TextInputAction textInputAction;
  final TextInputType textInputType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      enableSuggestions: false,
      autocorrect: false,
      keyboardType: textInputType,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(prefixIcon),
        border: const OutlineInputBorder(),
      ),
      validator: (value) => validator(value),
    );
  }
}
