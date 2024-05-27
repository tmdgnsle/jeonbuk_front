import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:jeonbuk_front/api/openapis.dart';
import 'package:jeonbuk_front/model/safe_home.dart';
import 'package:jeonbuk_front/model/safe_home_list_result.dart';

class SafeHomeCubit extends Cubit<SafeHomeCubitState> {
  late Dio _dio;
  late SafeHomeListResult _safeHomeListResult;

  SafeHomeCubit() : super(InitSafeHomeCubitState()) {
    _dio = Dio(BaseOptions(
      baseUrl: 'http://34.64.170.83:8080',
      connectTimeout: Duration(seconds: 30),
      // 연결 타임아웃
      receiveTimeout: Duration(seconds: 30),
      headers: {
        'Authorization': jwt,
      },
    ));
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
      _safeHomeListResult = SafeHomeListResult.fromJson(result.data);
      emit(LoadedSafeHomeCubitState(
          safeHomeListResult: SafeHomeListResult.fromJson(result.data)));
    } catch (e) {
      emit(ErrorSafeHomeCubitState(
          safeHomeListResult: state.safeHomeListResult,
          errorMessage: e.toString()));
    }
  }

  deleteSafeHomeList(String memberId, int safeHomeId) async {
    try {
      if (state is LoadingSafeHomeCubitState ||
          state is ErrorSafeHomeCubitState) {
        return;
      }
      emit(LoadingSafeHomeCubitState(
          safeHomeListResult: state.safeHomeListResult));
      // _safeHomeListResult = state.safeHomeListResult;
      print('이전: ${_safeHomeListResult}');
      // Assuming the endpoint to delete an item is '/SafeHome/delete'
      await _dio.delete('/SafeHome/delete', queryParameters: {
        'safeReturnId': safeHomeId,
      });
      _safeHomeListResult.safehomeList
          .removeWhere((element) => element.id == safeHomeId);
      // Reload the list to reflect changes or simply remove the item from state if appropriate
      print('_safeHomeListResult: ${_safeHomeListResult}');
      emit(LoadedSafeHomeCubitState(safeHomeListResult: _safeHomeListResult));
    } catch (e) {
      emit(ErrorSafeHomeCubitState(
          safeHomeListResult: state.safeHomeListResult,
          errorMessage: e.toString()));
    }
  }

  Future<int> SafeAdd(String memberId, String name, double startLa,
      double startLo, double endLa, double endLo) async {
    try {
      if (state is LoadingSafeHomeCubitState ||
          state is ErrorSafeHomeCubitState) {
        return 0;
      }
      emit(LoadingSafeHomeCubitState(
          safeHomeListResult: state.safeHomeListResult));
      // _safeHomeListResult = state.safeHomeListResult;
      final response = await _dio.post('/SafeHome/add', queryParameters: {
        'memberId': memberId,
        'name': name,
        'startLatitude': startLa,
        'startLongitude': startLo,
        'endLatitude': endLa,
        'endLongitude': endLo,
      });

      if (response.statusCode == 200) {
        print('이전 _safeHomeListResult: ${_safeHomeListResult.safehomeList}');
        _safeHomeListResult.safehomeList = [
          ..._safeHomeListResult.safehomeList,
          SafeHome(
              id: response.data['safeReturnId'],
              name: name,
              startLa: startLa,
              startLo: startLo,
              endLa: endLa,
              endLo: endLo)
        ];
        print('_safeHomeListResult: ${_safeHomeListResult.safehomeList}');

        emit(LoadedSafeHomeCubitState(safeHomeListResult: _safeHomeListResult));
        return response.statusCode as int;
      } else {
        emit(ErrorSafeHomeCubitState(
            safeHomeListResult: _safeHomeListResult,
            errorMessage: 'Failed to add safe home: ${response.statusCode}'));
        return response.statusCode as int;
      }
    } catch (e) {
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
