import 'package:equatable/equatable.dart';
import 'package:jeonbuk_front/model/discount_store.dart';

class DiscountStoreListResult extends Equatable {
  final int currentPage;
  List<DiscountStore> discountStoreList;
  final String category;
  List<DiscountStore> searchStoreList;

  DiscountStoreListResult({
    required this.currentPage,
    required this.discountStoreList,
    required this.category,
    required this.searchStoreList,
  });

  DiscountStoreListResult.init()
      : this(
          currentPage: 0,
          discountStoreList: [],
          category: '',
          searchStoreList: [],
        );

  factory DiscountStoreListResult.fromJson(
      Map<String, dynamic> json, String category) {
    return DiscountStoreListResult(
      currentPage: (json['pageable']['pageNumber'] as int) + 1,
      discountStoreList: json['content']
          .map<DiscountStore>((item) => DiscountStore.fromJson(item))
          .toList(),
      category: category,
      searchStoreList: [],
    );
  }

  DiscountStoreListResult copywithFromJson(
      Map<String, dynamic> json, String category) {
    return DiscountStoreListResult(
      currentPage: (json['pageable']['pageNumber'] as int) + 1,
      discountStoreList: discountStoreList
        ..addAll(
          json['content']
              .map<DiscountStore>((item) => DiscountStore.fromJson(item))
              .toList(),
        ),
      category: category,
      searchStoreList: [],
    );
  }

  DiscountStoreListResult copywithFromJsonSearch(Map<String, dynamic> json) {
    searchStoreList = json['content']
            .map<DiscountStore>((item) => DiscountStore.fromJson(item))
            .toList() ??
        [];

    return DiscountStoreListResult(
        currentPage: 0,
        discountStoreList: discountStoreList,
        category: 'all',
        searchStoreList: searchStoreList);
  }

  DiscountStoreListResult copywithFromJsonFilter(
      Map<String, dynamic> json, String category) {


    bool isMismatch = (json['content'] as List).any((item) => item['category'] != category);
    int currentPage = isMismatch ? 0 : (json['pageable']['pageNumber'] as int) + 1;

    discountStoreList = json['content']
            .map<DiscountStore>((item) => DiscountStore.fromJson(item))
            .toList() ??
        [];

    return DiscountStoreListResult(
        currentPage: currentPage,
        discountStoreList: discountStoreList,
        category: category,
        searchStoreList: searchStoreList);
  }

  @override
  List<Object?> get props => [
        currentPage,
        discountStoreList,
        category,
        searchStoreList,
      ];
}
