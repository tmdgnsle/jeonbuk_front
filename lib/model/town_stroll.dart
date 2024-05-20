import 'package:equatable/equatable.dart';

class TownStroll extends Equatable {
  int id;
  String name;
  String region;
  String largeCategory;
  String middleCategory;
  String smallCategory;
  String address;
  double latitude;
  double longitude;
  bool isbookmark;

  TownStroll({
    required this.id,
    required this.name,
    required this.region,
    required this.largeCategory,
    required this.middleCategory,
    required this.smallCategory,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.isbookmark,
  });

  factory TownStroll.fromJson(Map<String, dynamic> json) {
    return TownStroll(
      id: json['id'] as int,
      name: json['name'] as String,
      region: json['region'] as String,
      largeCategory: json['largeCategory'] as String,
      middleCategory: json['middleCategory'] as String,
      smallCategory: json['smallCategory'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      isbookmark: false,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        region,
        largeCategory,
        middleCategory,
        smallCategory,
        address,
        latitude,
        longitude,
        isbookmark,
      ];
}
