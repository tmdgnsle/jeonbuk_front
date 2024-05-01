import 'package:equatable/equatable.dart';
import 'package:jeonbuk_front/model/discount_store.dart';
import 'package:jeonbuk_front/model/restaurant.dart';

class BookmarkMap extends Equatable {
  final double latitude;
  final double longitude;
  List<DiscountStore>? discountStoreMap;
  List<Restaurant>? restaurantMap;
  final String category;

  BookmarkMap({
    required this.latitude,
    required this.longitude,
    this.discountStoreMap,
    this.restaurantMap,
    required this.category,
  });

  static BookmarkMap init() {
    return BookmarkMap(
      latitude: 0.0,
      longitude: 0.0,
      category: 'all',
    );
  }

  factory BookmarkMap.fromJson(Map<String, dynamic> json, double latitude,
      double longitude, String category) {
    return BookmarkMap(
      latitude: latitude,
      longitude: longitude,
      category: category,
      // discountStoreMap: List<DiscountStore>.from(json.map((item) => DiscountStore.fromJson(item['discountStore']))),
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props =>
      [latitude, longitude, discountStoreMap, restaurantMap, category];
}
