import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:jeonbuk_front/model/restaurant_map_result.dart';

class RestaurantMapCubit extends Cubit<RestaurantMapCubitState> {
  late Dio _dio;

  RestaurantMapCubit()
      : super(InitRestaurantMapCubitState(
      restaurantMapResult: RestaurantMapResult.init())) {
    _dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8080'));
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

class LoadingRestaurantMapCubitState extends RestaurantMapCubitState {
  const LoadingRestaurantMapCubitState(
      {required super.restaurantMapResult});

  @override
  List<Object?> get props => [restaurantMapResult];
}

class LoadedRestaurantMapCubitState extends RestaurantMapCubitState {
  const LoadedRestaurantMapCubitState(
      {required super.restaurantMapResult});

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
