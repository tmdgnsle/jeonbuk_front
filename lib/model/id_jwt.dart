import 'package:equatable/equatable.dart';

class IdJwt extends Equatable {
  String? id;
  String? jwt;
  String? name;
  String? phoneNum;
  String? emergencyNum;

  IdJwt({
    this.id,
    this.jwt,
    this.name,
    this.phoneNum,
    this.emergencyNum,
  });

  IdJwt.init() : this();

  factory IdJwt.login(String id, String jwt, String name, String phoneNum,
      String emergencyNum) {
    return IdJwt(
        id: id,
        jwt: jwt,
        name: name,
        phoneNum: phoneNum,
        emergencyNum: emergencyNum);
  }

  factory IdJwt.logout() {
    return IdJwt(
        id: null, jwt: null, name: null, phoneNum: null, emergencyNum: null);
  }

  @override
  List<Object?> get props => [id, jwt, phoneNum, emergencyNum];
}
