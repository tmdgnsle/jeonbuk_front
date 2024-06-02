import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeonbuk_front/const/color.dart';
import 'package:jeonbuk_front/cubit/bookmark_map_cubit.dart';
import 'package:jeonbuk_front/screen/bookmark_map_screen.dart';
import 'package:jeonbuk_front/screen/home_screen.dart';

class AppNavigationBar extends StatelessWidget {
  AppNavigationBar({required this.currentIndex, Key? key}) : super(key: key);

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.25),
              offset: Offset(0, 0),
              spreadRadius: 1,
              blurRadius: 18)
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        selectedItemColor: GREEN_COLOR,
        selectedIconTheme: const IconThemeData(color: GREEN_COLOR, size: 32),
        selectedFontSize: 8,
        unselectedItemColor: BLUE_COLOR,
        unselectedIconTheme: const IconThemeData(color: BLUE_COLOR, size: 32),
        unselectedFontSize: 8,
        backgroundColor: Colors.white,
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == 2) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => BookmarkMapCubit(),
                    child: BookmarkMapScreen(),
                  ),
                ));
          } else {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => HomeScreen(currentIndex: index)));
          }
        },
        items: [
          const BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.all(0), // 아이콘 주변 패딩 제거
              child: Icon(Icons.home),
            ),
            label: '홈',
          ),
          const BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.all(0), // 아이콘 주변 패딩 제거
              child: Icon(Icons.health_and_safety),
            ),
            label: '안심귀가',
          ),
          const BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.all(0), // 아이콘 주변 패딩 제거
              child: Icon(Icons.star),
            ),
            label: '나만의 지도',
          ),
          const BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.all(0), // 아이콘 주변 패딩 제거
              child: Icon(Icons.person),
            ),
            label: 'MY',
          ),
        ],
      ),
    );
  }
}
