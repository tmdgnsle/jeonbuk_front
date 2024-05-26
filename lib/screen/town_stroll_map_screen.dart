import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jeonbuk_front/api/openapis.dart';
import 'package:jeonbuk_front/components/app_navigation_bar.dart';
import 'package:jeonbuk_front/const/color.dart';
import 'package:jeonbuk_front/cubit/id_jwt_cubit.dart';
import 'package:jeonbuk_front/cubit/town_stroll_map_cubit.dart';
import 'package:jeonbuk_front/model/town_stroll.dart';
import 'package:sheet/sheet.dart';

class TownStrollMapScreen extends StatefulWidget {
  @override
  State<TownStrollMapScreen> createState() => _MyAppState();
}

class _MyAppState extends State<TownStrollMapScreen> {
  NaverMapController? mapController;
  Widget? bottomsheet;

  NLatLng? myLocation;
  bool isBookmarkLoading = false;
  Map<int, bool> bookmarkStatus = {};

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }

  void firstLoadMapData() async {
    try {
      Position position = await determinePosition();
      setState(() {
        myLocation = NLatLng(position.latitude, position.longitude);
      });

      final radius = 50.0;
      // width * meterPerDp;
      // 위치 정보와 반지름을 Cubit에 전달
      context.read<TownStrollMapCubit>().firstLoadTownStrollMap(
          position.latitude, position.longitude, radius);
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
      context.read<TownStrollMapCubit>().loadTownStrollMap(
          centerLocation.latitude, centerLocation.longitude, radius);
      print('현재 상태: ${context.read<TownStrollMapCubit>().state}');
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

  void toggleBookmark(String memberId, int storeId) async {
    setState(() {
      isBookmarkLoading = true; // 즐겨찾기 로딩 상태 시작
    });

    final townStroll = BlocProvider.of<TownStrollMapCubit>(context);
    int index = townStroll.state.townStrollMapResult.townStrollMap
        .indexWhere((element) => element.id == storeId);

    try {
      if (index != -1) {
        if (townStroll
            .state.townStrollMapResult.townStrollMap[index].isbookmark) {
          // 이미 즐겨찾기에 등록된 경우, 즐겨찾기 삭제
          townStroll.state.townStrollMapResult.townStrollMap[index].isbookmark =
              false;
          await OpenApis().deleteBookmark(memberId, storeId, 'TOWN_STROLL');
        } else {
          // 즐겨찾기에 등록되지 않은 경우, 즐겨찾기 추가
          townStroll.state.townStrollMapResult.townStrollMap[index].isbookmark =
              true;
          await OpenApis().bookmarkStore(memberId, storeId, 'TOWN_STROLL');
        }
      }
    } catch (e) {
      print("즐겨찾기 상태 변경 중 오류 발생: $e");
    } finally {
      setState(() {
        isBookmarkLoading = false; // 즐겨찾기 로딩 상태 종료
        bottomsheet = bottomSheet(storeId, memberId);
      });
    }
  }

  void IsBookmark(List<TownStroll> townStrollList) async {
    final idjwt = BlocProvider.of<IdJwtCubit>(context);
    String memberId = idjwt.state.idJwt.id!;

    final townStroll = BlocProvider.of<TownStrollMapCubit>(context);
    try {
      for (int i = 0; i < townStrollList.length; i++) {
        var bookmarkId = await OpenApis()
            .isBookmark(memberId, 'TOWN_STROLL', townStrollList[i].id);
        if (bookmarkId != 0) {
          townStroll.state.townStrollMapResult.townStrollMap[i].isbookmark =
              true;
        } else {
          townStroll.state.townStrollMapResult.townStrollMap[i].isbookmark =
              false;
        }
      }
    } catch (e) {
      print("즐겨찾기 상태 변경 중 오류 발생: $e");
    }
  }

  Widget bottomSheet(int storeId, String memberId) {
    return BlocBuilder<TownStrollMapCubit, TownStrollMapCubitState>(
        builder: (context, state) {
      int index = state.townStrollMapResult.townStrollMap
          .indexWhere((element) => element.id == storeId);
      if (index != -1) {
        return Sheet(
          initialExtent: 180,
          maxExtent: 180,
          minExtent: 60,
          child: Container(
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
                    Text(state.townStrollMapResult.townStrollMap[index].name),
                    IconButton(
                      icon: Icon(
                        Icons.star,
                        color: state.townStrollMapResult.townStrollMap[index]
                                .isbookmark
                            ? Colors.yellow
                            : Colors.grey,
                      ),
                      onPressed: () {
                        toggleBookmark(memberId,
                            state.townStrollMapResult.townStrollMap[index].id);
                      },
                    ),
                  ],
                ),
                Text(
                    '주소: ${state.townStrollMapResult.townStrollMap[index].address}'),
                Text(state
                    .townStrollMapResult.townStrollMap[index].middleCategory),
                Text(state
                    .townStrollMapResult.townStrollMap[index].smallCategory),
              ],
            ),
          ),
        );
      } else {
        return Container();
      }
    });
  }

  void MarkUp(List<TownStroll> storeList, BuildContext context) async {
    final bloc = BlocProvider.of<IdJwtCubit>(context);
    String memberId = bloc.state.idJwt.id!;
    for (var store in storeList) {
      var marker = NMarker(
        id: store.id.toString(),
        position: NLatLng(store.latitude, store.longitude),
        size: Size(20, 30),
        // 여기에 마커에 추가할 수 있는 다른 속성들을 추가할 수 있습니다.
      );

      marker.setOnTapListener((NMarker marker) {
        setState(() {
          bottomsheet = bottomSheet(store.id, memberId);
        });
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
    return BlocConsumer<TownStrollMapCubit, TownStrollMapCubitState>(
      listener: (context, state) {
        if (state is LoadedTownStrollMapCubitState && mapController != null) {
          mapController!.clearOverlays();
          IsBookmark(state.townStrollMapResult.townStrollMap);
          MarkUp(state.townStrollMapResult.townStrollMap, context);
        }
      },
      builder: (context, state) {
        void _onMapCreated(NaverMapController controller) async {
          mapController = controller;
          if (state is LoadedTownStrollMapCubitState) {
            IsBookmark(state.townStrollMapResult.townStrollMap);
            MarkUp(state.townStrollMapResult.townStrollMap, context);
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
              if (state is ErrorTownStrollMapCubitState)
                Center(
                  child: Text(state.errorMessage),
                )
              else if (state is FirstLoadingTownStrollMapCubitState)
                Center(
                  child: CircularProgressIndicator(),
                )
              else if (state is LoadedTownStrollMapCubitState ||
                  state is LoadingTownStrollMapCubitState)
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
              Positioned(
                top: 50,
                right: 10,
                child: FloatingActionButton(
                  onPressed: () async {
                    final NLatLng centerCoordinate = await _CenterCoordinate();

                    loadMapDataAll(centerCoordinate);
                  },
                  child: Icon(
                    Icons.autorenew,
                    color: Colors.white,
                  ),
                  backgroundColor: GREEN_COLOR,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28.0)),
                ),
              ),
              if (myLocation != null && bottomsheet != null) bottomsheet!,
              if (myLocation == null)
                const Center(child: CircularProgressIndicator()),
            ],
          ),
          bottomNavigationBar: AppNavigationBar(),
        );
      },
    );
  }
}
