import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:jeonbuk_front/components/app_navigation_bar.dart';
import 'package:jeonbuk_front/components/custom_safe_box.dart';
import 'package:jeonbuk_front/const/color.dart';
import 'package:jeonbuk_front/cubit/id_jwt_cubit.dart';
import 'package:jeonbuk_front/cubit/my_safe_home_map_cubit.dart';
import 'package:jeonbuk_front/cubit/safe_home_cubit.dart';
import 'package:jeonbuk_front/screen/add_safe_screen.dart';
import 'package:jeonbuk_front/screen/safe_home_detail_screen.dart';

class SafeHomeScreen extends StatefulWidget {
  const SafeHomeScreen({super.key});

  @override
  State<SafeHomeScreen> createState() => _SafeHomeScreenState();
}

class _SafeHomeScreenState extends State<SafeHomeScreen> {
  late String memberId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final bloc = BlocProvider.of<IdJwtCubit>(context);
    memberId = bloc.state.idJwt.id!;
    context.read<SafeHomeCubit>().loadSafeHomeList(memberId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SafeHomeCubit, SafeHomeCubitState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('귀가경로'),
            actions: [
              IconButton(
                onPressed: () async {
                  final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: SafeHomeCubit(),
                          child: AddSafeScreen(),
                        ),
                      ));
                  if (result == true) {
                    context.read<SafeHomeCubit>().loadSafeHomeList(memberId);
                  }
                },
                icon: Icon(Icons.add),
              )
            ],
          ),
          body: _buildBody(state),
          bottomNavigationBar: AppNavigationBar(
            currentIndex: 1,
          ),
        );
      },
    );
  }

  Widget _buildBody(SafeHomeCubitState state) {
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
                  return CustomSafeBox(
                    name: state.safeHomeListResult.safehomeList[index].name,
                    start: NLatLng(
                        state.safeHomeListResult.safehomeList[index].startLa,
                        state.safeHomeListResult.safehomeList[index].startLo),
                    end: NLatLng(
                        state.safeHomeListResult.safehomeList[index].endLa,
                        state.safeHomeListResult.safehomeList[index].endLo),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (context) => MySafeHomeMapCubit(),
                              child: SafeHomeDetailScreen(
                                  start: NLatLng(
                                      state.safeHomeListResult
                                          .safehomeList[index].startLa,
                                      state.safeHomeListResult
                                          .safehomeList[index].startLo),
                                  end: NLatLng(
                                      state.safeHomeListResult
                                          .safehomeList[index].endLa,
                                      state.safeHomeListResult
                                          .safehomeList[index].endLo),
                                  title: state.safeHomeListResult
                                      .safehomeList[index].name),
                            ),
                          ));
                    },
                    onLongPress: () {
                      final safeCubit = context.read<SafeHomeCubit>();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('알림'),
                            content: Text(
                                '${state.safeHomeListResult.safehomeList[index].name}을 삭제하시겠습니까?'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('확인'),
                                onPressed: () {
                                  safeCubit.deleteSafeHomeList(
                                      memberId,
                                      state.safeHomeListResult
                                          .safehomeList[index].id);
                                  Navigator.of(context).pop();
                                  print("이전 화면으로 돌아가서 상태: ${safeCubit.state}");
                                },
                              ),
                              TextButton(
                                child: Text('취소'),
                                onPressed: () {
                                  Navigator.of(context).pop(); // 알림창 닫기
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(
                  height: 16,
                ),
                itemCount: state.safeHomeListResult.safehomeList.length,
              ),
            ),
            Text(
              '꾹 눌러서 삭제합니다.',
              textAlign: TextAlign.center,
              style: TextStyle(color: GREY_COLOR),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _error(String errMessage) {
    return Center(
      child: Text(errMessage),
    );
  }
}
