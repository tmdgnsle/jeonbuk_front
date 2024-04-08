import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jeonbuk_front/components/app_navigation_bar.dart';
import 'package:jeonbuk_front/const/color.dart';
import 'package:jeonbuk_front/cubit/discount_store_map_cubit.dart';
import 'package:jeonbuk_front/model/discount_store.dart';

class DiscountStoreMapScreen extends StatefulWidget {
  @override
  State<DiscountStoreMapScreen> createState() => _MyAppState();
}

class _MyAppState extends State<DiscountStoreMapScreen> {
  NaverMapController? mapController;

  NLatLng? myLocation;

  void firstLoadMapData() async {
    try {
      Position position = await determinePosition();
      setState(() {
        myLocation = NLatLng(position.latitude, position.longitude);
      });
      // double? zoomlevel = await _CurrentZoomLevel();
      // print('zoomlevel: $zoomlevel');
      // final width = MediaQuery.of(context).size.width / 2;
      // final meterPerDp = mapController.getMeterPerDpAtLatitude(
      //     latitude: position.latitude.toDouble(), zoom: zoomlevel);
      final radius = 50.0;
      // width * meterPerDp;
      // 위치 정보와 반지름을 Cubit에 전달
      context
          .read<DiscountStoreMapCubit>()
          .loadDiscountStoreMap(position.latitude, position.longitude, radius);
    } catch (e) {
      print('에러: ${e.toString()}');
      // 오류 처리, 예: 사용자에게 오류 메시지 표시
    }
  }

  void loadMapData(NLatLng centerLocation) async {
    try {
      double? zoomlevel = await _CurrentZoomLevel();
      print('zoomlevel: $zoomlevel');
      final width = MediaQuery.of(context).size.width / 2;
      final meterPerDp = mapController!.getMeterPerDpAtLatitude(
          latitude: centerLocation.latitude.toDouble(), zoom: zoomlevel);
      final radius = width * meterPerDp;
      print('radius: $radius');
      // 위치 정보와 반지름을 Cubit에 전달
      context.read<DiscountStoreMapCubit>().loadDiscountStoreMap(
          centerLocation.latitude, centerLocation.longitude, radius);
    } catch (e) {
      print('에러: ${e.toString()}');
      // 오류 처리, 예: 사용자에게 오류 메시지 표시
    }
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 위치 서비스가 활성화되어 있는지 확인합니다.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('위치 서비스가 비활성화되어 있습니다.');
    }

    // 위치 권한을 확인합니다.
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('위치 권한이 거부되었습니다.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // 권한이 영구적으로 거부된 경우
      return Future.error('위치 권한이 영구적으로 거부되었습니다. 설정에서 권한을 변경해주세요.');
    }

    // 현재 위치를 가져옵니다.
    return await Geolocator.getCurrentPosition();
  }

  void MarkUp(List<DiscountStore> storeList, BuildContext context) {
    for (var store in storeList) {
      var marker = NMarker(
        id: store.id.toString(),
        position: NLatLng(store.latitude, store.longitude),
        // 여기에 마커에 추가할 수 있는 다른 속성들을 추가할 수 있습니다.
      );

      marker.setOnTapListener((NMarker marker) {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(16)),
              height: 250, // 원하는 높이 설정
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(store.storeName),
                      IconButton(onPressed: () {}, icon: Icon(Icons.star)),
                    ],
                  ),
                  Text('${store.storeType}'),
                  Text('주소: ${store.roadAddress}'),
                  Text(store.etc.toString()),
                ],
              ),
            );
          },
        );
      });

      mapController!.addOverlay(marker);
    }
  }

  Future<double> _CurrentZoomLevel() async {
    final cameraPosition = await mapController!.getCameraPosition();
    final currentZoom = cameraPosition.zoom;
    return currentZoom;
  }

  Future<NLatLng> _CenterCoordinate() async {
    final cameraPosition = await mapController!.getCameraPosition();
    final centercoordinate = cameraPosition.target;
    return centercoordinate;
  }

  @override
  void initState() {
    super.initState();

    firstLoadMapData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocConsumer<DiscountStoreMapCubit, DiscountStoreMapCubitState>(
        listener: (context, state) {
          // Here, you can perform actions based on the state changes
          if (state is LoadedDiscountStoreMapCubitState &&
              mapController != null) {
            mapController!.clearOverlays();
            MarkUp(state.discountStoreMapResult.discountStoreMap, context);
            print(state.discountStoreMapResult.discountStoreMap);

            // Perform any additional actions if needed
          }
        },
        builder: (context, state) {
          void _onMapCreated(NaverMapController controller) async {
            mapController = controller;
            if (state is LoadedDiscountStoreMapCubitState) {
              MarkUp(state.discountStoreMapResult.discountStoreMap, context);
            }
          }

          return Scaffold(
            appBar: AppBar(
              title: Text('내 주변'),
            ),
            body: Stack(
              children: [
                if (myLocation != null)
                  NaverMap(
                    options: NaverMapViewOptions(
                      initialCameraPosition: NCameraPosition(
                        target: myLocation!,
                        zoom: 18,
                      ),
                      locationButtonEnable: true,
                    ),
                    onMapReady: _onMapCreated,
                  )
                else
                  Center(child: CircularProgressIndicator()),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                final NLatLng centerCoordinate = await _CenterCoordinate();
                loadMapData(centerCoordinate);
              },
              child: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              backgroundColor: GREEN_COLOR,
            ),
            bottomNavigationBar: AppNavigationBar(),
          );
        },
      ),
    );
  }
}
