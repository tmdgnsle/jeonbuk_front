import 'package:bloc/bloc.dart';

enum IdJwtCubitState {logout, login}

class IdJwtCubit extends Cubit<IdJwtCubitState> {
  IdJwtCubit() : super(IdJwtCubitState.logout);
  String? id;
  String? jwt;

  void Login(IdJwtCubitState current, String loginId, String loginJwt){
    id = loginId;
    jwt = loginJwt;
    emit(current);
  }

  void Logout(IdJwtCubitState current){
    id = null;
    jwt = null;
    emit(current);
  }

}


