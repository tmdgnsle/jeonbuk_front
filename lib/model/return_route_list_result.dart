import 'package:equatable/equatable.dart';
import 'package:jeonbuk_front/model/return_route.dart';

class ReturnRouteListResult extends Equatable {
  List<ReturnRoute> returnRouteList;

  ReturnRouteListResult({required this.returnRouteList});

  ReturnRouteListResult.init() : this(returnRouteList: []);

  factory ReturnRouteListResult.fromJson(Map<String, dynamic> json) {
    return ReturnRouteListResult(
      returnRouteList: json['ReturnRouteList']
          .map<ReturnRoute>((item) => ReturnRoute.fromJson(item))
          .toList(),
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [returnRouteList];
}
