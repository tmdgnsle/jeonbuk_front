import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jeonbuk_front/model/id_jwt.dart';

class IdJwtCubit extends Cubit<IdJwtCubitState> {
  IdJwtCubit() : super(InitIdJwtCubitState());

  Login(String loginId, String loginJwt) {
    emit(LoginIdJwtCubitState(idJwt: IdJwt.login(loginId, loginJwt)));
  }

  Logout() {
    emit(LogoutIdJwtCubitState(idJwt: IdJwt.logout()));
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
