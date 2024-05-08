import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:jeonbuk_front/model/safe_home.dart';
import 'package:jeonbuk_front/model/safe_home_list_result.dart';

class SafeHomeCubit extends Cubit<SafeHomeCubitState> {
  late Dio _dio;
  late SafeHomeListResult _safeHomeListResult;

  SafeHomeCubit() : super(InitSafeHomeCubitState()) {
    _dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8080'));
  }

  loadSafeHomeList(String memberId) async {
    try {
      if (state is LoadingSafeHomeCubitState ||
          state is ErrorSafeHomeCubitState) {
        return;
      }
      emit(LoadingSafeHomeCubitState(
          safeHomeListResult: state.safeHomeListResult));
      var result = await _dio.get('/SafeHome/list', queryParameters: {
        'memberId': memberId,
      });
      emit(LoadedSafeHomeCubitState(safeHomeListResult: SafeHomeListResult.fromJson(result.data)));

    } catch (e) {
      emit(ErrorSafeHomeCubitState(
          safeHomeListResult: state.safeHomeListResult,
          errorMessage: e.toString()));
    }
  }

  deleteSafeHomeList(String memberId, int safeHomeId) async {

    try {
      if (state is LoadingSafeHomeCubitState || state is ErrorSafeHomeCubitState) {
        return;
      }
      emit(LoadingSafeHomeCubitState(safeHomeListResult: state.safeHomeListResult));
      _safeHomeListResult = state.safeHomeListResult;
      // Assuming the endpoint to delete an item is '/SafeHome/delete'
      await _dio.delete('/SafeHome/delete', queryParameters: {
        'safeReturnId': safeHomeId,
      });
      _safeHomeListResult.safehomeList.removeWhere((element) => element.id == safeHomeId);
      // Reload the list to reflect changes or simply remove the item from state if appropriate
      emit(LoadedSafeHomeCubitState(safeHomeListResult: _safeHomeListResult));
    } catch (e) {
      emit(ErrorSafeHomeCubitState(
          safeHomeListResult: state.safeHomeListResult, errorMessage: e.toString()));
    }
  }

  Future<int> SafeAdd(String memberId, String name, double startLa, double startLo, double endLa, double endLo) async{
    try{
      if (state is LoadingSafeHomeCubitState || state is ErrorSafeHomeCubitState) {
        return 0;
      }
      emit(LoadingSafeHomeCubitState(safeHomeListResult: state.safeHomeListResult));
      _safeHomeListResult = state.safeHomeListResult;
      final response = await _dio.post('/SafeHome/add', queryParameters: {
        'memberId': memberId,
        'name': name,
        'startLatitude': startLa,
        'startLongitude': startLo,
        'endLatitude': endLa,
        'endLongitude': endLo,
      });


      if(response.statusCode == 200){
        //TODO response.body로 safeReturnId받으면 _safeHomeListResult에 추가하고 emit하기
        // _safeHomeListResult.safehomeList.add
        return response.statusCode as int;
      } else throw Exception('안심귀가 추가 실패: ${response.toString()}');

    } catch(e){
      throw Exception('안심귀가 추가 실패: ${e.toString()}');
    }
  }


}

abstract class SafeHomeCubitState extends Equatable {
  final SafeHomeListResult safeHomeListResult;

  SafeHomeCubitState({required this.safeHomeListResult});
}

class InitSafeHomeCubitState extends SafeHomeCubitState {
  InitSafeHomeCubitState()
      : super(safeHomeListResult: SafeHomeListResult.init());

  @override
  List<Object?> get props => [safeHomeListResult];
}

class LoadingSafeHomeCubitState extends SafeHomeCubitState {
  LoadingSafeHomeCubitState({required super.safeHomeListResult});

  @override
  List<Object?> get props => [safeHomeListResult];
}

class LoadedSafeHomeCubitState extends SafeHomeCubitState {
  LoadedSafeHomeCubitState({required super.safeHomeListResult});

  @override
  List<Object?> get props => [safeHomeListResult];
}

class ErrorSafeHomeCubitState extends SafeHomeCubitState {
  String errorMessage;

  ErrorSafeHomeCubitState(
      {required super.safeHomeListResult, required this.errorMessage});

  @override
  List<Object?> get props => [safeHomeListResult, errorMessage];
}
