import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jeonbuk_front/model/id_jwt.dart';

class IdJwtCubit extends Cubit<IdJwtCubitState> {
  IdJwtCubit() : super(InitIdJwtCubitState());

  Login(String loginId, String loginJwt, String name, String phoneNum,
      String emergencyNum) {
    emit(LoginIdJwtCubitState(
        idJwt: IdJwt.login(loginId, loginJwt, name, phoneNum, emergencyNum)));
  }

  Logout() {
    emit(LogoutIdJwtCubitState(idJwt: IdJwt.logout()));
  }

  Modify(String name, String phoneNum, String emergencyNum) {
    emit(LoginIdJwtCubitState(
        idJwt: IdJwt.login(
            state.idJwt.id!, state.idJwt.jwt!, name, phoneNum, emergencyNum)));
  }
}

abstract class IdJwtCubitState extends Equatable {
  final IdJwt idJwt;

  const IdJwtCubitState({required this.idJwt});
}

class InitIdJwtCubitState extends IdJwtCubitState {
  InitIdJwtCubitState() : super(idJwt: IdJwt.init());

  @override
  List<Object?> get props => [idJwt];
}

class LoginIdJwtCubitState extends IdJwtCubitState {
  const LoginIdJwtCubitState({required super.idJwt});

  @override
  List<Object?> get props => [idJwt];
}

class LogoutIdJwtCubitState extends IdJwtCubitState {
  const LogoutIdJwtCubitState({required super.idJwt});

  @override
  List<Object?> get props => [idJwt];
}
