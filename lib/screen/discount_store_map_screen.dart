import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jeonbuk_front/api/openapis.dart';
import 'package:jeonbuk_front/components/app_navigation_bar.dart';
import 'package:jeonbuk_front/const/color.dart';
import 'package:jeonbuk_front/const/filter.dart';
import 'package:jeonbuk_front/cubit/discount_store_map_cubit.dart';
import 'package:jeonbuk_front/cubit/id_jwt_cubit.dart';
import 'package:jeonbuk_front/model/discount_store.dart';
import 'package:sheet/sheet.dart';

class DiscountStoreMapScreen extends StatefulWidget {
  @override
  State<DiscountStoreMapScreen> createState() => _MyAppState();
}

class _MyAppState extends State<DiscountStoreMapScreen> {
  NaverMapController? mapController;
  Widget? bottomsheet;

  NLatLng? myLocation;
  bool isBookmarkLoading = false;
  Map<int, bool> bookmarkStatus = {};

  void firstLoadMapData() async {
    try {
      Position position = await determinePosition();
      setState(() {
        myLocation = NLatLng(position.latitude, position.longitude);
      });

      final radius = 50.0;
      // width * meterPerDp;
      // 위치 정보와 반지름을 Cubit에 전달
      context.read<DiscountStoreMapCubit>().loadDiscountStoreMapFilter(
          position.latitude, position.longitude, radius, 'all');
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
      context.read<DiscountStoreMapCubit>().loadDiscountStoreMapFilter(
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
      context.read<DiscountStoreMapCubit>().loadDiscountStoreMapFilter(
          centerLocation.latitude,
          centerLocation.longitude,
          radius,
          filter.toString());
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

    final discount = BlocProvider.of<DiscountStoreMapCubit>(context);
    int index = discount.state.discountStoreMapResult.discountStoreMap
        .indexWhere((element) => element.id == storeId);

    try {
      if (discount
          .state.discountStoreMapResult.discountStoreMap[index].isbookmark) {
        // 이미 즐겨찾기에 등록된 경우, 즐겨찾기 삭제f
        discount.state.discountStoreMapResult.discountStoreMap[index]
            .isbookmark = false;
        await OpenApis().deleteBookmark(memberId, storeId, 'DISCOUNT_STORE');
      } else {
        // 즐겨찾기에 등록되지 않은 경우, 즐겨찾기 추가

        discount.state.discountStoreMapResult.discountStoreMap[index]
            .isbookmark = true;
        await OpenApis().bookmarkStore(memberId, storeId, 'DISCOUNT_STORE');
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

  void IsBookmark(List<DiscountStore> discountStoreList) async {
    final idjwt = BlocProvider.of<IdJwtCubit>(context);
    String memberId = idjwt.state.idJwt.id!;

    final discount = BlocProvider.of<DiscountStoreMapCubit>(context);
    try {
      for (int i = 0; i < discountStoreList.length; i++) {
        var bookmarkId = await OpenApis()
            .isBookmark(memberId, 'DISCOUNT_STORE', discountStoreList[i].id);
        if (bookmarkId != 0) {
          discount.state.discountStoreMapResult.discountStoreMap[i].isbookmark =
              true;
        } else {
          discount.state.discountStoreMapResult.discountStoreMap[i].isbookmark =
              false;
        }
      }
    } catch (e) {
      print("즐겨찾기 상태 변경 중 오류 발생: $e");
    }
  }

  Widget bottomSheet(int storeId, String memberId) {
    return BlocBuilder<DiscountStoreMapCubit, DiscountStoreMapCubitState>(
        builder: (context, state) {
      int index = state.discountStoreMapResult.discountStoreMap
          .indexWhere((element) => element.id == storeId);
      String modifiedEtc = state
          .discountStoreMapResult.discountStoreMap[index].etc
          .toString()
          .replaceAll('<', '\n');
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
                  Text(state.discountStoreMapResult.discountStoreMap[index]
                      .storeName),
                  IconButton(
                    icon: Icon(
                      Icons.star,
                      color: state.discountStoreMapResult
                              .discountStoreMap[index].isbookmark
                          ? Colors.yellow
                          : Colors.grey,
                    ),
                    onPressed: () {
                      toggleBookmark(
                          memberId,
                          state.discountStoreMapResult.discountStoreMap[index]
                              .id);
                    },
                  ),
                ],
              ),
              Text(
                  '${state.discountStoreMapResult.discountStoreMap[index].storeType}'),
              Text(
                  '주소: ${state.discountStoreMapResult.discountStoreMap[index].roadAddress}'),
              Text(modifiedEtc),
            ],
          ),
        ),
      );
    });
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
        itemCount: discountStoreFilter.keys.length, // Map의 키 개수를 itemCount로 사용
        itemBuilder: (context, index) {
          final filterKeys =
              discountStoreFilter.keys.toList(); // Map의 키를 리스트로 변환
          final filterName = filterKeys[index]; // 현재 인덱스에 해당하는 키
          final filterValue =
              discountStoreFilter[filterName]; // 키를 사용하여 Map에서 값을 얻음
          final filterWidth = MediaQuery.of(context).size.width / 5;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: InkWell(
              onTap: () async {
                final NLatLng centerLocation = await _CenterCoordinate();
                loadMapDataFilter(centerLocation, filterValue.toString());
              },
              child: Container(
                width: filterWidth,
                decoration: BoxDecoration(
                  color: discountStoreFilterColor[index],
                  // 이 예제에서는 색상을 고정값으로 설정
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
                child: Text(
                  filterName, // Map의 키를 텍스트로 사용
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void MarkUp(List<DiscountStore> storeList, BuildContext context) async {
    final bloc = BlocProvider.of<IdJwtCubit>(context);
    String memberId = bloc.state.idJwt.id!;
    for (var store in storeList) {
      final Color? markerColor;

      switch (store.category.toString()) {
        case 'LEISURE':
          markerColor = discountStoreFilterColor[0];
          break;
        case 'GOODS':
          markerColor = discountStoreFilterColor[1];
          break;
        case 'LIFE':
          markerColor = discountStoreFilterColor[2];
          break;
        case 'EDUCATION':
          markerColor = discountStoreFilterColor[3];
          break;
        case 'SERVICES':
          markerColor = discountStoreFilterColor[4];
          break;

        default:
          markerColor = discountStoreFilterColor[5];
          break;
      }
      print('Store Category: ${store.category}, Marker Color: $markerColor');

      var marker = NMarker(
        id: store.id.toString(),
        position: NLatLng(store.latitude, store.longitude),
        iconTintColor: markerColor,
        size: Size(20, 30),
        // 여기에 마커에 추가할 수 있는 다른 속성들을 추가할 수 있습니다.
      );
      print('marker.iconTintColor: ${marker.iconTintColor}');

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
    return BlocConsumer<DiscountStoreMapCubit, DiscountStoreMapCubitState>(
      listener: (context, state) {
        if (state is LoadedDiscountStoreMapCubitState &&
            mapController != null) {
          mapController!.clearOverlays();
          IsBookmark(state.discountStoreMapResult.discountStoreMap);
          MarkUp(state.discountStoreMapResult.discountStoreMap, context);
        }
      },
      builder: (context, state) {
        void _onMapCreated(NaverMapController controller) async {
          mapController = controller;
          if (state is LoadedDiscountStoreMapCubitState) {
            IsBookmark(state.discountStoreMapResult.discountStoreMap);
            MarkUp(state.discountStoreMapResult.discountStoreMap, context);
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
              if (myLocation != null && bottomsheet != null) bottomsheet!,
              if (myLocation == null)
                const Center(child: CircularProgressIndicator()),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final NLatLng centerCoordinate = await _CenterCoordinate();
              if (state.discountStoreMapResult.category == 'all') {
                loadMapDataAll(centerCoordinate);
              } else {
                loadMapDataFilter(
                    centerCoordinate, state.discountStoreMapResult.category);
              }
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
    );
  }
}
