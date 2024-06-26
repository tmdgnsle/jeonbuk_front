import 'package:equatable/equatable.dart';

class DiscountStore extends Equatable {
  final int id;
  final String storeName;
  final String storeType;
  final String roadAddress;
  final double latitude;
  final double longitude;
  final String category;
  final String? etc;
  final String? promotion;
  bool isbookmark;

  DiscountStore(
      {required this.id,
        required this.storeName,
        required this.storeType,
        required this.roadAddress,
        required this.latitude,
        required this.longitude,
        required this.category,
        this.etc,
        this.promotion,
        required this.isbookmark,
      });

  factory DiscountStore.fromJson(Map<String, dynamic> json) {
    return DiscountStore(
      id: json['id'] as int,
      storeName: json['storeName'] as String,
      storeType: json['storeType'] as String,
      roadAddress: json['roadAddress'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      // JSON에서 num 타입으로 받고 toDouble()로 변환
      longitude: (json['longitude'] as num).toDouble(),
      // 동일하게 처리
      category: json['category'] as String,
      etc: json['etc'] as String?,
      promotion: json['promotion'] as String?,
      isbookmark: false,
    );
  }

  @override
  List<Object?> get props => [
    id,
    storeName,
    storeType,
    roadAddress,
    latitude,
    longitude,
    category,
    etc,
    promotion,
    isbookmark,
  ];
}