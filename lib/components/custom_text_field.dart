import 'package:flutter/material.dart';

import '../../const/color.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscure;
  final Icon prefixIcons;

  const CustomTextField({
    required this.controller,
    required this.hintText,
    required this.obscure,
    required this.prefixIcons,
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
      ),
      obscureText: obscure,
    );
  }
}
