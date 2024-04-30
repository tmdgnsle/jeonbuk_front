import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeonbuk_front/components/app_navigation_bar.dart';
import 'package:jeonbuk_front/components/custom_box.dart';
import 'package:jeonbuk_front/const/color.dart';
import 'package:jeonbuk_front/cubit/discount_store_list_cubit.dart';
import 'package:jeonbuk_front/cubit/my_safe_home_map_cubit.dart';
import 'package:jeonbuk_front/cubit/restaurant_list_cubit.dart';
import 'package:jeonbuk_front/screen/my_safe_home_screen.dart';
import 'package:jeonbuk_front/screen/restaurant_screen.dart';
import 'package:jeonbuk_front/screen/discount_store_screen.dart';
import 'package:jeonbuk_front/screen/safe_home_screen.dart';

class SafeScreen extends StatefulWidget {
  const SafeScreen({super.key});

  @override
  State<SafeScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<SafeScreen> {
  @override
  Widget build(BuildContext context) {
    final double boxSize = (MediaQuery.of(context).size.width - 48) / 2;
    final double notchpadding = MediaQuery.of(context).padding.top + 10;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: notchpadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/images/image.png'),
            const SizedBox(
              height: 12,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        CustomBox(
                          size: boxSize,
                          title: '안심귀가',
                          titleIcon: const Icon(
                            Icons.home,
                            color: BLUE_COLOR,
                          ),
                          backgroundColor: SKY_COLOR,
                          firstDescription: '내가 설정한 위치까지의',
                          secontDescription: '안전정보 확인',
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SafeHomeScreen()));
                          },
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        CustomBox(
                          size: boxSize,
                          title: '내 안심귀가',
                          firstDescription: '현재 내 주변의',
                          secontDescription: '안전정보 확인',
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                    create: (context) => MySafeHomeMapCubit(),
                                    child: MySafeHomeScreen(),
                                  ),
                                ));
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        CustomBox(
                          size: boxSize,
                          title: '비상전화',
                          firstDescription: '연락처에 저장된',
                          secontDescription: '사람에게 전화',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppNavigationBar(
        currentIndex: 1,
      ),
    );
  }
}
