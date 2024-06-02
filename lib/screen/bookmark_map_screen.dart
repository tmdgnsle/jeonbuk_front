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
  String? memberId;

  @override
  void dispose() {
    mapController!.dispose();
    super.dispose();
  }

  void firstLoadMapData() async {
    final bloc = BlocProvider.of<IdJwtCubit>(context);
    memberId = bloc.state.idJwt.id!;
    try {
      Position position = await determinePosition();
      setState(() {
        myLocation = NLatLng(position.latitude, position.longitude);
      });
      context.read<BookmarkMapCubit>().firstLoadBookmarkMap(memberId!);
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
    setState(() {
      isBookmarkLoading = true; // 즐겨찾기 로딩 상태 시작
    });

    final bookmarkCubit = BlocProvider.of<BookmarkMapCubit>(context);

    try {
      switch (category) {
        case 'DISCOUNT_STORE':
          int index = bookmarkCubit.state.bookmarkMapResult.discountStoreMap
              .indexWhere((element) => element.id == storeId);

          if (index != -1) {
            if (bookmarkCubit
                .state.bookmarkMapResult.discountStoreMap[index].isbookmark) {
              // 이미 즐겨찾기에 등록된 경우, 즐겨찾기 삭제f
              bookmarkCubit.state.bookmarkMapResult.discountStoreMap[index]
                  .isbookmark = false;
              await OpenApis().deleteBookmark(memberId, storeId, category);
            } else {
              // 즐겨찾기에 등록되지 않은 경우, 즐겨찾기 추가

              bookmarkCubit.state.bookmarkMapResult.discountStoreMap[index]
                  .isbookmark = true;
              await OpenApis().bookmarkStore(memberId, storeId, category);
            }
          }
          break;
        case 'RESTAURANT':
          int index = bookmarkCubit.state.bookmarkMapResult.restaurantMap
              .indexWhere((element) => element.id == storeId);

          if (index != -1) {
            if (bookmarkCubit
                .state.bookmarkMapResult.restaurantMap[index].isbookmark) {
              // 이미 즐겨찾기에 등록된 경우, 즐겨찾기 삭제
              bookmarkCubit.state.bookmarkMapResult.restaurantMap[index]
                  .isbookmark = false;
              await OpenApis().deleteBookmark(memberId, storeId, category);
            } else {
              // 즐겨찾기에 등록되지 않은 경우, 즐겨찾기 추가
              bookmarkCubit.state.bookmarkMapResult.restaurantMap[index]
                  .isbookmark = true;
              await OpenApis().bookmarkStore(memberId, storeId, category);
            }
          }
          break;
        case 'FESTIVAL':
          int index = bookmarkCubit.state.bookmarkMapResult.festivalMap
              .indexWhere((element) => element.id == storeId);

          if (index != -1) {
            if (bookmarkCubit
                .state.bookmarkMapResult.festivalMap[index].isbookmark) {
              bookmarkCubit.state.bookmarkMapResult.festivalMap[index]
                  .isbookmark = false;
              await OpenApis().deleteBookmark(memberId, storeId, category);
            } else {
              bookmarkCubit
                  .state.bookmarkMapResult.festivalMap[index].isbookmark = true;
              await OpenApis().bookmarkStore(memberId, storeId, category);
            }
          }
          break;
        case 'TOWN_STROLL':
          int index = bookmarkCubit.state.bookmarkMapResult.townStrollMap
              .indexWhere((element) => element.id == storeId);

          if (index != -1) {
            if (bookmarkCubit
                .state.bookmarkMapResult.townStrollMap[index].isbookmark) {
              bookmarkCubit.state.bookmarkMapResult.townStrollMap[index]
                  .isbookmark = false;
              await OpenApis().deleteBookmark(memberId, storeId, category);
            } else {
              bookmarkCubit.state.bookmarkMapResult.townStrollMap[index]
                  .isbookmark = true;
              await OpenApis().bookmarkStore(memberId, storeId, category);
            }
          }
          break;
      }
    } catch (e) {
      print("즐겨찾기 상태 변경 중 오류 발생: $e");
    } finally {
      setState(() {
        isBookmarkLoading = false; // 즐겨찾기 로딩 상태 종료
        switch (category) {
          case 'DISCOUNT_STORE':
            bottomsheet = bottomSheetD(storeId, memberId);
            break;
          case 'RESTAURANT':
            bottomsheet = bottomSheetR(storeId, memberId);
            break;
          case 'FESTIVAL':
            bottomsheet = bottomSheetF(storeId, memberId);
            break;
          case 'TOWN_STROLL':
            bottomsheet = bottomSheetT(storeId, memberId);
            break;
        }
      });
    }
  }

  void IsBookmark(List<dynamic> storeList, String category) async {
    final idjwt = BlocProvider.of<IdJwtCubit>(context);
    String memberId = idjwt.state.idJwt.id!;

    final bookmarkcubit = BlocProvider.of<BookmarkMapCubit>(context);

    try {
      switch (category) {
        case 'DISCOUNT_STORE':
          for (int i = 0; i < storeList.length; i++) {
            var bookmarkId = await OpenApis()
                .isBookmark(memberId, category, storeList[i].id);
            if (bookmarkId != 0) {
              bookmarkcubit.state.bookmarkMapResult.discountStoreMap[i]
                  .isbookmark = true;
            } else {
              bookmarkcubit.state.bookmarkMapResult.discountStoreMap[i]
                  .isbookmark = false;
            }
          }
          break;
        case 'RESTAURANT':
          for (int i = 0; i < storeList.length; i++) {
            var bookmarkId = await OpenApis()
                .isBookmark(memberId, category, storeList[i].id);
            if (bookmarkId != 0) {
              bookmarkcubit
                  .state.bookmarkMapResult.restaurantMap[i].isbookmark = true;
            } else {
              bookmarkcubit
                  .state.bookmarkMapResult.restaurantMap[i].isbookmark = false;
            }
          }
          break;
        case 'FESTIVAL':
          for (int i = 0; i < storeList.length; i++) {
            var bookmarkId = await OpenApis()
                .isBookmark(memberId, category, storeList[i].id);
            if (bookmarkId != 0) {
              bookmarkcubit.state.bookmarkMapResult.festivalMap[i].isbookmark =
                  true;
            } else {
              bookmarkcubit.state.bookmarkMapResult.festivalMap[i].isbookmark =
                  false;
            }
          }
          break;
        case 'TOWN_STROLL':
          for (int i = 0; i < storeList.length; i++) {
            var bookmarkId = await OpenApis()
                .isBookmark(memberId, category, storeList[i].id);
            if (bookmarkId != 0) {
              bookmarkcubit
                  .state.bookmarkMapResult.townStrollMap[i].isbookmark = true;
            } else {
              bookmarkcubit
                  .state.bookmarkMapResult.townStrollMap[i].isbookmark = false;
            }
          }
          break;
      }
    } catch (e) {
      print("즐겨찾기 상태 변경 중 오류 발생: $e");
    }
  }

  Widget bottomSheetD(int storeId, String memberId) {
    return BlocBuilder<BookmarkMapCubit, BookmarkMapCubitState>(
        builder: (context, state) {
      int index = state.bookmarkMapResult.discountStoreMap
          .indexWhere((element) => element.id == storeId);
      if (index != -1) {
        String modifiedEtc = state.bookmarkMapResult.discountStoreMap[index].etc
            .toString()
            .replaceAll('<', '\n');
        return Sheet(
          initialExtent: 180,
          maxExtent: 250,
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
                    Text(state
                        .bookmarkMapResult.discountStoreMap[index].storeName),
                    IconButton(
                      icon: Icon(
                        Icons.star,
                        color: state.bookmarkMapResult.discountStoreMap[index]
                                .isbookmark
                            ? Colors.yellow
                            : Colors.grey,
                      ),
                      onPressed: () {
                        toggleBookmark(
                            memberId,
                            state.bookmarkMapResult.discountStoreMap[index].id,
                            'DISCOUNT_STORE');
                      },
                    ),
                  ],
                ),
                Text(
                    '${state.bookmarkMapResult.discountStoreMap[index].storeType}'),
                Text(
                    '주소: ${state.bookmarkMapResult.discountStoreMap[index].roadAddress}'),
                Text(modifiedEtc),
              ],
            ),
          ),
        );
      } else {
        return Container();
      }
    });
  }

  Widget bottomSheetR(int storeId, String memberId) {
    return BlocBuilder<BookmarkMapCubit, BookmarkMapCubitState>(
        builder: (context, state) {
      int index = state.bookmarkMapResult.restaurantMap
          .indexWhere((element) => element.id == storeId);
      if (index != -1) {
        String modifiedEtc = state.bookmarkMapResult.restaurantMap[index].etc
            .toString()
            .replaceAll('<', '\n');
        return Sheet(
          initialExtent: 180,
          maxExtent: 250,
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
                    Text(
                        state.bookmarkMapResult.restaurantMap[index].storeName),
                    IconButton(
                      icon: Icon(
                        Icons.star,
                        color: state.bookmarkMapResult.restaurantMap[index]
                                .isbookmark
                            ? Colors.yellow
                            : Colors.grey,
                      ),
                      onPressed: () {
                        toggleBookmark(
                            memberId,
                            state.bookmarkMapResult.restaurantMap[index].id,
                            'RESTAURANT');
                      },
                    ),
                  ],
                ),
                Text(
                    '주소: ${state.bookmarkMapResult.restaurantMap[index].roadAddress}'),
                Text(modifiedEtc),
              ],
            ),
          ),
        );
      } else {
        return Container();
      }
    });
  }

  Widget bottomSheetF(int storeId, String memberId) {
    return BlocBuilder<BookmarkMapCubit, BookmarkMapCubitState>(
        builder: (context, state) {
      int index = state.bookmarkMapResult.festivalMap
          .indexWhere((element) => element.id == storeId);
      if (index != -1) {
        return Sheet(
          initialExtent: 180,
          maxExtent: 250,
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
                    Text(state.bookmarkMapResult.festivalMap[index].title),
                    IconButton(
                      icon: Icon(
                        Icons.star,
                        color: state
                                .bookmarkMapResult.festivalMap[index].isbookmark
                            ? Colors.yellow
                            : Colors.grey,
                      ),
                      onPressed: () {
                        toggleBookmark(
                            memberId,
                            state.bookmarkMapResult.festivalMap[index].id,
                            'FESTIVAL');
                      },
                    ),
                  ],
                ),
                Text(
                    '주소: ${state.bookmarkMapResult.festivalMap[index].address}'),
              ],
            ),
          ),
        );
      } else {
        return Container();
      }
    });
  }

  Widget bottomSheetT(int storeId, String memberId) {
    return BlocBuilder<BookmarkMapCubit, BookmarkMapCubitState>(
        builder: (context, state) {
      int index = state.bookmarkMapResult.townStrollMap
          .indexWhere((element) => element.id == storeId);
      if (index != -1) {
        return Sheet(
          initialExtent: 180,
          maxExtent: 250,
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
                    Text(state.bookmarkMapResult.townStrollMap[index].name),
                    IconButton(
                      icon: Icon(
                        Icons.star,
                        color: state.bookmarkMapResult.townStrollMap[index]
                                .isbookmark
                            ? Colors.yellow
                            : Colors.grey,
                      ),
                      onPressed: () {
                        toggleBookmark(
                            memberId,
                            state.bookmarkMapResult.townStrollMap[index].id,
                            'TOWN_STROLL');
                      },
                    ),
                  ],
                ),
                Text(
                    '주소: ${state.bookmarkMapResult.townStrollMap[index].address}'),
              ],
            ),
          ),
        );
      } else {
        return Container();
      }
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
                loadMapDataFilter(filterValue!);
              },
              child: Container(
                width: filterWidth,
                decoration: BoxDecoration(
                  color: bookmarkFilterColor[index],
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

  void MarkUp(BookmarkMap bookmarkMap, BuildContext context) async {
    var markerIcon;

    if (bookmarkMap.discountStoreMap != null &&
        bookmarkMap.discountStoreMap!.isNotEmpty) {
      for (var store in bookmarkMap.discountStoreMap) {
        markerIcon = await NOverlayImage.fromWidget(
            widget: Icon(
              bookmarkFilterIcon[1],
              color: bookmarkFilterColor[2],
            ),
            size: const Size(24, 24),
            context: context);

        var marker = NMarker(
          id: 'DISCOUNT_STORE${store.id.toString()}',
          position: NLatLng(store.latitude, store.longitude),
          size: const Size(24, 24),
          icon: markerIcon,
          // 여기에 마커에 추가할 수 있는 다른 속성들을 추가할 수 있습니다.
        );

        marker.setOnTapListener((NMarker marker) {
          setState(() {
            bottomsheet = bottomSheetD(store.id, memberId!);
          });
        });

        mapController!.addOverlay(marker);
      }
    }
    if (bookmarkMap.restaurantMap != null &&
        bookmarkMap.restaurantMap!.isNotEmpty) {
      for (var store in bookmarkMap.restaurantMap!) {
        markerIcon = await NOverlayImage.fromWidget(
            widget: Icon(
              bookmarkFilterIcon[0],
              color: bookmarkFilterColor[1],
            ),
            size: const Size(24, 24),
            context: context);

        var marker = NMarker(
          id: 'RESTAURANT${store.id.toString()}',
          position: NLatLng(store.latitude, store.longitude),
          size: const Size(24, 24),
          icon: markerIcon,
          // 여기에 마커에 추가할 수 있는 다른 속성들을 추가할 수 있습니다.
        );

        marker.setOnTapListener((NMarker marker) {
          setState(() {
            bottomsheet = bottomSheetR(store.id, memberId!);
          });
        });

        mapController!.addOverlay(marker);
      }
    }
    if (bookmarkMap.festivalMap != null &&
        bookmarkMap.festivalMap!.isNotEmpty) {
      for (var store in bookmarkMap.festivalMap!) {
        markerIcon = await NOverlayImage.fromWidget(
            widget: Icon(
              bookmarkFilterIcon[2],
              color: bookmarkFilterColor[3],
            ),
            size: const Size(24, 24),
            context: context);

        var marker = NMarker(
          id: 'FESTIVAL${store.id.toString()}',
          position: NLatLng(store.latitude, store.longitude),
          size: const Size(24, 24),
          icon: markerIcon,
          // 여기에 마커에 추가할 수 있는 다른 속성들을 추가할 수 있습니다.
        );

        marker.setOnTapListener((NMarker marker) {
          setState(() {
            bottomsheet = bottomSheetF(store.id, memberId!);
          });
        });

        mapController!.addOverlay(marker);
      }
    }
    if (bookmarkMap.townStrollMap != null &&
        bookmarkMap.townStrollMap!.isNotEmpty) {
      for (var store in bookmarkMap.townStrollMap!) {
        markerIcon = await NOverlayImage.fromWidget(
            widget: Icon(
              bookmarkFilterIcon[3],
              color: bookmarkFilterColor[4],
            ),
            size: const Size(24, 24),
            context: context);

        var marker = NMarker(
          id: 'TOWN_STROLL${store.id.toString()}',
          position: NLatLng(store.latitude, store.longitude),
          size: const Size(24, 24),
          icon: markerIcon,
          // 여기에 마커에 추가할 수 있는 다른 속성들을 추가할 수 있습니다.
        );

        marker.setOnTapListener((NMarker marker) {
          setState(() {
            bottomsheet = bottomSheetT(store.id, memberId!);
          });
        });

        mapController!.addOverlay(marker);
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
        if (state is LoadedBookmarkMapCubitState && mapController != null) {
          mapController!.clearOverlays();
          IsBookmark(
              state.bookmarkMapResult.discountStoreMap, 'DISCOUNT_STORE');
          IsBookmark(state.bookmarkMapResult.restaurantMap, 'RESTAURANT');
          IsBookmark(state.bookmarkMapResult.festivalMap, 'FESTIVAL');
          IsBookmark(state.bookmarkMapResult.townStrollMap, 'TOWN_STROLL');
          MarkUp(state.bookmarkMapResult, context);
        }
      },
      builder: (context, state) {
        void _onMapCreated(NaverMapController controller) async {
          mapController = controller;
          if (state is LoadedBookmarkMapCubitState) {
            IsBookmark(
                state.bookmarkMapResult.discountStoreMap, 'DISCOUNT_STORE');
            IsBookmark(state.bookmarkMapResult.restaurantMap, 'RESTAURANT');
            IsBookmark(state.bookmarkMapResult.festivalMap, 'FESTIVAL');
            IsBookmark(state.bookmarkMapResult.townStrollMap, 'TOWN_STROLL');
            MarkUp(state.bookmarkMapResult, context);
          }
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              '나만의 지도',
              textAlign: TextAlign.center,
            ),
          ),
          body: Stack(
            children: [
              if (state is ErrorBookmarkMapCubitState)
                Center(
                  child: Text(state.errorMessage),
                )
              else if (state is FirstLoadingBookmarkMapCubitState)
                const Center(
                  child: CircularProgressIndicator(),
                )
              else if (state is LoadedBookmarkMapCubitState ||
                  state is LoadingBookmarkMapCubitState)
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
                    loadMapDataFilter('ALL');
                  },
                  child: const Icon(
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
        );
      },
    );
  }
}
