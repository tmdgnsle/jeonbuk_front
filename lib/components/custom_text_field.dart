import 'package:flutter/material.dart';
import 'package:jeonbuk_front/const/color.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscure;
  final double height;
  final Icon? prefixIcons;
  final TextButton? textButton;
  final IconButton? suffixIcons;

  const CustomTextField({
    required this.controller,
    required this.hintText,
    required this.obscure,
    required this.height,
    this.prefixIcons,
    this.textButton,
    this.suffixIcons,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            hintText: hintText,
            labelStyle: TextStyle(color: LIGHTGREY_COLOR),
            hintStyle: TextStyle(color: LIGHTGREY_COLOR),
            prefixIcon: prefixIcons,
            suffixIcon: textButton ?? suffixIcons,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: LIGHTGREY_COLOR, width: 2.0),
            )),
        obscureText: obscure,
      ),
    );
  }
}
