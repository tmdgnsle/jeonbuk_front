import 'package:equatable/equatable.dart';
import 'package:jeonbuk_front/model/discount_store.dart';

class DiscountStoreMapResult extends Equatable {
  final double latitude;
  final double longitude;
  final double radius;
  final List<DiscountStore> discountStoreMap;

  // 기본 생성자에 현재 위치 정보를 받을 수 있는 매개변수 추가
  const DiscountStoreMapResult({
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.discountStoreMap,
  });

  static DiscountStoreMapResult init() {
    // 여기에서 기본값을 정의할 수 있습니다.
    // 예를 들어, 지정된 기본 위치 또는 앱의 기본 설정에 맞는 위치를 사용할 수 있습니다.
    return DiscountStoreMapResult(
      latitude: 0.0, // 기본 위도값
      longitude: 0.0, // 기본 경도값
      radius: 1000.0, // 기본 반경값
      discountStoreMap: [], // 빈 상점 목록
    );
  }

  // JSON 데이터와 위치 정보를 바탕으로 객체를 생성하는 팩토리 생성자
  factory DiscountStoreMapResult.fromJson(Map<String, dynamic> json, double latitude, double longitude, double radius) {
    return DiscountStoreMapResult(
      latitude: latitude,
      longitude: longitude,
      radius: radius,
      discountStoreMap: List<DiscountStore>.from(json['content'].map((item) => DiscountStore.fromJson(item))),
    );
  }

  // JSON 데이터와 위치 정보를 바탕으로 객체의 상태를 업데이트하는 메서드
  DiscountStoreMapResult copyWithFromJson(Map<String, dynamic> json, double latitude, double longitude, double radius) {
    return DiscountStoreMapResult(
      latitude: latitude,
      longitude: longitude,
      radius: radius,
      discountStoreMap: List<DiscountStore>.from(json['content'].map((item) => DiscountStore.fromJson(item))),
    );
  }

  @override
  List<Object?> get props => [latitude, longitude, radius, discountStoreMap];
}
