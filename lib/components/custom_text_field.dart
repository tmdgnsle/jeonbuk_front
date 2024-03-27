import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscure;
  final Icon? prefixIcons;
  final TextButton? textButton;

  const CustomTextField({
    required this.controller,
    required this.hintText,
    required this.obscure,
  this.prefixIcons,
    this.textButton,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        labelStyle: const TextStyle(color: Colors.grey),
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: prefixIcons,
        suffixIcon: textButton,
      ),
      obscureText: obscure,
    );
  }
}
