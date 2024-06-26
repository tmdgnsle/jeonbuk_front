import 'package:equatable/equatable.dart';

class ReturnRoute extends Equatable {
  final int id;
  final String name;
  final double startLa;
  final double startLo;
  final double endLa;
  final double endLo;

  ReturnRoute({
    required this.id,
    required this.name,
    required this.startLa,
    required this.startLo,
    required this.endLa,
    required this.endLo,
  });

  factory ReturnRoute.fromJson(Map<String, dynamic> json) {
    return ReturnRoute(
        id: json['id'],
        name: json['name'],
        startLa: json['startLatitude'],
        startLo: json['startLongitude'],
        endLa: json['endLatitude'],
        endLo: json['endLongitude']);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        name,
        startLa,
        startLo,
        endLa,
        endLo,
      ];
}
