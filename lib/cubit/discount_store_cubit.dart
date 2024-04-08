import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:jeonbuk_front/model/discount_store_result.dart';

class DiscountStoreCubit extends Cubit<DiscountStoreCubitState> {
  late Dio _dio;

  DiscountStoreCubit() : super(InitDiscountStoreCubitState()) {
    _dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8080'));
    loadDiscountStoreList();
  }

  loadDiscountStoreList() async {
    try {
      if (state is LoadingDiscountStoreCubitState ||
          state is ErrorDiscountStoreCubitState) {
        return;
      }
      print(state.discountStoreResult.currentPage);
      emit(LoadingDiscountStoreCubitState(
          discountStoreResult: state.discountStoreResult));
      var result = await _dio.get('/discountStore/list/all', queryParameters: {
        'page': state.discountStoreResult.currentPage,
      });
      await Future.delayed(Duration(milliseconds: 500));
      emit(LoadedDiscountStoreCubitState(
          discountStoreResult:
              state.discountStoreResult.copywithFromJson(result.data)));
    } catch (e) {
      emit(ErrorDiscountStoreCubitState(
          discountStoreResult: state.discountStoreResult,
          errorMessage: e.toString()));
    }
  }

  loadDiscountStoreMapCenter(double latitude, double longitude, double radius) async {
    try {
      if (state is LoadingDiscountStoreCubitState ||
          state is ErrorDiscountStoreCubitState) {
        return;
      }
      emit(LoadingDiscountStoreCubitState(
          discountStoreResult: state.discountStoreResult));
      var result = await _dio.get('/discountStore/map/all', queryParameters: {
        'latitude' : latitude,
        'longitude' : longitude,
        'radius' : radius,
      });
      await Future.delayed(Duration(milliseconds: 500));
      emit(LoadedDiscountStoreCubitState(
          discountStoreResult:
          state.discountStoreResult.copywithFromJson(result.data)));
    } catch (e) {
      emit(ErrorDiscountStoreCubitState(
          discountStoreResult: state.discountStoreResult,
          errorMessage: e.toString()));
    }
  }
}

abstract class DiscountStoreCubitState extends Equatable {
  final DiscountStoreResult discountStoreResult;

  const DiscountStoreCubitState({required this.discountStoreResult});
}

class InitDiscountStoreCubitState extends DiscountStoreCubitState {
  InitDiscountStoreCubitState()
      : super(discountStoreResult: DiscountStoreResult.init());

  @override
  List<Object?> get props => [discountStoreResult];
}

class LoadingDiscountStoreCubitState extends DiscountStoreCubitState {
  const LoadingDiscountStoreCubitState({required super.discountStoreResult});

  @override
  List<Object?> get props => [discountStoreResult];
}

class LoadedDiscountStoreCubitState extends DiscountStoreCubitState {
  const LoadedDiscountStoreCubitState({required super.discountStoreResult});

  @override
  List<Object?> get props => [discountStoreResult];
}

class ErrorDiscountStoreCubitState extends DiscountStoreCubitState {
  String errorMessage;

  ErrorDiscountStoreCubitState(
      {required super.discountStoreResult, required this.errorMessage});

  @override
  List<Object?> get props => [discountStoreResult, errorMessage];
}
