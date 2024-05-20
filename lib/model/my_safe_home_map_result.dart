import 'package:equatable/equatable.dart';
import 'package:jeonbuk_front/model/my_safe_home.dart';

class MySafeHomeMapResult extends Equatable {
  final double latitude;
  final double longitude;
  final double radius;
  final List<MySafeHome> mySafeHomeMap;
  String category;

  // 기본 생성자에 현재 위치 정보를 받을 수 있는 매개변수 추가
  MySafeHomeMapResult({
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.mySafeHomeMap,
    required this.category,
  });

  static MySafeHomeMapResult init() {
    // 여기에서 기본값을 정의할 수 있습니다.
    // 예를 들어, 지정된 기본 위치 또는 앱의 기본 설정에 맞는 위치를 사용할 수 있습니다.
    return MySafeHomeMapResult(
      latitude: 0.0, // 기본 위도값
      longitude: 0.0, // 기본 경도값
      radius: 1000.0, // 기본 반경값
      mySafeHomeMap: [], // 빈 상점 목록
      category: 'all',
    );
  }

  // JSON 데이터와 위치 정보를 바탕으로 객체를 생성하는 팩토리 생성자
  factory MySafeHomeMapResult.fromJson(Map<String, dynamic> json,
      double latitude, double longitude, double radius, String category) {
    return MySafeHomeMapResult(
      latitude: latitude,
      longitude: longitude,
      radius: radius,
      mySafeHomeMap: List<MySafeHome>.from(
          json[category != 'all' ? category : 'content']
              .map((item) => MySafeHome.fromJson(item))),
      category: category,
    );
  }

  // JSON 데이터와 위치 정보를 바탕으로 객체의 상태를 업데이트하는 메서드
  MySafeHomeMapResult copyWithFromJson(Map<String, dynamic> json,
      double latitude, double longitude, double radius, category) {
    return MySafeHomeMapResult(
      latitude: latitude,
      longitude: longitude,
      radius: radius,
      mySafeHomeMap: List<MySafeHome>.from(
          json['content'].map((item) => MySafeHome.fromJson(item))),
      category: category,
    );
  }

  @override
  List<Object?> get props =>
      [latitude, longitude, radius, mySafeHomeMap, category];
}
