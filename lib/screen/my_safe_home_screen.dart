import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jeonbuk_front/components/app_navigation_bar.dart';
import 'package:jeonbuk_front/const/color.dart';
import 'package:jeonbuk_front/const/filter.dart';
import 'package:jeonbuk_front/cubit/my_safe_home_map_cubit.dart';
import 'package:jeonbuk_front/model/my_safe_home.dart';

class MySafeHomeScreen extends StatefulWidget {
  @override
  State<MySafeHomeScreen> createState() => _MyAppState();
}

class _MyAppState extends State<MySafeHomeScreen> {
  NaverMapController? mapController;

  NLatLng? myLocation;

  void firstLoadMapData() async {
    try {
      Position position = await determinePosition();
      setState(() {
        myLocation = NLatLng(position.latitude, position.longitude);
      });

      final radius = 50.0;
      // width * meterPerDp;
      // 위치 정보와 반지름을 Cubit에 전달
      context.read<MySafeHomeMapCubit>().firstLoadMySafeHomeMap(
          position.latitude, position.longitude, radius);
    } catch (e) {
      print('에러: ${e.toString()}');
      // 오류 처리, 예: 사용자에게 오류 메시지 표시
    }
  }

  void loadMapDataAll(NLatLng centerLocation) async {
    try {
      double? zoomlevel = await _CurrentZoomLevel();
      final width = MediaQuery.of(context).size.width / 2;
      final meterPerDp = mapController!.getMeterPerDpAtLatitude(
          latitude: centerLocation.latitude.toDouble(), zoom: zoomlevel);
      final radius = width * meterPerDp;
      // 위치 정보와 반지름을 Cubit에 전달
      context.read<MySafeHomeMapCubit>().loadMySafeHomeMapFilter(
          centerLocation.latitude, centerLocation.longitude, radius, 'all');
    } catch (e) {
      print('에러: ${e.toString()}');
      // 오류 처리, 예: 사용자에게 오류 메시지 표시
    }
  }

  void loadMapDataFilter(NLatLng centerLocation, String filter) async {
    try {
      final bloc = BlocProvider.of<MySafeHomeMapCubit>(context);
      double? zoomlevel = await _CurrentZoomLevel();
      final width = MediaQuery.of(context).size.width / 2;
      final meterPerDp = mapController!.getMeterPerDpAtLatitude(
          latitude: centerLocation.latitude.toDouble(), zoom: zoomlevel);
      final radius = width * meterPerDp;
      // 위치 정보와 반지름을 Cubit에 전달

      context.read<MySafeHomeMapCubit>().loadMySafeHomeMapFilter(
          centerLocation.latitude, centerLocation.longitude, radius, filter);
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

  Widget FilterView(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const filterHeight = 30.0;
    return Positioned(
      top: 10,
      left: 0,
      width: screenWidth,
      // 스크린의 전체 너비를 사용
      height: filterHeight,
      // 높이 지정
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: mysafeHomeFilter.keys.length,
          itemBuilder: (context, index) {
            final filterKeys =
                mysafeHomeFilter.keys.toList(); // Map의 키를 리스트로 변환
            final filterName = filterKeys[index]; // 현재 인덱스에 해당하는 키
            final filterValue =
                mysafeHomeFilter[filterName]; // 키를 사용하여 Map에서 값을 얻음
            final filterWidth = MediaQuery.of(context).size.width / 4;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: InkWell(
                onTap: () async {
                  final NLatLng centerLocation = await _CenterCoordinate();
                  loadMapDataFilter(centerLocation, filterValue!);
                },
                child: Container(
                  width: filterWidth,
                  decoration: BoxDecoration(
                    color: safeFilterColor[index], // 이 예제에서는 색상을 고정값으로 설정
                    borderRadius: BorderRadius.circular(30),

                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (index != 0)
                        Icon(
                          mysafeHomeIcon[index - 1],
                          color: Colors.white,
                        ),
                      Text(
                        filterName, // Map의 키를 텍스트로 사용
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  // ignore: non_constant_identifier_names
  void MarkUp(List<MySafeHome> mysafeHomeList, BuildContext context) async {
    for (var mySafeHome in mysafeHomeList) {
      NOverlayImage? markerIcon;


      switch (mySafeHome.type.toString()) {
        case 'WARNING_BELL':
          markerIcon = await NOverlayImage.fromWidget(
              widget: Icon(
                mysafeHomeIcon[0],
                color: safeFilterColor[1],
              ),
              size: Size(24, 24),
              context: context);
          break;
        case 'CCTV':
          markerIcon = await NOverlayImage.fromWidget(
              widget: Icon(
                mysafeHomeIcon[1],
                color: safeFilterColor[2],
              ),
              size: Size(24, 24),
              context: context);
          break;
        case 'STREET_LAMP':
          markerIcon = await NOverlayImage.fromWidget(
              widget: Icon(
                mysafeHomeIcon[2],
                color: safeFilterColor[3],
              ),
              size: Size(24, 24),
              context: context);
          break;
      }

      var marker = NMarker(
        id: mySafeHome.id.toString(),
        position: NLatLng(mySafeHome.latitude, mySafeHome.longitude),
        icon: markerIcon,

        // 여기에 마커에 추가할 수 있는 다른 속성들을 추가할 수 있습니다.
      );


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
    return BlocConsumer<MySafeHomeMapCubit, MySafeHomeMapCubitState>(
      listener: (context, state) {
        if (state is LoadedMySafeHomeMapCubitState && mapController != null) {
          mapController!.clearOverlays();
          MarkUp(state.mysafeHomeMapResult.mySafeHomeMap, context);
        }
      },
      builder: (context, state) {
        void _onMapCreated(NaverMapController controller) async {
          mapController = controller;
          if (state is LoadedMySafeHomeMapCubitState) {
            MarkUp(state.mysafeHomeMapResult.mySafeHomeMap, context);
          }
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              '내 주변',
              textAlign: TextAlign.center,
            ),
          ),
          body: Stack(
            children: [
              if(state is ErrorMySafeHomeMapCubitState)
                Center(child: Text(state.errorMessage),)
              else if (state is FirstLoadingMySafeHomeMapCubitState)
                Center(child: CircularProgressIndicator(),)
              else if (state is LoadedMySafeHomeMapCubitState || state is LoadingMySafeHomeMapCubitState)
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
                ),
              Positioned(top: 0, child: FilterView(context)),
              Positioned(
                top: 50,
                right: 10,
                child: FloatingActionButton(
                  onPressed: () async {
                    final NLatLng centerCoordinate = await _CenterCoordinate();
                    if (state.mysafeHomeMapResult.category == 'all') {
                      loadMapDataAll(centerCoordinate);
                    } else {
                      loadMapDataFilter(
                          centerCoordinate, state.mysafeHomeMapResult.category);
                    }
                  },
                  child: Icon(
                    Icons.autorenew,
                    color: Colors.white,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28.0)),
                  backgroundColor: GREEN_COLOR,
                ),
              ),
              if (myLocation == null)
                const Center(child: CircularProgressIndicator()),
            ],
          ),
          bottomNavigationBar: AppNavigationBar(
            currentIndex: 1,
          ),
        );
      },
    );
  }
}
