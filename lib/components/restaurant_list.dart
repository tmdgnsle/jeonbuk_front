import 'package:flutter/material.dart';
import 'package:jeonbuk_front/model/restaurant_result.dart';

class RestaurantList extends StatelessWidget {
  final Restaurant restaurant;
  const RestaurantList({required this.restaurant, super.key});



  @override
  Widget build(BuildContext context) {
    String modifiedEtc = restaurant.etc.toString().replaceAll('<', '\n');
    return Padding(padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
      child: Column(
        children: [
          Text(restaurant.storeName),
          Text(restaurant.roadAddress),
          Text(modifiedEtc),
        ],
      ),);
  }
}
