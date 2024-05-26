import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeonbuk_front/components/app_navigation_bar.dart';
import 'package:jeonbuk_front/components/custom_box.dart';
import 'package:jeonbuk_front/const/color.dart';
import 'package:jeonbuk_front/cubit/discount_store_list_cubit.dart';
import 'package:jeonbuk_front/cubit/festival_list_cubit.dart';
import 'package:jeonbuk_front/cubit/restaurant_list_cubit.dart';
import 'package:jeonbuk_front/cubit/town_stroll_map_cubit.dart';
import 'package:jeonbuk_front/screen/festival_screen.dart';
import 'package:jeonbuk_front/screen/restaurant_screen.dart';
import 'package:jeonbuk_front/screen/discount_store_screen.dart';
import 'package:jeonbuk_front/screen/safe_home_screen.dart';
import 'package:jeonbuk_front/screen/town_stroll_map_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<HomeScreen> {
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
                          title: '음식점',
                          titleIcon: const Icon(Icons.restaurant),
                          firstDescription: '전북의 맛있는 음식점들',
                          secontDescription: '야무지게 먹어야징~',
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                    create: (context) => RestaurantListCubit(),
                                    child: RestaurantScreen(),
                                  ),
                                ));
                          },
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        CustomBox(
                          size: boxSize,
                          title: '할인매장',
                          titleIcon: const Icon(
                            Icons.shopping_bag,
                          ),
                          backgroundColor: const Color(0xFF69F7B4),
                          firstDescription: '전북의 알뜰 소식을',
                          secontDescription: '한눈에 쏘옥~',
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                    create: (context) =>
                                        DiscountStoreListCubit(),
                                    child: DiscountStoreScreen(),
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
                          title: '축제',
                          titleIcon: Icon(Icons.festival),
                          firstDescription: '전북의 모든 축제정보를',
                          secontDescription: '만나보세요~',
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                    create: (context) => FestivalListCubit(),
                                    child: FestivalScreen(),
                                  ),
                                ));
                          },
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        CustomBox(
                          size: boxSize,
                          title: '동네 마실',
                          titleIcon: const Icon(Icons.directions_walk),
                          firstDescription: '우리 집앞에',
                          secontDescription: '이런곳이~~!',
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                    create: (context) => TownStrollMapCubit(),
                                    child: TownStrollMapScreen(),
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
                          title: '챗봇',
                          firstDescription: '짹짹이에게 물어',
                          secontDescription: '보세요',
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
        currentIndex: 0,
      ),
    );
  }
}
