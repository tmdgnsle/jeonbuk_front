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
import 'package:jeonbuk_front/screen/discount_store_detail_screen.dart';
import 'package:jeonbuk_front/screen/discount_store_map_screen.dart';

class DiscountStoreScreen extends StatefulWidget {
  DiscountStoreScreen({Key? key}) : super(key: key);

  static List<DiscountStore> lastNonEmptyList = [];

  @override
  State<DiscountStoreScreen> createState() => _DiscountStoreScreenState();
}

class _DiscountStoreScreenState extends State<DiscountStoreScreen> {
  final TextEditingController textEditingController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  String category = 'all';

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent - 200 <=
          scrollController.offset) {
        if (category == 'all') {
          context.read<DiscountStoreListCubit>().loadDiscountStoreList();
        } else {
          context
              .read<DiscountStoreListCubit>()
              .loadDiscountStoreListFilter(category);
        }
      }
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    scrollController.dispose();
    super.dispose();
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

  Widget filterView(BuildContext context, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: SizedBox(
        width: screenWidth - 24,
        height: 30.0,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: discountStoreFilter.keys.length,
          itemBuilder: (context, index) {
            final filterName = discountStoreFilter.keys.elementAt(index);
            final filterValue = discountStoreFilter.values.elementAt(index);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: InkWell(
                onTap: () {
                  category = filterValue;
                  context
                      .read<DiscountStoreListCubit>()
                      .loadDiscountStoreListFilter(filterValue);
                  if (scrollController.hasClients) {
                    scrollController.jumpTo(0);
                  }
                  // Implement filter application logic or context.read<DiscountStoreListCubit>().applyFilter(filterName);
                },
                child: Container(
                  width: screenWidth / 5,
                  decoration: BoxDecoration(
                    color: discountStoreFilterColor[index],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    filterName,
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
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              DiscountStoreScreen.lastNonEmptyList = [];
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back)),
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
            List<DiscountStore> stores =
                state.discountStoreListResult.searchStoreList.isNotEmpty
                    ? state.discountStoreListResult.searchStoreList
                    : (DiscountStoreScreen.lastNonEmptyList.isNotEmpty
                        ? DiscountStoreScreen.lastNonEmptyList
                        : state.discountStoreListResult.discountStoreList);

            // Update the last non-empty list if the current store list is not empty
            if (stores.isNotEmpty) {
              DiscountStoreScreen.lastNonEmptyList =
                  state.discountStoreListResult.searchStoreList;
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomTextField(
                    controller: textEditingController,
                    hintText: '검색',
                    obscure: false,
                    suffixIcons: IconButton(
                        onPressed: () => context
                            .read<DiscountStoreListCubit>()
                            .search(textEditingController.text),
                        icon: const Icon(Icons.search)),
                    height: 50,
                    onChanged: (value) =>
                        context.read<DiscountStoreListCubit>().search(value),
                  ),
                  filterView(context, screenWidth),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: ListView.separated(
                      controller: scrollController,
                      itemBuilder: (context, index) =>
                          DiscountStoreCustomListBox(
                        discountStore: stores[index],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) => DiscountStoreMapCubit(),
                                child: DiscountStoreDetailScreen(
                                    discountStore: stores[index]),
                              ),
                            ),
                          );
                        },
                      ),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemCount: stores.length,
                    ),
                  ),
                ],
              ),
            );
          }
          return Container();
        },
      ),
      bottomNavigationBar: AppNavigationBar(
        currentIndex: 0,
      ),
    );
  }
}
