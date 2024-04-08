import 'package:flutter/material.dart';
import 'package:jeonbuk_front/model/discount_store.dart';

class DiscountStoreList extends StatelessWidget {
  final DiscountStore discountStore;
  const DiscountStoreList({required this.discountStore, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
    child: Column(
      children: [
        Text(discountStore.storeName),
        Text(discountStore.roadAddress),
        Text(discountStore.etc.toString()),
      ],
    ),);
  }
}
