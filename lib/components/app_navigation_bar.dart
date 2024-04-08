import 'package:flutter/material.dart';
import 'package:jeonbuk_front/const/color.dart';

class AppNavigationBar extends StatelessWidget {
  AppNavigationBar({this.currentIndex, Key? key}) : super(key: key);

  int? currentIndex;

  final List<String> _screens = [
    "/main",
    "/search",
    '/profile',
    // Add more screens as needed
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showUnselectedLabels: true,
      backgroundColor: Colors.white,
      currentIndex: currentIndex ?? 0,
      onTap: (index) {
        // Handle item tap
        if (index != currentIndex) {
          // Get.toNamed(_screens[index]);
          currentIndex = index;
        }
      },
      items: const [
        BottomNavigationBarItem(
          backgroundColor: Colors.white,
          icon: Icon(
            Icons.home,
            color: BLUE_COLOR,
          ),
          label: '홈',
        ),
        BottomNavigationBarItem(
          backgroundColor: Colors.white,
          icon: Icon(
            Icons.star,
            color: BLUE_COLOR,
          ),
          label: '나만의 지도',
        ),
        BottomNavigationBarItem(
          backgroundColor: Colors.white,
          icon: Icon(
            Icons.person,
            color: BLUE_COLOR,
          ),
          label: 'MY',
        ),
        // Add more BottomNavigationBarItems as needed
      ],
    );
  }
}
