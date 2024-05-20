import 'package:equatable/equatable.dart';
import 'package:jeonbuk_front/model/restaurant.dart';

class RestaurantMapResult extends Equatable {
  final double latitude;
  final double longitude;
  final double radius;
  List<Restaurant> restaurantMap;
  final String category;

  RestaurantMapResult({
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.restaurantMap,
    required this.category,
  });

  static RestaurantMapResult init() {
    return RestaurantMapResult(
      latitude: 0.0,
      longitude: 0.0,
      radius: 1000.0,
      restaurantMap: [],
      category: 'all',
    );
  }

  factory RestaurantMapResult.fromJson(Map<String, dynamic> json,
      double latitude, double longitude, double radius, String category) {
    return RestaurantMapResult(
      latitude: latitude,
      longitude: longitude,
      radius: radius,
      restaurantMap: List<Restaurant>.from(
          json['content'].map((item) => Restaurant.fromJson(item))),
      category: category,
    );
  }

  @override
  List<Object?> get props =>
      [latitude, longitude, radius, restaurantMap, category];
}
