import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:jeonbuk_front/model/town_stroll_map_result.dart';

class TownStrollMapCubit extends Cubit<TownStrollMapCubitState> {
  late Dio _dio;

  TownStrollMapCubit()
      : super(InitTownStrollMapCubitState(
            townStrollMapResult: TownStrollMapResult.init())) {
    _dio = Dio(BaseOptions(
      baseUrl: 'http://34.64.170.83:8080',
      connectTimeout: Duration(seconds: 30),
      // 연결 타임아웃
      receiveTimeout: Duration(seconds: 30),
    ));
  }

  Future<void> firstLoadTownStrollMap(double latitude, double longitude, double radius) async {
    try {
      emit(FirstLoadingTownStrollMapCubitState(
          townStrollMapResult: state.townStrollMapResult));

      var result = await _dio.get('/townStroll/map/all', queryParameters: {
        'latitude': latitude,
        'longitude': longitude,
        'radius': radius,
      });

      emit(LoadedTownStrollMapCubitState(
          townStrollMapResult: TownStrollMapResult.fromJson(
            result.data,
            latitude,
            longitude,
            radius,
          )));

    } catch (e) {
      emit(ErrorTownStrollMapCubitState(
          townStrollMapResult: state.townStrollMapResult,
          errorMessage: e.toString()));
    }
  }

  Future<void> loadTownStrollMap(
      double latitude, double longitude, double radius) async {
    try {
      emit(LoadingTownStrollMapCubitState(
          townStrollMapResult: state.townStrollMapResult));

      var result = await _dio.get('/townStroll/map/all', queryParameters: {
        'latitude': latitude,
        'longitude': longitude,
        'radius': radius,
      });

      emit(LoadedTownStrollMapCubitState(
          townStrollMapResult: TownStrollMapResult.fromJson(
        result.data,
        latitude,
        longitude,
        radius,
      )));
      print('DiscountStoreList:');
      state.townStrollMapResult.townStrollMap
          .forEach((store) => print('${store.toString()}'));
    } catch (e) {
      emit(ErrorTownStrollMapCubitState(
          townStrollMapResult: state.townStrollMapResult,
          errorMessage: e.toString()));
    }
  }
}

abstract class TownStrollMapCubitState extends Equatable {
  final TownStrollMapResult townStrollMapResult;

  const TownStrollMapCubitState({required this.townStrollMapResult});
}

class InitTownStrollMapCubitState extends TownStrollMapCubitState {
  InitTownStrollMapCubitState(
      {required TownStrollMapResult townStrollMapResult})
      : super(townStrollMapResult: townStrollMapResult);

  @override
  List<Object?> get props => [townStrollMapResult];
}

class FirstLoadingTownStrollMapCubitState extends TownStrollMapCubitState {
  const FirstLoadingTownStrollMapCubitState({required super.townStrollMapResult});

  @override
  List<Object?> get props => [townStrollMapResult];
}

class LoadingTownStrollMapCubitState extends TownStrollMapCubitState {
  const LoadingTownStrollMapCubitState({required super.townStrollMapResult});

  @override
  List<Object?> get props => [townStrollMapResult];
}

class LoadedTownStrollMapCubitState extends TownStrollMapCubitState {
  const LoadedTownStrollMapCubitState({required super.townStrollMapResult});

  @override
  List<Object?> get props => [townStrollMapResult];
}

class ErrorTownStrollMapCubitState extends TownStrollMapCubitState {
  String errorMessage;

  ErrorTownStrollMapCubitState(
      {required super.townStrollMapResult, required this.errorMessage});

  @override
  List<Object?> get props => [townStrollMapResult, errorMessage];
}
