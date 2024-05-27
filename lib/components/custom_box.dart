import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jeonbuk_front/const/color.dart';

class CustomBox extends StatelessWidget {
  final String title;
  Icon? titleIcon;
  final String firstDescription;
  final String secontDescription;
  Color? backgroundColor;
  final double size;
  final GestureTapCallback onTap;

  CustomBox(
      {required this.size,
      required this.title,
      this.titleIcon,
      required this.firstDescription,
      required this.secontDescription,
      this.backgroundColor,
      required this.onTap,
      super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Stack(children: [
        Container(
          padding: const EdgeInsets.all(16),
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 8,
                spreadRadius: 0,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 20),
                  ),
                  titleIcon ?? Container(),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                '$firstDescription\n$secontDescription',
                style: const TextStyle(
                    fontSize: 12, height: 2.0, color: GREY_COLOR),
              ),
            ],
          ),
        ),
        const Positioned(
          bottom: 16,
          right: 16,
          child: Icon(
            Icons.arrow_forward,
            size: 35,
          ),
        ),
      ]),
    );
  }
}
