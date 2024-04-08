import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jeonbuk_front/cubit/discount_store_cubit.dart';

class DiscountStoreMapScreen extends StatefulWidget {
  @override
  State<DiscountStoreMapScreen> createState() => _MyAppState();
}

class _MyAppState extends State<DiscountStoreMapScreen> {
  late NaverMapController mapController;

  NLatLng? myLocation;

  void _onMapCreated(NaverMapController controller) async{
    mapController = controller;
    await MarkUp(myLocation!);
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

  Future<void> MarkUp(NLatLng centerLocation) async {
    var storeList = [];
    double? zoomlevel = await _CurrentZoomLevel();
    print('zoomlevel: $zoomlevel');
    final width = MediaQuery.of(context).size.width /2;
    final meterPerDp = mapController.getMeterPerDpAtLatitude(latitude: centerLocation.latitude.toDouble(), zoom: zoomlevel);
    final radius = width * meterPerDp;
    print('radius: $radius');
    print('latitude: ${centerLocation.latitude}\n longitude: ${centerLocation.longitude}');
    storeList = await context
        .read<DiscountStoreCubit>()
        .loadDiscountStoreMapCenter(centerLocation.latitude.toDouble(), centerLocation.longitude.toDouble(),
            radius); // 상점 리스트를 비동기적으로 가져옴


    for (var store in storeList) {
      // 각 상점 위치에 대해 마커 생성 및 추가
      var marker = NMarker(
        id: store.id.toString(), // 고유한 마커 ID 할당
        position: NLatLng(store.latitude, store.longitude), // 상점의 위도와 경도 사용
        // 마커에 추가할 수 있는 다른 속성들을 여기에 추가할 수 있습니다.
      );
      marker.setOnTapListener((NMarker marker) {
        return Text(store.id.toString());
      }); // 마커를 tab 했을 때 이벤트
      mapController.addOverlay(marker); // 마커를 지도에 추가
    }
  }

  Future<double> _CurrentZoomLevel() async {
    final cameraPosition = await mapController.getCameraPosition();
    final currentZoom = cameraPosition.zoom;
    return currentZoom;
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      final Position position = await determinePosition();
      setState(() {
        myLocation = NLatLng(position.latitude, position.longitude);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final double radius = MediaQuery.of(context).size.width /2;
    return MaterialApp(
      home: Scaffold(
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
                  mapType: NMapType.basic,
                  indoorEnable: true,
                  activeLayerGroups: [
                    NLayerGroup.building,
                    NLayerGroup.transit,
                  ],
                  pickTolerance: 8,
                  rotationGesturesEnable: true,
                  scrollGesturesEnable: true,
                  zoomGesturesEnable: true,
                  extent: const NLatLngBounds(
                      southWest: NLatLng(31.43, 122.37),
                      northEast: NLatLng(44.35, 132.0)),
                  scaleBarEnable: true,
                  locationButtonEnable: true,
                ),
                onMapReady: _onMapCreated,
              )
            else
              Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
