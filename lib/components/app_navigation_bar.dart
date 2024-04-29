import 'package:flutter/material.dart';
import 'package:jeonbuk_front/const/color.dart';
import 'package:jeonbuk_front/screen/home_screen.dart';
import 'package:jeonbuk_front/screen/my_setting_screen.dart';

class AppNavigationBar extends StatelessWidget {
  AppNavigationBar({this.currentIndex, Key? key}) : super(key: key);

  int? currentIndex;

  final List _screens = [
    HomeScreen(),
    HomeScreen(),
    MySettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showUnselectedLabels: true,
      selectedItemColor: GREEN_COLOR,
      selectedIconTheme: IconThemeData(color: GREEN_COLOR),
      unselectedItemColor: BLUE_COLOR,
      // fixedColor: GREEN_COLOR,
      backgroundColor: Colors.white,
      currentIndex: currentIndex ?? 0,
      onTap: (index) {
        // Handle item tap
        if (index != currentIndex) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => _screens[index]));
          currentIndex = index;
        }
      },
      items: const [
        BottomNavigationBarItem(
          backgroundColor: Colors.white,
          icon: Icon(
            Icons.home,
          ),
          label: '홈',
        ),
        BottomNavigationBarItem(
          backgroundColor: Colors.white,
          icon: Icon(
            Icons.star,
          ),
          label: '나만의 지도',
        ),
        BottomNavigationBarItem(
          backgroundColor: Colors.white,
          icon: Icon(
            Icons.person,
          ),
          label: 'MY',
        ),
        // Add more BottomNavigationBarItems as needed
      ],
    );
  }
}
