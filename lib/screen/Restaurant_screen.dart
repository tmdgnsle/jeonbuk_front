import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeonbuk_front/components/restaurant_list.dart';
import 'package:jeonbuk_front/cubit/restaurant_cubit.dart';
import 'package:jeonbuk_front/model/restaurant_result.dart';

class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({super.key});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent - 200 <=
          scrollController.offset) {
        context.read<RestaurantCubit>().loadRestaurantList();
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

  Widget _restaurantListWidget(List<Restaurant> restaurant) {
    return ListView.separated(
        controller: scrollController,
        itemBuilder: (context, index) {
          if (index == restaurant.length) {
            return _loading();
          }
          return RestaurantList(restaurant: restaurant[index]);
        },
        separatorBuilder: (context, index) => const Divider(
          color: Colors.grey,
        ),
        itemCount: restaurant.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(onPressed: (){}, icon: Icon(Icons.map)),
        ],
      ),
      body: BlocBuilder<RestaurantCubit, RestaurantCubitState>(
        builder: (context, state) {
          if (state is ErrorRestaurantCubitState) {
            return _error(state.errorMessage);
          }
          if(state is LoadedRestaurantCubitState || state is LoadingRestaurantCubitState){
            return _restaurantListWidget(state.restaurantResult.restaurantList);
          }
          return Container();
        },
      ),
    );
  }
}
