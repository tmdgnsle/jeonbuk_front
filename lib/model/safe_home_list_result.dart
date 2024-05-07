import 'package:equatable/equatable.dart';
import 'package:jeonbuk_front/model/safe_home.dart';

class SafeHomeListResult extends Equatable {
  List<SafeHome> safehomeList;

  SafeHomeListResult({required this.safehomeList});

  SafeHomeListResult.init() : this(safehomeList: []);

  factory SafeHomeListResult.fromJson(Map<String, dynamic> json) {
    return SafeHomeListResult(
      safehomeList: json['safeReturnList']
          .map<SafeHome>((item) => SafeHome.fromJson(item))
          .toList(),
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [safehomeList];
}
