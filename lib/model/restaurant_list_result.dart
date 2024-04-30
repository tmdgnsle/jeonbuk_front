import 'package:equatable/equatable.dart';
import 'package:jeonbuk_front/model/restaurant.dart';

class RestaurantListResult extends Equatable {
  final int currentPage;
  List<Restaurant> restaurantList;
  final String category;
  List<Restaurant> searchStoreList;

  RestaurantListResult({
    required this.currentPage,
    required this.restaurantList,
    required this.category,
    required this.searchStoreList,
  });

  RestaurantListResult.init()
      : this(
          currentPage: 0,
          restaurantList: [],
          category: '',
          searchStoreList: [],
        );

  factory RestaurantListResult.fromJson(
      Map<String, dynamic> json, String category) {
    return RestaurantListResult(
      currentPage: (json['pageable']['pageNumber'] as int) + 1,
      restaurantList: json['content']
          .map<Restaurant>((item) => Restaurant.fromJson(item))
          .toList(),
      category: category,
      searchStoreList: [],
    );
  }

  RestaurantListResult copywithFromJson(
      Map<String, dynamic> json, String category) {
    return RestaurantListResult(
      currentPage: (json['pageable']['pageNumber'] as int) + 1,
      restaurantList: restaurantList
        ..addAll(
          json['content']
              .map<Restaurant>((item) => Restaurant.fromJson(item))
              .toList(),
        ),
      category: category,
      searchStoreList: [],
    );
  }

  RestaurantListResult copywithFromJsonSearch(Map<String, dynamic> json) {
    searchStoreList = json['content']
            .map<Restaurant>((item) => Restaurant.fromJson(item))
            .toList() ??
        [];

    return RestaurantListResult(
        currentPage: 0,
        restaurantList: restaurantList,
        category: 'all',
        searchStoreList: searchStoreList);
  }

  RestaurantListResult copywithFromJsonFilter(
      Map<String, dynamic> json, String category) {
    bool isMismatch =
        (json['content'] as List).any((item) => item['category'] != category);
    int currentPage =
        isMismatch ? 0 : (json['pageable']['pageNumber'] as int) + 1;

    restaurantList = json['content']
            .map<Restaurant>((item) => Restaurant.fromJson(item))
            .toList() ??
        [];

    return RestaurantListResult(
        currentPage: currentPage,
        restaurantList: restaurantList,
        category: category,
        searchStoreList: searchStoreList);
  }

  @override
  List<Object?> get props => [
        currentPage,
        restaurantList,
        category,
        searchStoreList,
      ];
}
