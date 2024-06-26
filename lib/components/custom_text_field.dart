import 'package:flutter/material.dart';
import 'package:jeonbuk_front/const/color.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final bool obscure;
  final double height;
  final Icon? prefixIcons;
  final TextButton? textButton;
  final IconButton? suffixIcons;
  final ValueChanged<String>? onChanged;
  final bool? enable;

  const CustomTextField({
    required this.controller,
    this.hintText,
    required this.obscure,
    required this.height,
    this.prefixIcons,
    this.textButton,
    this.suffixIcons,
    this.onChanged,
    this.enable,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextField(
        enabled: enable,
        onChanged: onChanged,
        controller: controller,
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: LIGHTGREY_COLOR),
            prefixIcon: prefixIcons != null
                ? Container(
                    margin: const EdgeInsets.only(right: 8), // 오른쪽 여백 조정
                    child: prefixIcons,
                  )
                : null,
            suffixIcon: textButton ?? suffixIcons,
            contentPadding: const EdgeInsets.fromLTRB(12, 10, 12, 10), // 상하좌우 패딩 조정
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: LIGHTGREY_COLOR, width: 2.0),
            )),
        obscureText: obscure,
      ),
    );
  }
}
