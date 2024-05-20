import 'package:flutter/material.dart';
import 'package:jeonbuk_front/model/festival.dart';

class FestivalCustomListBox extends StatelessWidget {
  final Festival festival;
  GestureTapCallback? onTap;
  FestivalCustomListBox({required this.festival, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(7)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 2,
              spreadRadius: 0,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              festival.title,
              style: const TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              festival.address,
              style: const TextStyle(
                height: 2.0,
              ),
            ),
            Text(
              festival.schedule,
              style: const TextStyle(
                fontSize: 12,
                height: 2.0,
              ),
            ),
          ],
        ),
      ),
    );
    ;
  }
}
