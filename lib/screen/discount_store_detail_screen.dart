import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:jeonbuk_front/api/openapis.dart';
import 'package:jeonbuk_front/components/app_navigation_bar.dart';
import 'package:jeonbuk_front/const/filter.dart';
import 'package:jeonbuk_front/cubit/discount_store_map_cubit.dart';
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
  Widget? bottomsheet;

  void IsBookmark(DiscountStore discountStore) async {
    final idjwt = BlocProvider.of<IdJwtCubit>(context);
    setState(() {
      memberId = idjwt.state.idJwt.id!;
    });

    final discount = BlocProvider.of<DiscountStoreMapCubit>(context);

    discount.state.discountStoreMapResult.discountStoreMap = [discountStore];
    try {
      var bookmarkId = await OpenApis()
          .isBookmark(memberId, 'DISCOUNT_STORE', discountStore.id);
      if (bookmarkId != 0) {
        discount.state.discountStoreMapResult.discountStoreMap[0].isbookmark =
            true;
      } else {
        discount.state.discountStoreMapResult.discountStoreMap[0].isbookmark =
            false;
      }
    } catch (e) {
      print('즐겨찾기 상태 변경 중 오류 발생: $e');
    }
  }

  @override
  void initState() {
    IsBookmark(widget.discountStore);
    super.initState();
  }

  Widget bottomSheet(int storeId, String memberId) {
    return BlocBuilder<DiscountStoreMapCubit, DiscountStoreMapCubitState>(
        builder: (context, state) {
      String modifiedEtc = state.discountStoreMapResult.discountStoreMap[0].etc
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
                      .discountStoreMapResult.discountStoreMap[0].storeName),
                  IconButton(
                    icon: Icon(
                      Icons.star,
                      color: state.discountStoreMapResult.discountStoreMap[0]
                              .isbookmark
                          ? Colors.yellow
                          : Colors.grey,
                    ),
                    onPressed: () {
                      toggleBookmark(memberId,
                          state.discountStoreMapResult.discountStoreMap[0].id);
                    },
                  ),
                ],
              ),
              Text(
                  '${state.discountStoreMapResult.discountStoreMap[0].storeType}'),
              Text(
                  '주소: ${state.discountStoreMapResult.discountStoreMap[0].roadAddress}'),
              Text(modifiedEtc),
            ],
          ),
        ),
      );
    });
  }

  void toggleBookmark(String memberId, int storeId) async {
    setState(() {
      isBookmarkLoading = true; // 즐겨찾기 로딩 상태 시작
    });

    final discount = BlocProvider.of<DiscountStoreMapCubit>(context);

    try {
      if (discount
          .state.discountStoreMapResult.discountStoreMap[0].isbookmark) {
        // 이미 즐겨찾기에 등록된 경우, 즐겨찾기 삭제f
        discount.state.discountStoreMapResult.discountStoreMap[0].isbookmark =
            false;
        await OpenApis().deleteBookmark(memberId, storeId, 'DISCOUNT_STORE');
      } else {
        // 즐겨찾기에 등록되지 않은 경우, 즐겨찾기 추가

        discount.state.discountStoreMapResult.discountStoreMap[0].isbookmark =
            true;
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

  @override
  Widget build(BuildContext context) {
    void _onMapCreated(NaverMapController controller) async {
      var markerIcon = await NOverlayImage.fromWidget(
          widget: Icon(
            bookmarkFilterIcon[1],
            color: bookmarkFilterColor[2],
          ),
          size: const Size(24, 24),
          context: context);

      mapController = controller;
      var marker = NMarker(
        id: widget.discountStore.id.toString(),
        position: NLatLng(
            widget.discountStore.latitude, widget.discountStore.longitude),
        icon: markerIcon,

        // 여기에 마커에 추가할 수 있는 다른 속성들을 추가할 수 있습니다.
      );
      marker.setOnTapListener((NMarker marker) {
        setState(() {
          bottomsheet = bottomSheet(widget.discountStore.id, memberId);
        });
      });
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
          bottomsheet ?? Container(),
        ],
      ),
      bottomNavigationBar: AppNavigationBar(currentIndex: 0,),
    );
  }
}
