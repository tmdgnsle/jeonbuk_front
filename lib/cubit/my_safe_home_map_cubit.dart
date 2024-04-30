import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:jeonbuk_front/model/my_safe_home_map_result.dart';

class MySafeHomeMapCubit extends Cubit<MySafeHomeMapCubitState> {
  late Dio _dio;

  MySafeHomeMapCubit()
      : super(InitMySafeHomeMapCubitState(
            mysafeHomeMapResult: MySafeHomeMapResult.init())) {
    _dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8080'));
  }

  Future<void> loadMySafeHomeMapFilter(
      double latitude, double longitude, double radius, String category) async {
    try {
      emit(LoadingMySafeHomeMapCubitState(
          mysafeHomeMapResult: state.mysafeHomeMapResult));

      var result = await _dio.get('/mySafeHome/', queryParameters: {
        'latitude': latitude,
        'longitude': longitude,
        'radius': radius,
      });

      emit(LoadedMySafeHomeMapCubitState(
          mysafeHomeMapResult: MySafeHomeMapResult.fromJson(
        result.data,
        latitude,
        longitude,
        radius,
        category,
      )));
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
