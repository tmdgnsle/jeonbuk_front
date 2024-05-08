
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:jeonbuk_front/api/openapis.dart';
import 'package:jeonbuk_front/components/app_navigation_bar.dart';
import 'package:jeonbuk_front/components/custom_text_field.dart';
import 'package:jeonbuk_front/const/color.dart';
import 'package:jeonbuk_front/cubit/id_jwt_cubit.dart';

class AddSafeScreen extends StatefulWidget {
  const AddSafeScreen({super.key});

  @override
  State<AddSafeScreen> createState() => _AddSafeScreenState();
}

class _AddSafeScreenState extends State<AddSafeScreen> {
  final TextEditingController pathController = TextEditingController();
  final TextEditingController startController = TextEditingController();
  final TextEditingController endController = TextEditingController();
  String? memberId;

  void getMemberId(){
    final bloc = BlocProvider.of<IdJwtCubit>(context);
    memberId = bloc.state.idJwt.id!;
  }

  Future<NLatLng> getCoordinatesFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      Location location = locations[0];
      print('위도: ${location.latitude}, 경도: ${location.longitude}');
      return NLatLng(location.latitude, location.longitude);
    } catch (e) {
      print('에러: $e');
      return NLatLng(0, 0);
    }
  }


  // Future<NLatLng> getCoordinatesFromAddress(String address) async {
  //   final String clientId = 'nf68z75anv';
  //   final String clientSecret = '7E6AKAFUGzQtjiVTq2CSz9qKfOBJlM7mA1ZqdHyf';
  //
  //   final String apiUrl = 'https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode';
  //   final Map<String, String> queryParams = {
  //     'query': address,
  //   };
  //
  //   try {
  //     final Dio dio = Dio();
  //     final Response response = await dio.get(
  //       apiUrl,
  //       queryParameters: queryParams,
  //       options: Options(
  //         headers: {
  //           'X-NCP-APIGW-API-KEY-ID': clientId,
  //           'X-NCP-APIGW-API-KEY': clientSecret,
  //         },
  //       ),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       print(response.data.toString());
  //       final Map<String, dynamic> data = json.decode(response.data.toString());
  //       print(data['addresses'][0]['y']);
  //       final double latitude = data['addresses'][0]['y'];
  //       final double longitude = data['addresses'][0]['x'];
  //       print('위도: $latitude, 경도: $longitude');
  //       return NLatLng(latitude, longitude);
  //     } else {
  //       print('에러: ${response.statusMessage}');
  //       return NLatLng(0, 0);
  //     }
  //   } catch (e) {
  //     print('에러: $e');
  //     return NLatLng(0, 0);
  //   }
  // }

  @override
  void initState() {
    getMemberId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('안심귀가 추가'),
        actions: [
          TextButton(
              onPressed: () async{

                NLatLng start = await getCoordinatesFromAddress(startController.text);
                NLatLng end = await getCoordinatesFromAddress(endController.text);

                if(start == NLatLng(0,0) || end == NLatLng(0,0)){
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('알림'),
                        content: Text('주소지를 정확히 입력해주세요.'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('확인'),
                            onPressed: () {
                              Navigator.of(context).pop(); // 알림창 닫기
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  final int response = await OpenApis().SafeAdd(memberId!, pathController.text, start.latitude, start.longitude, end.latitude, end.longitude);
                  if(response == 200){
                    print('성공');
                    Navigator.of(context).pop();
                  }
                }


              },
              child: Text(
                '저장',
                style: TextStyle(color: BLUE_COLOR),
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('이름'),
            CustomTextField(
                controller: pathController,
                hintText: '경로 이름을 정해주세요.',
                obscure: false,
                height: 50),
            SizedBox(
              height: 10,
            ),
            Text('출발지'),
            CustomTextField(
                controller: startController,
                hintText: '주소를 정확하게 입력해주세요.',
                obscure: false,
                height: 50),
            SizedBox(
              height: 10,
            ),
            Text('도착치'),
            CustomTextField(
              controller: endController,
              hintText: '주소를 정확하게 입력해주세요.',
              obscure: false,
              height: 50,
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppNavigationBar(currentIndex: 1,),
    );
  }
}
