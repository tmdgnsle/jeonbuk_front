import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeonbuk_front/components/app_navigation_bar.dart';
import 'package:jeonbuk_front/components/custom_text_field.dart';
import 'package:jeonbuk_front/components/restaurant_custom_list_box.dart';
import 'package:jeonbuk_front/const/filter.dart';
import 'package:jeonbuk_front/cubit/restaurant_list_cubit.dart';
import 'package:jeonbuk_front/cubit/restaurant_map_cubit.dart';
import 'package:jeonbuk_front/model/restaurant.dart';
import 'package:jeonbuk_front/screen/restaurant_detail_screen.dart';
import 'package:jeonbuk_front/screen/restaurant_map_screen.dart';

class RestaurantScreen extends StatefulWidget {
  RestaurantScreen({Key? key}) : super(key: key);

  static List<Restaurant> lastNonEmptyList = [];

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  final TextEditingController textEditingController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent - 200 <=
          scrollController.offset) {
        context.read<RestaurantListCubit>().loadRestaurantList('all');
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
          itemCount: restaurantFilter.keys.length,
          itemBuilder: (context, index) {
            final filterName = restaurantFilter.keys.elementAt(index);
            final filterValue = restaurantFilter.values.elementAt(index);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: InkWell(
                onTap: () {
                  context
                      .read<RestaurantListCubit>()
                      .loadRestaurantList(filterValue);
                  // Implement filter application logic or context.read<RestaurantListCubit>().applyFilter(filterName);
                },
                child: Container(
                  width: screenWidth / 5,
                  decoration: BoxDecoration(
                    color: restaurantFilterColor[index],
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 2,
                        offset: const Offset(0, 0),
                      ),
                    ],
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
              RestaurantScreen.lastNonEmptyList = [];
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back)),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => RestaurantMapCubit(),
                      child: RestaurantMapScreen(),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.map)),
        ],
      ),
      body: BlocBuilder<RestaurantListCubit, RestaurantListCubitState>(
        builder: (context, state) {
          if (state is ErrorRestaurantListCubitState) {
            return _error(state.errorMessage);
          }
          if (state is LoadedRestaurantListCubitState ||
              state is LoadingRestaurantListCubitState) {
            List<Restaurant> stores =
                state.restaurantListResult.searchStoreList.isNotEmpty
                    ? state.restaurantListResult.searchStoreList
                    : (RestaurantScreen.lastNonEmptyList.isNotEmpty
                        ? RestaurantScreen.lastNonEmptyList
                        : state.restaurantListResult.restaurantList);

            // Update the last non-empty list if the current store list is not empty
            if (stores.isNotEmpty) {
              RestaurantScreen.lastNonEmptyList =
                  state.restaurantListResult.searchStoreList;
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
                            .read<RestaurantListCubit>()
                            .search(textEditingController.text),
                        icon: const Icon(Icons.search)),
                    height: 50,
                    onChanged: (value) =>
                        context.read<RestaurantListCubit>().search(value),
                  ),
                  filterView(context, screenWidth),
                  Expanded(
                    child: ListView.separated(
                      controller: scrollController,
                      itemBuilder: (context, index) => RestaurantCustomListBox(
                        restaurant: stores[index],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RestaurantDetailScreen(
                                  restaurant: stores[index]),
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
      bottomNavigationBar: AppNavigationBar(),
    );
  }
}
