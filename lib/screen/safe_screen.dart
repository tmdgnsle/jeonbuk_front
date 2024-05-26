import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:jeonbuk_front/components/app_navigation_bar.dart';
import 'package:jeonbuk_front/components/custom_box.dart';
import 'package:jeonbuk_front/const/color.dart';
import 'package:jeonbuk_front/cubit/discount_store_list_cubit.dart';
import 'package:jeonbuk_front/cubit/id_jwt_cubit.dart';
import 'package:jeonbuk_front/cubit/my_safe_home_map_cubit.dart';
import 'package:jeonbuk_front/cubit/restaurant_list_cubit.dart';
import 'package:jeonbuk_front/cubit/safe_home_cubit.dart';
import 'package:jeonbuk_front/screen/my_safe_home_screen.dart';
import 'package:jeonbuk_front/screen/restaurant_screen.dart';
import 'package:jeonbuk_front/screen/discount_store_screen.dart';
import 'package:jeonbuk_front/screen/safe_home_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class SafeScreen extends StatefulWidget {
  const SafeScreen({super.key});

  @override
  State<SafeScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<SafeScreen> {



  Future<void> makePhoneCall(String phoneNumber) async {
    String number = phoneNumber.replaceAll(RegExp(r'\s+'), ''); // 공백 제거

    bool? res = await FlutterPhoneDirectCaller.callNumber(number);

    if (res == null) {
      print('Failed to make a phone call');
    } else if (!res) {
      print('User declined to make a phone call');
    } else {
      print('Phone call made successfully');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double boxSize = (MediaQuery.of(context).size.width - 48) / 2;
    final double notchpadding = MediaQuery.of(context).padding.top + 10;
    final bloc = BlocProvider.of<IdJwtCubit>(context);
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
                                  builder: (context) => BlocProvider(
                                    create: (context) => SafeHomeCubit(),
                                    child: SafeHomeScreen(),
                                  ),
                                ));
                          },
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        CustomBox(
                          size: boxSize,
                          title: '내 안심귀가',
                          titleIcon: Icon(Icons.radar),
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
                          titleIcon: Icon(Icons.phone, color: Colors.red,),
                          firstDescription: '연락처에 저장된',
                          secontDescription: '사람에게 전화',
                          onTap: () {
                            makePhoneCall(bloc.state.idJwt.emergencyNum!);
                          },
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
