import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:jeonbuk_front/api/openapis.dart';
import 'package:jeonbuk_front/components/app_navigation_bar.dart';
import 'package:jeonbuk_front/const/filter.dart';
import 'package:jeonbuk_front/cubit/festival_list_cubit.dart';
import 'package:jeonbuk_front/cubit/id_jwt_cubit.dart';
import 'package:jeonbuk_front/model/festival.dart';

class FestivalDetailScreen extends StatefulWidget {
  final Festival festival;

  const FestivalDetailScreen({required this.festival, super.key});

  @override
  State<FestivalDetailScreen> createState() => _FestivalDetailScreenState();
}

class _FestivalDetailScreenState extends State<FestivalDetailScreen> {
  NaverMapController? mapController;
  bool isBookmarkLoading = false;
  late String memberId;

  void IsBookmark(Festival festival) async {
    final idjwt = BlocProvider.of<IdJwtCubit>(context);
    setState(() {
      memberId = idjwt.state.idJwt.id!;
    });

    final festivalbloc = BlocProvider.of<FestivalListCubit>(context);

    festivalbloc.state.festivalListResult.festivalList = [festival];
    try {
      var bookmarkId =
          await OpenApis().isBookmark(memberId, 'FESTIVAL', festival.id);
      if (bookmarkId != 0) {
        festivalbloc.state.festivalListResult.festivalList[0].isbookmark = true;
      } else {
        festivalbloc.state.festivalListResult.festivalList[0].isbookmark =
            false;
      }
    } catch (e) {
      print('즐겨찾기 상태 변경 중 오류 발생: $e');
    }
  }

  @override
  void initState() {
    IsBookmark(widget.festival);
    super.initState();
  }

  void toggleBookmark(String memberId, int storeId) async {
    setState(() {
      isBookmarkLoading = true; // 즐겨찾기 로딩 상태 시작
    });

    final festivalbloc = BlocProvider.of<FestivalListCubit>(context);

    try {
      if (festivalbloc.state.festivalListResult.festivalList[0].isbookmark) {
        // 이미 즐겨찾기에 등록된 경우, 즐겨찾기 삭제f
        festivalbloc.state.festivalListResult.festivalList[0].isbookmark =
            false;
        await OpenApis().deleteBookmark(memberId, storeId, 'FESTIVAL');
      } else {
        // 즐겨찾기에 등록되지 않은 경우, 즐겨찾기 추가

        festivalbloc.state.festivalListResult.festivalList[0].isbookmark = true;
        await OpenApis().bookmarkStore(memberId, storeId, 'FESTIVAL');
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
  void dispose() {
    mapController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height / 2 - 20;
    final width = MediaQuery.of(context).size.width - 20;

    void _onMapCreated(NaverMapController controller) async {
      var markerIcon = await NOverlayImage.fromWidget(
          widget: Icon(
            bookmarkFilterIcon[2],
            color: bookmarkFilterColor[3],
          ),
          size: Size(24, 24),
          context: context);

      mapController = controller;
      var marker = NMarker(
        id: widget.festival.id.toString(),
        position: NLatLng(widget.festival.latitude, widget.festival.longitude),
        icon: markerIcon,

        // 여기에 마커에 추가할 수 있는 다른 속성들을 추가할 수 있습니다.
      );

      mapController!.addOverlay(marker);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.festival.title),
      ),
      body: BlocBuilder<FestivalListCubit, FestivalListCubitState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: width - 100,
                            child: Text(
                              widget.festival.address,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              softWrap: true,
                            ),
                          ),
                          Text(
                            widget.festival.schedule,
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      IconButton(
                          onPressed: () {
                            toggleBookmark(memberId,
                                state.festivalListResult.festivalList[0].id);
                          },
                          icon: Icon(
                            Icons.star,
                            color: state.festivalListResult.festivalList[0]
                                    .isbookmark
                                ? Colors.yellow
                                : Colors.grey,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    state.festivalListResult.festivalList[0].subtitle,
                    softWrap: true,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Image.network(widget.festival.image),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: height,
                    width: width,
                    child: NaverMap(
                      options: NaverMapViewOptions(
                        initialCameraPosition: NCameraPosition(
                            target: NLatLng(widget.festival.latitude,
                                widget.festival.longitude),
                            zoom: 15),
                      ),
                      onMapReady: _onMapCreated,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: AppNavigationBar(
        currentIndex: 0,
      ),
    );
  }
}
