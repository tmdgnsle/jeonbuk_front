import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:jeonbuk_front/model/discount_store_list_result.dart';

class DiscountStoreListCubit extends Cubit<DiscountStoreListCubitState> {
  late Dio _dio;

  DiscountStoreListCubit() : super(InitDiscountStoreListCubitState()) {
    _dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8080'));
    loadDiscountStoreList('all');
  }

  loadDiscountStoreList(String category) async {
    try {
      if (state is LoadingDiscountStoreListCubitState ||
          state is ErrorDiscountStoreListCubitState) {
        return;
      }
      print(state.discountStoreListResult.currentPage);
      emit(LoadingDiscountStoreListCubitState(
          discountStoreListResult: state.discountStoreListResult));
      var result = await _dio.get('/discountStore/list/${category}', queryParameters: {
        'page': state.discountStoreListResult.currentPage,
      });
      emit(LoadedDiscountStoreListCubitState(
          discountStoreListResult:
              state.discountStoreListResult.copywithFromJson(result.data, category)));
    } catch (e) {
      emit(ErrorDiscountStoreListCubitState(
          discountStoreListResult: state.discountStoreListResult,
          errorMessage: e.toString()));
    }
  }

}

abstract class DiscountStoreListCubitState extends Equatable {
  final DiscountStoreListResult discountStoreListResult;

  const DiscountStoreListCubitState({required this.discountStoreListResult});
}

class InitDiscountStoreListCubitState extends DiscountStoreListCubitState {
  InitDiscountStoreListCubitState()
      : super(discountStoreListResult: DiscountStoreListResult.init());

  @override
  List<Object?> get props => [discountStoreListResult];
}

class LoadingDiscountStoreListCubitState extends DiscountStoreListCubitState {
  const LoadingDiscountStoreListCubitState({required super.discountStoreListResult});

  @override
  List<Object?> get props => [discountStoreListResult];
}

class LoadedDiscountStoreListCubitState extends DiscountStoreListCubitState {
  const LoadedDiscountStoreListCubitState({required super.discountStoreListResult});

  @override
  List<Object?> get props => [discountStoreListResult];
}

class ErrorDiscountStoreListCubitState extends DiscountStoreListCubitState {
  String errorMessage;

  ErrorDiscountStoreListCubitState(
      {required super.discountStoreListResult, required this.errorMessage});

  @override
  List<Object?> get props => [discountStoreListResult, errorMessage];
}
