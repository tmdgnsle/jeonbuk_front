import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeonbuk_front/components/app_navigation_bar.dart';
import 'package:jeonbuk_front/components/custom_text_field.dart';
import 'package:jeonbuk_front/components/discountstore_custom_list_box.dart';
import 'package:jeonbuk_front/const/filter.dart';
import 'package:jeonbuk_front/cubit/discount_store_list_cubit.dart';
import 'package:jeonbuk_front/cubit/discount_store_map_cubit.dart';
import 'package:jeonbuk_front/model/discount_store.dart';
import 'package:jeonbuk_front/screen/discount_store_map_screen.dart';

class DiscountStoreScreen extends StatefulWidget {
  const DiscountStoreScreen({super.key});

  @override
  State<DiscountStoreScreen> createState() => _DiscountStoreScreenState();
}

class _DiscountStoreScreenState extends State<DiscountStoreScreen> {
  ScrollController scrollController = ScrollController();
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent - 200 <=
          scrollController.offset) {
        context.read<DiscountStoreListCubit>().loadDiscountStoreList('all');
      }
    });
  }

  Widget _loading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _error(String errMessage) {
    return Center(
      child: Text(errMessage),
    );
  }

  Widget _discountStoreListWidget(List<DiscountStore> discountStore) {
    return ListView.separated(
        controller: scrollController,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          if (index == discountStore.length) {
            return _loading();
          }
          return DiscountStoreCustomListBox(
              discountStore: discountStore[index]);
        },
        separatorBuilder: (context, index) => const SizedBox(
              height: 10,
            ),
        itemCount: discountStore.length);
  }

  Widget FilterView(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const filterHeight = 30.0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: SizedBox(
        width: screenWidth - 24,
        height: filterHeight,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount:
              discountStoreFilter.keys.length, // Map의 키 개수를 itemCount로 사용
          itemBuilder: (context, index) {
            final filterKeys =
                discountStoreFilter.keys.toList(); // Map의 키를 리스트로 변환
            final filterName = filterKeys[index]; // 현재 인덱스에 해당하는 키
            discountStoreFilter[filterName]; // 키를 사용하여 Map에서 값을 얻음
            final filterWidth = screenWidth / 5;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: InkWell(
                onTap: () async {},
                child: Container(
                  width: filterWidth,
                  decoration: BoxDecoration(
                    color: filterColor[index], // 이 예제에서는 색상을 고정값으로 설정
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 2,
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => DiscountStoreMapCubit(),
                      child: DiscountStoreMapScreen(),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.map)),
        ],
      ),
      body: BlocBuilder<DiscountStoreListCubit, DiscountStoreListCubitState>(
        builder: (context, state) {
          if (state is ErrorDiscountStoreListCubitState) {
            return _error(state.errorMessage);
          }
          if (state is LoadedDiscountStoreListCubitState ||
              state is LoadingDiscountStoreListCubitState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomTextField(
                    controller: _textEditingController,
                    hintText: '검색',
                    obscure: false,
                    suffixIcons:
                        IconButton(onPressed: () {}, icon: Icon(Icons.search)),
                    height: 50,
                  ),
                  FilterView(context),
                  Expanded(
                    child: _discountStoreListWidget(
                        state.discountStoreListResult.discountStoreList),
                  ),
                ],
              ),
            );
          }
          return Container();
        },
      ),
      bottomNavigationBar: AppNavigationBar(),
    );
  }
}
