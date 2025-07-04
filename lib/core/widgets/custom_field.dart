import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final String hintText;
  final String labelText;
  final TextEditingController? controller;
  final bool isObscureText;
  final bool readOnly;
  final VoidCallback? onTap;

  const CustomField({
    super.key,
    required this.hintText,
    required this.labelText,
    required this.controller,
    this.isObscureText = false,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText, hintText: hintText),
      obscureText: isObscureText,
      readOnly: readOnly,
      onTap: onTap,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$hintText is missing!';
        }

        return null;
      },
      // obscuringCharacter: '*',
    );
  }
}
