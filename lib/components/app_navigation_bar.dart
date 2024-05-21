import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeonbuk_front/const/color.dart';
import 'package:jeonbuk_front/cubit/bookmark_map_cubit.dart';
import 'package:jeonbuk_front/screen/bookmark_map_screen.dart';
import 'package:jeonbuk_front/screen/home_screen.dart';
import 'package:jeonbuk_front/screen/my_setting_screen.dart';
import 'package:jeonbuk_front/screen/safe_screen.dart';

class AppNavigationBar extends StatelessWidget {
  AppNavigationBar({this.currentIndex, Key? key}) : super(key: key);

  final int? currentIndex;

  final List _screens = [
    HomeScreen(),
    SafeScreen(),
    BookmarkMapScreen(),
    MySettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      // 아이템 고정 타입 설정
      showUnselectedLabels: true,
      selectedItemColor: GREEN_COLOR,
      selectedIconTheme: IconThemeData(color: GREEN_COLOR, size: 32),
      selectedFontSize: 8,
      unselectedItemColor: BLUE_COLOR,
      unselectedIconTheme: IconThemeData(color: BLUE_COLOR, size: 32),
      unselectedFontSize: 8,
      backgroundColor: Colors.white,
      currentIndex: currentIndex ?? 0,
      onTap: (index) {
        if (index == 2) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => BookmarkMapCubit(),
                  child: _screens[index],
                ),
              ));
        } else {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => _screens[index]));
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.all(0), // 아이콘 주변 패딩 제거
            child: Icon(Icons.home),
          ),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.all(0), // 아이콘 주변 패딩 제거
            child: Icon(Icons.health_and_safety),
          ),
          label: '안심귀가',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.all(0), // 아이콘 주변 패딩 제거
            child: Icon(Icons.star),
          ),
          label: '나만의 지도',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.all(0), // 아이콘 주변 패딩 제거
            child: Icon(Icons.person),
          ),
          label: 'MY',
        ),
      ],
    );
  }
}
