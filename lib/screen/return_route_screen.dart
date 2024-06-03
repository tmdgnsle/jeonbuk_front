import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:jeonbuk_front/components/app_navigation_bar.dart';
import 'package:jeonbuk_front/components/custom_safe_box.dart';
import 'package:jeonbuk_front/const/color.dart';
import 'package:jeonbuk_front/cubit/id_jwt_cubit.dart';
import 'package:jeonbuk_front/cubit/my_safe_home_map_cubit.dart';
import 'package:jeonbuk_front/cubit/return_route_cubit.dart';
import 'package:jeonbuk_front/screen/add_return_screen.dart';
import 'package:jeonbuk_front/screen/safe_home_detail_screen.dart';

class ReturnRouteScreen extends StatefulWidget {
  const ReturnRouteScreen({super.key});

  @override
  State<ReturnRouteScreen> createState() => _ReturnRouteScreenState();
}

class _ReturnRouteScreenState extends State<ReturnRouteScreen> {
  late String memberId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final bloc = BlocProvider.of<IdJwtCubit>(context);
    memberId = bloc.state.idJwt.id!;
    context.read<ReturnRouteCubit>().loadReturnRouteList(memberId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReturnRouteCubit, ReturnRouteCubitState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('귀가경로'),
            actions: [
              IconButton(
                onPressed: () async {
                  final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: ReturnRouteCubit(),
                          child: const AddReturnScreen(),
                        ),
                      ));
                  if (result == true) {
                    context
                        .read<ReturnRouteCubit>()
                        .loadReturnRouteList(memberId);
                  }
                },
                icon: const Icon(Icons.add),
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

  Widget _buildBody(ReturnRouteCubitState state) {
    if (state is ErrorReturnRouteCubitState) {
      return _error(state.errorMessage);
    }
    if (state is LoadedReturnRouteCubitState ||
        state is LoadingReturnRouteCubitState) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return CustomSafeBox(
                    name:
                        state.returnRouteListResult.returnRouteList[index].name,
                    start: NLatLng(
                        state.returnRouteListResult.returnRouteList[index]
                            .startLa,
                        state.returnRouteListResult.returnRouteList[index]
                            .startLo),
                    end: NLatLng(
                        state
                            .returnRouteListResult.returnRouteList[index].endLa,
                        state.returnRouteListResult.returnRouteList[index]
                            .endLo),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (context) => MySafeHomeMapCubit(),
                              child: SafeHomeDetailScreen(
                                  start: NLatLng(
                                      state.returnRouteListResult
                                          .returnRouteList[index].startLa,
                                      state.returnRouteListResult
                                          .returnRouteList[index].startLo),
                                  end: NLatLng(
                                      state.returnRouteListResult
                                          .returnRouteList[index].endLa,
                                      state.returnRouteListResult
                                          .returnRouteList[index].endLo),
                                  title: state.returnRouteListResult
                                      .returnRouteList[index].name),
                            ),
                          ));
                    },
                    onLongPress: () {
                      final safeCubit = context.read<ReturnRouteCubit>();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('알림'),
                            content: Text(
                                '${state.returnRouteListResult.returnRouteList[index].name}을 삭제하시겠습니까?'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('확인'),
                                onPressed: () {
                                  safeCubit.deleteReturnRouteList(
                                      memberId,
                                      state.returnRouteListResult
                                          .returnRouteList[index].id);
                                  print('state: $state');
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: const Text('취소'),
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
                itemCount: state.returnRouteListResult.returnRouteList.length,
              ),
            ),
            const Text(
              '꾹 눌러서 삭제합니다.',
              textAlign: TextAlign.center,
              style: TextStyle(color: GREY_COLOR),
            ),
            const SizedBox(
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
