import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:jeonbuk_front/components/app_navigation_bar.dart';
import 'package:jeonbuk_front/components/custom_bookmark_box.dart';
import 'package:jeonbuk_front/const/color.dart';
import 'package:jeonbuk_front/cubit/safe_home_cubit.dart';
import 'package:jeonbuk_front/screen/add_safe_screen.dart';

class SafeHomeScreen extends StatefulWidget {
  const SafeHomeScreen({super.key});

  @override
  State<SafeHomeScreen> createState() => _SafeHomeScreenState();
}

class _SafeHomeScreenState extends State<SafeHomeScreen> {
  Widget _error(String errMessage) {
    return Center(
      child: Text(errMessage),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<SafeHomeCubit>().loadSafeHomeList('abcd1234');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('안심귀가'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddSafeScreen()));
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: BlocBuilder<SafeHomeCubit, SafeHomeCubitState>(
        builder: (context, state) {
          if (state is ErrorSafeHomeCubitState) {
            return _error(state.errorMessage);
          }
          if (state is LoadedSafeHomeCubitState ||
              state is LoadingSafeHomeCubitState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          return
                          CustomBookmarkBox(
                            name: state
                                .safeHomeListResult.safehomeList[index].name,
                            start: NLatLng(
                                state.safeHomeListResult.safehomeList[index]
                                    .startLa,
                                state.safeHomeListResult.safehomeList[index]
                                    .startLo),
                            end: NLatLng(
                                state.safeHomeListResult.safehomeList[index]
                                    .endLa,
                                state.safeHomeListResult.safehomeList[index]
                                    .endLo),
                            onTap: () {},
                            onLongPress: () {},
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(
                              height: 16,
                            ),
                        itemCount:
                            state.safeHomeListResult.safehomeList.length),
                  ),
                  Text('꾹 눌러서 삭제합니다.', textAlign: TextAlign.center, style: TextStyle(color: GREY_COLOR),),
                  SizedBox(height: 10,),
                ],
              ),
            );
          } else {
            return Container();
          }
        },
      ),
      bottomNavigationBar: AppNavigationBar(currentIndex: 1,),
    );
  }
}
