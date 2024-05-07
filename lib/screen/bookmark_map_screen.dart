import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jeonbuk_front/api/openapis.dart';
import 'package:jeonbuk_front/components/app_navigation_bar.dart';
import 'package:jeonbuk_front/const/color.dart';
import 'package:jeonbuk_front/const/filter.dart';
import 'package:jeonbuk_front/cubit/bookmark_map_cubit.dart';
import 'package:jeonbuk_front/cubit/id_jwt_cubit.dart';
import 'package:jeonbuk_front/model/bookmark_map.dart';
import 'package:jeonbuk_front/model/discount_store.dart';
import 'package:jeonbuk_front/model/restaurant.dart';
import 'package:sheet/sheet.dart';

class BookmarkMapScreen extends StatefulWidget {
  @override
  State<BookmarkMapScreen> createState() => _MyAppState();
}

class _MyAppState extends State<BookmarkMapScreen> {
  NaverMapController? mapController;
  Widget? bottomsheet;

  NLatLng? myLocation;
  bool isBookmarkLoading = false;
  Map<int, bool> bookmarkStatus = {};
  List<bool> filterTap = [false, false, false, false];
  String? memberId;

  void firstLoadMapData() async {
    final bloc = BlocProvider.of<IdJwtCubit>(context);
    memberId = bloc.state.idJwt.id!;
    try {
      Position position = await determinePosition();
      setState(() {
        myLocation = NLatLng(position.latitude, position.longitude);
      });
      context.read<BookmarkMapCubit>().loadBookmarkMap(memberId!, 'ALL');
    } catch (e) {
      print('에러: ${e.toString()}');
      // 오류 처리, 예: 사용자에게 오류 메시지 표시
    }
  }

  void loadMapDataFilter(String filter) async {
    try {
      context
          .read<BookmarkMapCubit>()
          .loadBookmarkMap(memberId!, filter.toString());
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

  Future<void> toggleBookmark(
      String memberId, int storeId, String category) async {
    int? bookmarkId;
    setState(() {
      isBookmarkLoading = true; // 즐겨찾기 로딩 상태 시작
    });

    try {
      bookmarkId = await OpenApis().isBookmark(memberId, category, storeId);
      if (bookmarkId != 0) {
        // 이미 즐겨찾기에 등록된 경우, 즐겨찾기 삭제f
        await OpenApis().deleteBookmark(memberId, storeId, category);
        // setState(() {
        //   bookmarkStatus[storeId] = false;
        // });
      } else {
        // 즐겨찾기에 등록되지 않은 경우, 즐겨찾기 추가
        bookmarkId =
            await OpenApis().bookmarkStore(memberId, storeId, category);
        // setState(() {
        //   bookmarkStatus[storeId] = true;
        // });
      }
    } catch (e) {
      print("즐겨찾기 상태 변경 중 오류 발생: $e");
    } finally {
      setState(() {
        bookmarkStatus[storeId] = bookmarkId != null && bookmarkId != 0;
        isBookmarkLoading = false; // 즐겨찾기 로딩 상태 종료
      });
    }
  }

  Widget bottomSheetD(DiscountStore store, String memberId) {
    String modifiedEtc = store.etc.toString().replaceAll('<', '\n');
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
                Text(store.storeName),
                IconButton(
                  icon: Icon(
                    Icons.star,
                    color:
                        bookmarkStatus[store.id]! ? Colors.yellow : Colors.grey,
                  ),
                  onPressed: () {
                    toggleBookmark(memberId, store.id, 'DISCOUNT_STORE');
                  },
                ),
              ],
            ),
            Text('${store.storeType}'),
            Text('주소: ${store.roadAddress}'),
            Text(modifiedEtc),
          ],
        ),
      ),
    );
  }

  Widget bottomSheetR(Restaurant store, String memberId) {
    String modifiedEtc = store.etc.toString().replaceAll('<', '\n');
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
                Text(store.storeName),
                IconButton(
                  icon: Icon(
                    Icons.star,
                    color: bookmarkStatus[store.id] ?? false
                        ? Colors.yellow
                        : Colors.grey,
                  ),
                  onPressed: () {
                    toggleBookmark(memberId, store.id, 'RESTAURANT');
                  },
                ),
              ],
            ),
            Text('주소: ${store.roadAddress}'),
            Text(modifiedEtc),
          ],
        ),
      ),
    );
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
        itemCount: bookmarkFilter.keys.length, // Map의 키 개수를 itemCount로 사용
        itemBuilder: (context, index) {
          final filterKeys = bookmarkFilter.keys.toList(); // Map의 키를 리스트로 변환
          final filterName = filterKeys[index]; // 현재 인덱스에 해당하는 키
          final filterValue = bookmarkFilter[filterName]; // 키를 사용하여 Map에서 값을 얻음
          final filterWidth = MediaQuery.of(context).size.width / 5;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: InkWell(
              onTap: () {
                setState(() {
                  for(int i = 0; i < filterTap.length; i++){
                    if (i == index){
                      filterTap[i] = true;
                    } else {
                      filterTap[i] = false;
                    }
                  }
                });


                loadMapDataFilter(filterValue!);

              },
              child: Container(
                width: filterWidth,
                decoration: BoxDecoration(
                  color: filterTap[index] ? GREEN_COLOR : BLUE_COLOR, // 이 예제에서는 색상을 고정값으로 설정
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

  void MarkUp(BookmarkMap bookmarkMap, BuildContext context) async {


    if (bookmarkMap.discountStoreMap != null &&
        bookmarkMap.discountStoreMap!.isNotEmpty) {
      for (var store in bookmarkMap.discountStoreMap!) {
        var marker = NMarker(
          id: 'DISCOUNT_STORE${store.id.toString()}',
          position: NLatLng(store.latitude, store.longitude),
          size: Size(20, 30),
          // 여기에 마커에 추가할 수 있는 다른 속성들을 추가할 수 있습니다.
        );

        marker.setOnTapListener((NMarker marker) {
          setState(() {
            bookmarkStatus[store.id] = true;
            bottomsheet = bottomSheetD(store, memberId!);
          });
        });

        mapController!.addOverlay(marker);
        print('할인매장 마크업');
      }
    }
    if (bookmarkMap.restaurantMap != null &&
        bookmarkMap.restaurantMap!.isNotEmpty) {
      for (var store in bookmarkMap.restaurantMap!) {
        var marker = NMarker(
          id: 'RESTAURANT${store.id.toString()}',
          position: NLatLng(store.latitude, store.longitude),
          size: Size(20, 30),
          // 여기에 마커에 추가할 수 있는 다른 속성들을 추가할 수 있습니다.
        );

        marker.setOnTapListener((NMarker marker) {
          setState(() {
            bookmarkStatus[store.id] = true;
            bottomsheet = bottomSheetR(store, memberId!);
          });
        });

        mapController!.addOverlay(marker);
        print('식당 마크업');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    firstLoadMapData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookmarkMapCubit, BookmarkMapCubitState>(
      listener: (context, state) {
        if (state is LoadedBookmarkMapCubitState &&
            mapController != null) {
          mapController!.clearOverlays();
          MarkUp(state.bookmarkMapResult, context);
        }
      },
      builder: (context, state) {
        void _onMapCreated(NaverMapController controller) async {
          mapController = controller;
          if (state is LoadedBookmarkMapCubitState) {
            MarkUp(state.bookmarkMapResult, context);
            print('마크업 완료');
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
              firstLoadMapData();
              setState(() {
                for(int i = 0; i < filterTap.length; i++){
                  filterTap[i] = false;
                }
              });
            },
            child: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            backgroundColor: GREEN_COLOR,
          ),
          bottomNavigationBar: AppNavigationBar(currentIndex: 2,),
        );
      },
    );
  }
}
