import 'package:equatable/equatable.dart';
import 'package:jeonbuk_front/model/restaurant.dart';

class RestaurantListResult extends Equatable{
  final int currentPage;
  final List<Restaurant> restaurantList;

  const RestaurantListResult({
    required this.currentPage,
    required this.restaurantList,
  });

  RestaurantListResult.init() : this(currentPage: 0, restaurantList: []);

  factory RestaurantListResult.fromJson(Map<String, dynamic> json) {
    return RestaurantListResult(
      currentPage: (json['pageable']['pageNumber'] as int) + 1,
      restaurantList: json['content']
          .map<Restaurant>((item) => Restaurant.fromJson(item))
          .toList(),
    );
  }

  RestaurantListResult copywithFromJson(Map<String, dynamic> json) {
    return RestaurantListResult(
      currentPage: (json['pageable']['pageNumber'] as int) + 1,
      restaurantList: restaurantList
        ..addAll(
          json['content']
              .map<Restaurant>((item) => Restaurant.fromJson(item))
              .toList(),
        ),
    );
  }

  @override
  List<Object?> get props => [
    currentPage,
    restaurantList,
  ];
}




