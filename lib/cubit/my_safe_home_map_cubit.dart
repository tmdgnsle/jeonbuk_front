import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:jeonbuk_front/api/openapis.dart';
import 'package:jeonbuk_front/model/my_safe_home_map_result.dart';

class MySafeHomeMapCubit extends Cubit<MySafeHomeMapCubitState> {
  late Dio _dio;

  MySafeHomeMapCubit()
      : super(InitMySafeHomeMapCubitState(
            mysafeHomeMapResult: MySafeHomeMapResult.init())) {
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

  Future<void> firstLoadMySafeHomeMap(
      double latitude, double longitude, double radius) async {
    try {
      var result;
      emit(FirstLoadingMySafeHomeMapCubitState(
          mysafeHomeMapResult: state.mysafeHomeMapResult));

      result = await _dio.get('/mySafeHome/', queryParameters: {
        'latitude': latitude,
        'longitude': longitude,
        'radius': radius,
      });

      print('Response received: ${result.data}');

      emit(
        LoadedMySafeHomeMapCubitState(
            mysafeHomeMapResult: MySafeHomeMapResult.fromJson(
          result.data,
          latitude,
          longitude,
          radius,
          'all',
        )),
      );
      print('현재상태: $state');
      print('loadSafeHomeFilter 실행');
      print('MySafeHomeList:');
      state.mysafeHomeMapResult.mySafeHomeMap
          .forEach((store) => print('${store.toString()}'));
    } catch (e) {
      emit(ErrorMySafeHomeMapCubitState(
          mysafeHomeMapResult: state.mysafeHomeMapResult,
          errorMessage: e.toString()));
    }
  }

  Future<void> loadMySafeHomeMapFilter(
      double latitude, double longitude, double radius, String category) async {
    try {
      var result;
      emit(LoadingMySafeHomeMapCubitState(
          mysafeHomeMapResult: state.mysafeHomeMapResult));
      if (category == 'all') {
        result = await _dio.get('/mySafeHome/', queryParameters: {
          'latitude': latitude,
          'longitude': longitude,
          'radius': radius,
        });
      } else {
        result = await _dio.get('/mySafeHome/filter', queryParameters: {
          'latitude': latitude,
          'longitude': longitude,
          'radius': radius,
          'type': category
        });
      }

      print('Response received: ${result.data}');

      emit(
        LoadedMySafeHomeMapCubitState(
            mysafeHomeMapResult: MySafeHomeMapResult.fromJson(
          result.data,
          latitude,
          longitude,
          radius,
          category,
        )),
      );
      print('현재상태: $state');
      print('loadSafeHomeFilter 실행');
      print('MySafeHomeList:');
      state.mysafeHomeMapResult.mySafeHomeMap
          .forEach((store) => print('${store.toString()}'));
    } catch (e) {
      emit(ErrorMySafeHomeMapCubitState(
          mysafeHomeMapResult: state.mysafeHomeMapResult,
          errorMessage: e.toString()));
    }
  }
}

abstract class MySafeHomeMapCubitState extends Equatable {
  final MySafeHomeMapResult mysafeHomeMapResult;

  const MySafeHomeMapCubitState({required this.mysafeHomeMapResult});
}

class InitMySafeHomeMapCubitState extends MySafeHomeMapCubitState {
  InitMySafeHomeMapCubitState(
      {required MySafeHomeMapResult mysafeHomeMapResult})
      : super(mysafeHomeMapResult: mysafeHomeMapResult);

  @override
  List<Object?> get props => [mysafeHomeMapResult];
}

class FirstLoadingMySafeHomeMapCubitState extends MySafeHomeMapCubitState {
  const FirstLoadingMySafeHomeMapCubitState(
      {required super.mysafeHomeMapResult});

  @override
  List<Object?> get props => [mysafeHomeMapResult];
}

class LoadingMySafeHomeMapCubitState extends MySafeHomeMapCubitState {
  const LoadingMySafeHomeMapCubitState({required super.mysafeHomeMapResult});

  @override
  List<Object?> get props => [mysafeHomeMapResult];
}

class LoadedMySafeHomeMapCubitState extends MySafeHomeMapCubitState {
  const LoadedMySafeHomeMapCubitState({required super.mysafeHomeMapResult});

  @override
  List<Object?> get props => [mysafeHomeMapResult];
}

class ErrorMySafeHomeMapCubitState extends MySafeHomeMapCubitState {
  String errorMessage;

  ErrorMySafeHomeMapCubitState(
      {required super.mysafeHomeMapResult, required this.errorMessage});

  @override
  List<Object?> get props => [mysafeHomeMapResult, errorMessage];
}
