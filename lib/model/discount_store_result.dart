import 'package:equatable/equatable.dart';

class DiscountStoreResult extends Equatable {
  final int currentPage;
  final List<DiscountStore> discountStoreList;

  const DiscountStoreResult({
    required this.currentPage,
    required this.discountStoreList,
  });

  DiscountStoreResult.init() : this(currentPage: 1, discountStoreList: []);

  factory DiscountStoreResult.fromJson(Map<String, dynamic> json) {
    return DiscountStoreResult(
      currentPage: (json['pageable']['pageNumber'] as int) + 1,
      discountStoreList: json['content']
          .map<DiscountStore>((item) => DiscountStore.fromJson(item))
          .toList(),
    );
  }

  DiscountStoreResult copywithFromJson(Map<String, dynamic> json) {
    return DiscountStoreResult(
      currentPage: (json['pageable']['pageNumber'] as int) + 1,
      discountStoreList: discountStoreList
        ..addAll(
          json['content']
              .map<DiscountStore>((item) => DiscountStore.fromJson(item))
              .toList(),
        ),
    );
  }

  @override
  List<Object?> get props => [
        currentPage,
        discountStoreList,
      ];
}

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

  DiscountStore(
      {required this.id,
      required this.storeName,
      required this.storeType,
      required this.roadAddress,
      required this.latitude,
      required this.longitude,
      required this.category,
      this.etc,
      this.promotion});

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
      ];
}
