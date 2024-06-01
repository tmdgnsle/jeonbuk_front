import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:jeonbuk_front/api/openapis.dart';
import 'package:jeonbuk_front/components/app_navigation_bar.dart';
import 'package:jeonbuk_front/const/color.dart';
import 'package:jeonbuk_front/const/filter.dart';
import 'package:jeonbuk_front/cubit/my_safe_home_map_cubit.dart';
import 'package:jeonbuk_front/model/my_safe_home.dart';

class SafeHomeDetailScreen extends StatefulWidget {
  final NLatLng start;
  final NLatLng end;
  final String title;

  const SafeHomeDetailScreen(
      {super.key, required this.start, required this.end, required this.title});

  @override
  State<SafeHomeDetailScreen> createState() => _MyAppState();
}

class _MyAppState extends State<SafeHomeDetailScreen> {
  NaverMapController? mapController;

  var startmarker;
  var endmarker;
  var markerIcon;

  void firstLoadMapData() async {
    try {
      final radius = 50.0;
      // width * meterPerDp;
      // 위치 정보와 반지름을 Cubit에 전달
      await context.read<MySafeHomeMapCubit>().firstLoadMySafeHomeMap(
            widget.start.latitude,
            widget.start.longitude,
            radius,
          );
    } catch (e) {
      print('에러: ${e.toString()}');
      // 오류 처리, 예: 사용자에게 오류 메시지 표시
    }
  }

  void loadMapDataAll(NLatLng centerLocation) async {
    try {
      double? zoomlevel = await _CurrentZoomLevel();
      print('zoomlevel: $zoomlevel');
      final width = MediaQuery.of(context).size.width / 2;
      final meterPerDp = mapController!.getMeterPerDpAtLatitude(
          latitude: centerLocation.latitude.toDouble(), zoom: zoomlevel);
      final radius = width * meterPerDp;
      print('radius: $radius');
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
      double? zoomlevel = await _CurrentZoomLevel();
      final width = MediaQuery.of(context).size.width / 2;
      final meterPerDp = mapController!.getMeterPerDpAtLatitude(
          latitude: centerLocation.latitude.toDouble(), zoom: zoomlevel);
      final radius = width * meterPerDp;
      // 위치 정보와 반지름을 Cubit에 전달
      context.read<MySafeHomeMapCubit>().loadMySafeHomeMapFilter(
          centerLocation.latitude,
          centerLocation.longitude,
          radius,
          filter.toString());
    } catch (e) {
      print('에러: ${e.toString()}');
      // 오류 처리, 예: 사용자에게 오류 메시지 표시
    }
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
                  print('filterValue: $filterValue');
                },
                child: Container(
                  width: filterWidth,
                  decoration: BoxDecoration(
                    color: safeFilterColor[index], // 이 예제에서는 색상을 고정값으로 설정
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 8,
                        spreadRadius: 0,
                        offset: const Offset(0, 0),
                      ),
                    ],
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

  void MarkupPath() async {
    markerIcon = await NOverlayImage.fromWidget(
        widget: Icon(
          Icons.place,
          color: Color(0xFF014594),
        ),
        size: Size(24, 24),
        context: context);

    startmarker =
        NMarker(id: 'start', position: widget.start, icon: markerIcon);
    endmarker = NMarker(id: 'end', position: widget.end, icon: markerIcon);

    mapController!.addOverlay(startmarker);
    mapController!.addOverlay(endmarker);

    var path = await OpenApis().fetchRoute(widget.start, widget.end);
    var pathOverlay = NPathOverlay(
      id: 'road',
      coords: path,
      color: Color(0xFF014594),
      width: 5,
    );
    mapController!.addOverlay(pathOverlay);
    print('MarkupPath 완료');
  }

  // ignore: non_constant_identifier_names
  void MarkUp(List<MySafeHome> mysafeHomeList, BuildContext context) async {
    for (var mySafeHome in mysafeHomeList) {
      NOverlayImage? markerIcon;

      print('타입: ${mySafeHome.type}');

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
        // iconTintColor: markerColor!,
        icon: markerIcon,
        // NOverlayImage.fromAssetImage('assets/images/${markerIcon}'),
        // size: Size(15, 20),

        // 여기에 마커에 추가할 수 있는 다른 속성들을 추가할 수 있습니다.
      );

      print('marker.iconTintColor: ${marker.iconTintColor}');

      mapController!.addOverlay(marker);
      print('Markup 완료');
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
          mapController!.clearOverlays(
            type: NOverlayType.marker,
          );
          mapController!.addOverlay(startmarker);
          mapController!.addOverlay(endmarker);
          MarkUp(state.mysafeHomeMapResult.mySafeHomeMap, context);
        }
      },
      builder: (context, state) {
        void _onMapCreated(NaverMapController controller) async {
          mapController = controller;
          print('state: $state');
          if (state is LoadedMySafeHomeMapCubitState) {
            print('state: $state');
            MarkupPath();
            MarkUp(state.mysafeHomeMapResult.mySafeHomeMap, context);
          }
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              widget.title,
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
              NaverMap(
                options: NaverMapViewOptions(
                  initialCameraPosition: NCameraPosition(
                    target: NLatLng(
                        widget.start.latitude, widget.start.longitude),
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
                    final NLatLng centerCoordinate =
                    await _CenterCoordinate();
                    if (state.mysafeHomeMapResult.category == 'all') {
                      loadMapDataAll(centerCoordinate);
                    } else {
                      loadMapDataFilter(centerCoordinate,
                          state.mysafeHomeMapResult.category);
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
