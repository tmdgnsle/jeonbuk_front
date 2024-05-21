import 'package:equatable/equatable.dart';

class Festival extends Equatable {
  int id;
  String subtitle;
  String title;
  String schedule;
  String content;
  String image;
  String address;
  double latitude;
  double longitude;
  bool isbookmark;

  Festival({
    required this.id,
    required this.subtitle,
    required this.title,
    required this.schedule,
    required this.content,
    required this.image,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.isbookmark,
  });

  factory Festival.fromJson(Map<String, dynamic> json) {
    return Festival(
      id: json['id'] as int,
      subtitle: json['subtitle'] as String,
      title: json['title'] as String,
      schedule: json['schedule'] as String,
      content: json['content'] as String,
      image: json['image'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      isbookmark: false,
    );
  }

  @override
  List<Object?> get props => [
        id,
        subtitle,
        title,
        schedule,
        content,
        image,
        address,
        latitude,
        longitude,
        isbookmark,
      ];
}
