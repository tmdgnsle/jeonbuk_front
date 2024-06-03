import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:jeonbuk_front/api/openapis.dart';
import 'package:jeonbuk_front/model/return_route.dart';
import 'package:jeonbuk_front/model/return_route_list_result.dart';

class ReturnRouteCubit extends Cubit<ReturnRouteCubitState> {
  late Dio _dio;
  late ReturnRouteListResult _returnRouteListResult;

  ReturnRouteCubit() : super(InitReturnRouteCubitState()) {
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

  loadReturnRouteList(String memberId) async {
    try {
      if (state is LoadingReturnRouteCubitState ||
          state is ErrorReturnRouteCubitState) {
        return;
      }
      emit(LoadingReturnRouteCubitState(
          returnRouteListResult: state.returnRouteListResult));
      var result = await _dio.get('/ReturnRoute/list', queryParameters: {
        'memberId': memberId,
      });
      _returnRouteListResult = ReturnRouteListResult.fromJson(result.data);
      emit(LoadedReturnRouteCubitState(
          returnRouteListResult: ReturnRouteListResult.fromJson(result.data)));
    } catch (e) {
      emit(ErrorReturnRouteCubitState(
          returnRouteListResult: state.returnRouteListResult,
          errorMessage: e.toString()));
    }
  }

  deleteReturnRouteList(String memberId, int returnRouteId) async {
    try {
      if (state is LoadingReturnRouteCubitState ||
          state is ErrorReturnRouteCubitState) {
        return;
      }
      emit(LoadingReturnRouteCubitState(
          returnRouteListResult: state.returnRouteListResult));
      await _dio.delete('/ReturnRoute/delete', queryParameters: {
        'returnRouteId': returnRouteId,
      });
      _returnRouteListResult.returnRouteList
          .removeWhere((element) => element.id == returnRouteId);
      emit(LoadedReturnRouteCubitState(
          returnRouteListResult: _returnRouteListResult));
    } catch (e) {
      emit(ErrorReturnRouteCubitState(
          returnRouteListResult: state.returnRouteListResult,
          errorMessage: e.toString()));
    }
  }

  Future<int> SafeAdd(String memberId, String name, double startLa,
      double startLo, double endLa, double endLo) async {
    try {
      if (state is LoadingReturnRouteCubitState ||
          state is ErrorReturnRouteCubitState) {
        return 0;
      }
      emit(LoadingReturnRouteCubitState(
          returnRouteListResult: state.returnRouteListResult));
      // _returnRouteListResult = state.returnRouteListResult;
      final response = await _dio.post('/ReturnRoute/add', queryParameters: {
        'memberId': memberId,
        'name': name,
        'startLatitude': startLa,
        'startLongitude': startLo,
        'endLatitude': endLa,
        'endLongitude': endLo,
      });
      print('response: ${response.statusCode}');

      if (response.statusCode == 200) {
        _returnRouteListResult.returnRouteList = [
          ..._returnRouteListResult.returnRouteList,
          ReturnRoute(
              id: response.data['returnRouteId'],
              name: name,
              startLa: startLa,
              startLo: startLo,
              endLa: endLa,
              endLo: endLo)
        ];

        emit(LoadedReturnRouteCubitState(
            returnRouteListResult: _returnRouteListResult));
        return response.statusCode!;
      } else {
        emit(ErrorReturnRouteCubitState(
            returnRouteListResult: _returnRouteListResult,
            errorMessage: 'Failed to add safe home: ${response.statusCode}'));
        return response.statusCode as int;
      }
    } catch (e) {
      throw Exception('안심귀가 추가 실패: ${e.toString()}');
    }
  }
}

abstract class ReturnRouteCubitState extends Equatable {
  final ReturnRouteListResult returnRouteListResult;

  ReturnRouteCubitState({required this.returnRouteListResult});
}

class InitReturnRouteCubitState extends ReturnRouteCubitState {
  InitReturnRouteCubitState()
      : super(returnRouteListResult: ReturnRouteListResult.init());

  @override
  List<Object?> get props => [returnRouteListResult];
}

class LoadingReturnRouteCubitState extends ReturnRouteCubitState {
  LoadingReturnRouteCubitState({required super.returnRouteListResult});

  @override
  List<Object?> get props => [returnRouteListResult];
}

class LoadedReturnRouteCubitState extends ReturnRouteCubitState {
  LoadedReturnRouteCubitState({required super.returnRouteListResult});

  @override
  List<Object?> get props => [returnRouteListResult];
}

class ErrorReturnRouteCubitState extends ReturnRouteCubitState {
  String errorMessage;

  ErrorReturnRouteCubitState(
      {required super.returnRouteListResult, required this.errorMessage});

  @override
  List<Object?> get props => [returnRouteListResult, errorMessage];
}
