import 'package:equatable/equatable.dart';
import 'package:jeonbuk_front/model/discount_store.dart';
import 'package:jeonbuk_front/model/restaurant.dart';

class BookmarkMap extends Equatable {

  List<DiscountStore> discountStoreMap;
  List<Restaurant> restaurantMap;

  BookmarkMap({
    required this.discountStoreMap,
    required this.restaurantMap,
  });

  static BookmarkMap init() {
    return BookmarkMap(restaurantMap: [], discountStoreMap: []
    );
  }

  factory BookmarkMap.fromJson(Map<String, dynamic> json, String category) {
    switch (category) {
      case 'RESTAURANT':
        List<dynamic>? restaurantJson = json[category];
        List<Restaurant> restaurants = restaurantJson != null
            ? List<Restaurant>.from(restaurantJson.map((x) => Restaurant.fromJson(x)))
            : [];
        return BookmarkMap(restaurantMap: restaurants, discountStoreMap: []);
      case 'DISCOUNT_STORE':
        List<dynamic>? discountStoreJson = json[category];
        List<DiscountStore> discountStores = discountStoreJson != null
            ? List<DiscountStore>.from(discountStoreJson.map((x) => DiscountStore.fromJson(x)))
            : [];
        return BookmarkMap(discountStoreMap: discountStores, restaurantMap: []);
      case 'TOWN_STROLL':
      case 'FESTIVAL':
      case 'ALL':
        List<dynamic>? restaurantJson = json['RESTAURANT'];
        List<dynamic>? discountStoreJson = json['DISCOUNT_STORE'];
        List<Restaurant> restaurants = restaurantJson != null
            ? List<Restaurant>.from(restaurantJson.map((x) => Restaurant.fromJson(x)))
            : [];
        List<DiscountStore> discountStores = discountStoreJson != null
            ? List<DiscountStore>.from(discountStoreJson.map((x) => DiscountStore.fromJson(x)))
            : [];
        return BookmarkMap(restaurantMap: restaurants, discountStoreMap: discountStores);
      default:
        throw ArgumentError('Invalid category: $category');
    }
  }

  @override
  // TODO: implement props
  List<Object?> get props =>
      [discountStoreMap, restaurantMap];
}
