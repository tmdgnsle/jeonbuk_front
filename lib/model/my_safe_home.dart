import 'package:equatable/equatable.dart';

class MySafeHome extends Equatable {
  final double latitude;
  final double longitude;
  final String roadAddress;
  final String type;
  final int id;

  MySafeHome(
      {required this.latitude,
      required this.longitude,
      required this.roadAddress,
      required this.type,
      required this.id});

  factory MySafeHome.fromJson(Map<String, dynamic> json) {
    return MySafeHome(
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
        roadAddress:
            json['roadAddress'] != null ? json['roadAddress'] as String : '',
        type: json['type'] as String,
        id: json['id'] as int);
  }

  @override
  List<Object?> get props => [
        latitude,
        longitude,
        roadAddress,
        type,
        id,
      ];
}
