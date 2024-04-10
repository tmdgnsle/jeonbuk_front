import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:jeonbuk_front/model/discount_store_map_result.dart';

class DiscountStoreMapCubit extends Cubit<DiscountStoreMapCubitState> {
  late Dio _dio;

  DiscountStoreMapCubit()
      : super(InitDiscountStoreMapCubitState(discountStoreMapResult: DiscountStoreMapResult.init())) {
    _dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8080'));
  }

  Future<void> loadDiscountStoreMapFilter(double latitude, double longitude, double radius, String category) async {
    try {
      emit(LoadingDiscountStoreMapCubitState(
          discountStoreMapResult: state.discountStoreMapResult));

      var result = await _dio.get('/discountStore/map/$category', queryParameters: {
        'latitude': latitude,
        'longitude': longitude,
        'radius': radius,
      });

      emit(LoadedDiscountStoreMapCubitState(
          discountStoreMapResult: DiscountStoreMapResult.fromJson(
            result.data,
            latitude,
            longitude,
            radius,
            category,
          )));
    } catch (e) {
      emit(ErrorDiscountStoreMapCubitState(
          discountStoreMapResult: state.discountStoreMapResult,
          errorMessage: e.toString()));
    }
  }

}


abstract class DiscountStoreMapCubitState extends Equatable {
  final DiscountStoreMapResult discountStoreMapResult;

  const DiscountStoreMapCubitState({required this.discountStoreMapResult});
}

class InitDiscountStoreMapCubitState extends DiscountStoreMapCubitState {
  InitDiscountStoreMapCubitState({required DiscountStoreMapResult discountStoreMapResult})
      : super(discountStoreMapResult: discountStoreMapResult);

  @override
  List<Object?> get props => [discountStoreMapResult];
}


class LoadingDiscountStoreMapCubitState extends DiscountStoreMapCubitState {
  const LoadingDiscountStoreMapCubitState(
      {required super.discountStoreMapResult});

  @override
  List<Object?> get props => [discountStoreMapResult];
}

class LoadedDiscountStoreMapCubitState extends DiscountStoreMapCubitState {
  const LoadedDiscountStoreMapCubitState(
      {required super.discountStoreMapResult});

  @override
  List<Object?> get props => [discountStoreMapResult];
}

class ErrorDiscountStoreMapCubitState extends DiscountStoreMapCubitState {
  String errorMessage;

  ErrorDiscountStoreMapCubitState(
      {required super.discountStoreMapResult, required this.errorMessage});

  @override
  List<Object?> get props => [discountStoreMapResult, errorMessage];
}
