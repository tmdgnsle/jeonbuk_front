import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:jeonbuk_front/api/openapis.dart';
import 'package:jeonbuk_front/components/app_navigation_bar.dart';
import 'package:jeonbuk_front/cubit/id_jwt_cubit.dart';
import 'package:jeonbuk_front/model/discount_store.dart';
import 'package:sheet/sheet.dart';

class DiscountStoreDetailScreen extends StatefulWidget {
  final DiscountStore discountStore;

  const DiscountStoreDetailScreen({required this.discountStore, super.key});

  @override
  State<DiscountStoreDetailScreen> createState() =>
      _DiscountStoreDetailScreenState();
}

class _DiscountStoreDetailScreenState extends State<DiscountStoreDetailScreen> {
  NaverMapController? mapController;
  int? bookmarkId;
  bool isBookmarkLoading = false;
  late String memberId;

  findBookmarkId(int storeId) async {
    final bloc = BlocProvider.of<IdJwtCubit>(context);
    memberId = bloc.state.idJwt.id!;
    bookmarkId =
        await OpenApis().isBookmark(memberId, 'DISCOUNT_STORE', storeId);
  }

  @override
  void initState() {
    findBookmarkId(widget.discountStore.id);
    super.initState();
  }

  Widget bottomSheet(DiscountStore store, String memberId) {
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
                    color: bookmarkId != null && bookmarkId != 0 ? Colors.yellow : Colors.grey,
                  ),
                  onPressed: () {
                    toggleBookmark(memberId, store.id);
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

  Future<void> toggleBookmark(String memberId, int storeId) async {
    setState(() {
      isBookmarkLoading = true; // 즐겨찾기 로딩 상태 시작
    });

    try {
      if (bookmarkId != 0) {
        // 이미 즐겨찾기에 등록된 경우, 즐겨찾기 삭제
        await OpenApis().deleteBookmark(bookmarkId!);
        setState(() {
          bookmarkId = 0;
        });
      } else {
        // 즐겨찾기에 등록되지 않은 경우, 즐겨찾기 추가
        bookmarkId =
            await OpenApis().bookmarkStore(memberId, storeId, 'DISCOUNT_STORE');
        setState(() {});
      }
    } catch (e) {
      print("즐겨찾기 상태 변경 중 오류 발생: $e");
    } finally {
      setState(() {
        isBookmarkLoading = false; // 즐겨찾기 로딩 상태 종료
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    void _onMapCreated(NaverMapController controller) async {
      mapController = controller;
      var marker = NMarker(
        id: widget.discountStore.id.toString(),
        position: NLatLng(
            widget.discountStore.latitude, widget.discountStore.longitude),
        iconTintColor: Colors.green,
        size: Size(20, 30),
        // 여기에 마커에 추가할 수 있는 다른 속성들을 추가할 수 있습니다.
      );
      mapController!.addOverlay(marker);
    }

    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          NaverMap(
            options: NaverMapViewOptions(
              initialCameraPosition: NCameraPosition(
                  target: NLatLng(widget.discountStore.latitude,
                      widget.discountStore.longitude),
                  zoom: 18),
              locationButtonEnable: true,
            ),
            onMapReady: _onMapCreated,
          ),
          bottomSheet(widget.discountStore, memberId),
        ],
      ),
      bottomNavigationBar: AppNavigationBar(),
    );
  }
}
