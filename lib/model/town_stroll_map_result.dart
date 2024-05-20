import 'package:equatable/equatable.dart';
import 'package:jeonbuk_front/model/town_stroll.dart';

class TownStrollMapResult extends Equatable {
  final double latitude;
  final double longitude;
  final double radius;
  List<TownStroll> townStrollMap;

  TownStrollMapResult({
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.townStrollMap,
  });

  static TownStrollMapResult init() {
    return TownStrollMapResult(
      latitude: 0.0,
      longitude: 0.0,
      radius: 1000.0,
      townStrollMap: [],
    );
  }

  factory TownStrollMapResult.fromJson(Map<String, dynamic> json,
      double latitude, double longitude, double radius) {
    print(json['townStrollList']);
    return TownStrollMapResult(
      latitude: latitude,
      longitude: longitude,
      radius: radius,
      townStrollMap: List<TownStroll>.from(
          json['townStrollList'].map((item) => TownStroll.fromJson(item))),
    );
  }

  @override
  List<Object?> get props => [latitude, longitude, radius, townStrollMap];
}
