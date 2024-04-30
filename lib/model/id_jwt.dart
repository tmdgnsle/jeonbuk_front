import 'package:equatable/equatable.dart';

class IdJwt extends Equatable {
  String? id;
  String? jwt;

  IdJwt({
    this.id,
    this.jwt,
  });

  IdJwt.init() : this();

  factory IdJwt.login(String id, String jwt) {
    return IdJwt(id: id, jwt: jwt);
  }

  factory IdJwt.logout() {
    return IdJwt(id: null, jwt: null);
  }

  @override
  List<Object?> get props => [id, jwt];
}
