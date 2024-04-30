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

  const CustomTextField({
    required this.controller,
    this.hintText,
    required this.obscure,
    required this.height,
    this.prefixIcons,
    this.textButton,
    this.suffixIcons,
    this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextField(
        onChanged: onChanged,
        controller: controller,
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: LIGHTGREY_COLOR),
            prefixIcon: prefixIcons != null
                ? Container(
                    margin: EdgeInsets.only(right: 8), // 오른쪽 여백 조정
                    child: prefixIcons,
                  )
                : null,
            suffixIcon: textButton ?? suffixIcons,
            contentPadding: EdgeInsets.fromLTRB(12, 10, 12, 10), // 상하좌우 패딩 조정
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: LIGHTGREY_COLOR, width: 2.0),
            )),
        obscureText: obscure,
      ),
    );
  }
}
