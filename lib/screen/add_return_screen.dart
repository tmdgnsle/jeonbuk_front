import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:jeonbuk_front/components/app_navigation_bar.dart';
import 'package:jeonbuk_front/components/custom_text_field.dart';
import 'package:jeonbuk_front/const/color.dart';
import 'package:jeonbuk_front/cubit/id_jwt_cubit.dart';
import 'package:jeonbuk_front/cubit/return_route_cubit.dart';

class AddReturnScreen extends StatefulWidget {
  const AddReturnScreen({super.key});

  @override
  State<AddReturnScreen> createState() => _AddReturnScreenState();
}

class _AddReturnScreenState extends State<AddReturnScreen> {
  final TextEditingController pathController = TextEditingController();
  final TextEditingController startController = TextEditingController();
  final TextEditingController endController = TextEditingController();
  String? memberId;
  String? jwt;

  void getMemberId() {
    final bloc = BlocProvider.of<IdJwtCubit>(context);
    memberId = bloc.state.idJwt.id!;
    jwt = bloc.state.idJwt.jwt!;
  }

  Future<NLatLng> getCoordinatesFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      Location location = locations[0];
      return NLatLng(location.latitude, location.longitude);
    } catch (e) {
      return const NLatLng(0, 0);
    }
  }

  @override
  void initState() {
    getMemberId();
    context.read<ReturnRouteCubit>().loadReturnRouteList(memberId!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('안심귀가 추가'),
        actions: [
          TextButton(
              onPressed: () async {
                NLatLng start =
                    await getCoordinatesFromAddress(startController.text);
                NLatLng end =
                    await getCoordinatesFromAddress(endController.text);

                if (start == const NLatLng(0, 0) ||
                    end == const NLatLng(0, 0)) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('알림'),
                        content: const Text('주소지를 정확히 입력해주세요.'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('확인'),
                            onPressed: () {
                              Navigator.of(context).pop(); // 알림창 닫기
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  final safeCubit = context.read<ReturnRouteCubit>();
                  final int response = await safeCubit.SafeAdd(
                      memberId!,
                      pathController.text,
                      start.latitude,
                      start.longitude,
                      end.latitude,
                      end.longitude);
                  print('response: $response');
                  if (response == 200) {
                    Navigator.of(context).pop(true);
                  }
                }
              },
              child: const Text(
                '저장',
                style: TextStyle(color: BLUE_COLOR),
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                '이름',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              CustomTextField(
                  controller: pathController,
                  hintText: '경로 이름을 정해주세요.',
                  obscure: false,
                  height: 50),
              const SizedBox(
                height: 20,
              ),
              const Text(
                '출발지',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 5,
              ),
              CustomTextField(
                  controller: startController,
                  hintText: '주소를 정확하게 입력해주세요.',
                  obscure: false,
                  height: 50),
              const SizedBox(
                height: 20,
              ),
              const Text(
                '도착치',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 5,
              ),
              CustomTextField(
                controller: endController,
                hintText: '주소를 정확하게 입력해주세요.',
                obscure: false,
                height: 50,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                '현재 전주시, 군산시, 남원시, 익산시, 완주군만 지원합니다.',
                textAlign: TextAlign.center,
                style: TextStyle(color: GREY_COLOR, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppNavigationBar(
        currentIndex: 1,
      ),
    );
  }
}
