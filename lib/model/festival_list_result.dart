import 'package:equatable/equatable.dart';
import 'package:jeonbuk_front/model/festival.dart';

class FestivalListResult extends Equatable {
  final int currentPage;
  List<Festival> festivalList;

  FestivalListResult({
    required this.currentPage,
    required this.festivalList,
  });

  FestivalListResult.init()
      : this(
          currentPage: 0,
          festivalList: [],
        );

  factory FestivalListResult.fromJson(
      Map<String, dynamic> json, String category) {
    return FestivalListResult(
      currentPage: (json['pageable']['pageNumber'] as int) + 1,
      festivalList: json['content']
          .map<Festival>((item) => Festival.fromJson(item))
          .toList(),
    );
  }

  FestivalListResult copywithFromJson(Map<String, dynamic> json) {
    return FestivalListResult(
      currentPage: (json['pageable']['pageNumber'] as int) + 1,
      festivalList: festivalList
        ..addAll(
          json['content']
              .map<Festival>((item) => Festival.fromJson(item))
              .toList(),
        ),
    );
  }

  @override
  List<Object?> get props => [
        currentPage,
        festivalList,
      ];
}
