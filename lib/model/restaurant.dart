import 'package:equatable/equatable.dart';

class Restaurant extends Equatable {
  int id;
  String storeName;
  String roadAddress;
  double latitude;
  double longitude;
  String? etc;
  String? promotion;

  Restaurant(
      {required this.id,
        required this.storeName,
        required this.roadAddress,
        required this.latitude,
        required this.longitude,
        this.etc,
        this.promotion});

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] as int,
      storeName: json['storeName'] as String,
      roadAddress: json['roadAddress'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      // JSON에서 num 타입으로 받고 toDouble()로 변환
      longitude: (json['longitude'] as num).toDouble(),
      // 동일하게 처리
      etc: json['etc'] as String?,
      promotion: json['promotion'] as String?,
    );
  }

  @override
  List<Object?> get props => [
    id,
    storeName,
    roadAddress,
    latitude,
    longitude,
    etc,
    promotion,
  ];
}