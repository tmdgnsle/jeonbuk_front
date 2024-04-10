import 'package:flutter/material.dart';

class BookmarkButton extends StatelessWidget {
  final bool isBookmarked;
  void Function()? onTap;
  BookmarkButton({required this.isBookmarked, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon( isBookmarked ? Icons.star : Icons.star_border, color: isBookmarked ? Colors.yellow : Colors.grey,),
    );
  }
}
