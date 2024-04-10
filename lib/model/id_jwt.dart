import 'package:equatable/equatable.dart';

class IdJwt extends Equatable {
  final String id;
  final String jwt;

  const IdJwt({required this.id, required this.jwt});

  IdJwt.init() : this(id: '', jwt: '');


  factory IdJwt.enter(String id, String jwt) {
    return IdJwt(id: id, jwt: jwt);
  }

  @override
  List<Object?> get props => [id, jwt];
}
