import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:jeonbuk_front/api/openapis.dart';
import 'package:jeonbuk_front/model/restaurant_map_result.dart';

class RestaurantMapCubit extends Cubit<RestaurantMapCubitState> {
  late Dio _dio;

  RestaurantMapCubit()
      : super(InitRestaurantMapCubitState(
            restaurantMapResult: RestaurantMapResult.init())) {
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

  Future<void> firstLoadRestaurantMap(
      double latitude, double longitude, double radius) async {
    try {
      emit(FirstLoadingRestaurantMapCubitState(
          restaurantMapResult: state.restaurantMapResult));

      var result = await _dio.get('/restaurant/map/all', queryParameters: {
        'latitude': latitude,
        'longitude': longitude,
        'radius': radius,
      });

      emit(LoadedRestaurantMapCubitState(
          restaurantMapResult: RestaurantMapResult.fromJson(
        result.data,
        latitude,
        longitude,
        radius,
        'all',
      )));
    } catch (e) {
      emit(ErrorRestaurantMapCubitState(
          restaurantMapResult: state.restaurantMapResult,
          errorMessage: e.toString()));
    }
  }

  Future<void> loadRestaurantMapFilter(
      double latitude, double longitude, double radius, String category) async {
    try {
      emit(LoadingRestaurantMapCubitState(
          restaurantMapResult: state.restaurantMapResult));

      var result =
          await _dio.get('/restaurant/map/$category', queryParameters: {
        'latitude': latitude,
        'longitude': longitude,
        'radius': radius,
      });

      emit(LoadedRestaurantMapCubitState(
          restaurantMapResult: RestaurantMapResult.fromJson(
        result.data,
        latitude,
        longitude,
        radius,
        category,
      )));
    } catch (e) {
      emit(ErrorRestaurantMapCubitState(
          restaurantMapResult: state.restaurantMapResult,
          errorMessage: e.toString()));
    }
  }
}

abstract class RestaurantMapCubitState extends Equatable {
  final RestaurantMapResult restaurantMapResult;

  const RestaurantMapCubitState({required this.restaurantMapResult});
}

class InitRestaurantMapCubitState extends RestaurantMapCubitState {
  InitRestaurantMapCubitState(
      {required RestaurantMapResult restaurantMapResult})
      : super(restaurantMapResult: restaurantMapResult);

  @override
  List<Object?> get props => [restaurantMapResult];
}

class FirstLoadingRestaurantMapCubitState extends RestaurantMapCubitState {
  const FirstLoadingRestaurantMapCubitState(
      {required super.restaurantMapResult});

  @override
  List<Object?> get props => [restaurantMapResult];
}

class LoadingRestaurantMapCubitState extends RestaurantMapCubitState {
  const LoadingRestaurantMapCubitState({required super.restaurantMapResult});

  @override
  List<Object?> get props => [restaurantMapResult];
}

class LoadedRestaurantMapCubitState extends RestaurantMapCubitState {
  const LoadedRestaurantMapCubitState({required super.restaurantMapResult});

  @override
  List<Object?> get props => [restaurantMapResult];
}

class ErrorRestaurantMapCubitState extends RestaurantMapCubitState {
  String errorMessage;

  ErrorRestaurantMapCubitState(
      {required super.restaurantMapResult, required this.errorMessage});

  @override
  List<Object?> get props => [restaurantMapResult, errorMessage];
}
