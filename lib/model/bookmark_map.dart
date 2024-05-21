import 'package:equatable/equatable.dart';
import 'package:jeonbuk_front/model/discount_store.dart';
import 'package:jeonbuk_front/model/festival.dart';
import 'package:jeonbuk_front/model/restaurant.dart';
import 'package:jeonbuk_front/model/town_stroll.dart';

class BookmarkMap extends Equatable {
  List<DiscountStore> discountStoreMap;
  List<Restaurant> restaurantMap;
  List<Festival> festivalMap;
  List<TownStroll> townStrollMap;

  BookmarkMap({
    required this.discountStoreMap,
    required this.restaurantMap,
    required this.festivalMap,
    required this.townStrollMap,
  });

  static BookmarkMap init() {
    return BookmarkMap(
      restaurantMap: [],
      discountStoreMap: [],
      festivalMap: [],
      townStrollMap: [],
    );
  }

  factory BookmarkMap.fromJson(Map<String, dynamic> json, String category) {
    switch (category) {
      case 'RESTAURANT':
        List<dynamic>? restaurantJson = json[category];
        List<Restaurant> restaurants = restaurantJson != null
            ? List<Restaurant>.from(
                restaurantJson.map((x) => Restaurant.fromJson(x)))
            : [];
        return BookmarkMap(
            restaurantMap: restaurants,
            discountStoreMap: [],
            festivalMap: [],
            townStrollMap: []);
      case 'DISCOUNT_STORE':
        List<dynamic>? discountStoreJson = json[category];
        List<DiscountStore> discountStores = discountStoreJson != null
            ? List<DiscountStore>.from(
                discountStoreJson.map((x) => DiscountStore.fromJson(x)))
            : [];
        return BookmarkMap(
            discountStoreMap: discountStores,
            restaurantMap: [],
            festivalMap: [],
            townStrollMap: []);
      case 'FESTIVAL':
        List<dynamic>? festivalJson = json[category];
        List<Festival> festivals = festivalJson != null
            ? List<Festival>.from(festivalJson.map((x) => Festival.fromJson(x)))
            : [];
        return BookmarkMap(
            discountStoreMap: [],
            restaurantMap: [],
            festivalMap: festivals,
            townStrollMap: []);
      case 'TOWN_STROLL':
        List<dynamic>? townStrollJson = json[category];
        List<TownStroll> townStrolls = townStrollJson != null
            ? List<TownStroll>.from(
                townStrollJson.map((x) => TownStroll.fromJson(x)))
            : [];
        return BookmarkMap(
            discountStoreMap: [],
            restaurantMap: [],
            festivalMap: [],
            townStrollMap: townStrolls);
      case 'ALL':
        List<dynamic>? restaurantJson = json['RESTAURANT'];
        List<dynamic>? discountStoreJson = json['DISCOUNT_STORE'];
        List<dynamic>? festivalJson = json['FESTIVAL'];
        List<dynamic>? townStrollJson = json['TOWN_STROLL'];
        List<Restaurant> restaurants = restaurantJson != null
            ? List<Restaurant>.from(
                restaurantJson.map((x) => Restaurant.fromJson(x)))
            : [];
        List<DiscountStore> discountStores = discountStoreJson != null
            ? List<DiscountStore>.from(
                discountStoreJson.map((x) => DiscountStore.fromJson(x)))
            : [];
        List<Festival> festivals = festivalJson != null
            ? List<Festival>.from(festivalJson.map((x) => Festival.fromJson(x)))
            : [];

        List<TownStroll> townStrolls = townStrollJson != null
            ? List<TownStroll>.from(
                townStrollJson.map((x) => TownStroll.fromJson(x)))
            : [];
        return BookmarkMap(
            restaurantMap: restaurants,
            discountStoreMap: discountStores,
            festivalMap: festivals,
            townStrollMap: townStrolls);
      default:
        throw ArgumentError('Invalid category: $category');
    }
  }

  @override
  // TODO: implement props
  List<Object?> get props => [discountStoreMap, restaurantMap];
}
