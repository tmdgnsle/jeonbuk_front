import 'package:equatable/equatable.dart';
import 'package:jeonbuk_front/model/discount_store.dart';

class DiscountStoreListResult extends Equatable {
  final int currentPage;
  final List<DiscountStore> discountStoreList;

  const DiscountStoreListResult({
    required this.currentPage,
    required this.discountStoreList,
  });

  DiscountStoreListResult.init() : this(currentPage: 0, discountStoreList: []);

  factory DiscountStoreListResult.fromJson(Map<String, dynamic> json) {
    return DiscountStoreListResult(
      currentPage: (json['pageable']['pageNumber'] as int) + 1,
      discountStoreList: json['content']
          .map<DiscountStore>((item) => DiscountStore.fromJson(item))
          .toList(),
    );
  }

  DiscountStoreListResult copywithFromJson(Map<String, dynamic> json) {
    return DiscountStoreListResult(
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


