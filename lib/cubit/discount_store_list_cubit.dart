import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:jeonbuk_front/model/discount_store_list_result.dart';

class DiscountStoreListCubit extends Cubit<DiscountStoreListCubitState> {
  late Dio _dio;

  DiscountStoreListCubit() : super(InitDiscountStoreListCubitState()) {
    _dio = Dio(BaseOptions(
      baseUrl: 'http://34.64.170.83:8080',
      connectTimeout: Duration(seconds: 30),
      // 연결 타임아웃
      receiveTimeout: Duration(seconds: 30),
    ));
    loadDiscountStoreList();
  }

  loadDiscountStoreList() async {
    try {
      if (state is LoadingDiscountStoreListCubitState ||
          state is ErrorDiscountStoreListCubitState) {
        return;
      }
      print(state.discountStoreListResult.currentPage);
      emit(LoadingDiscountStoreListCubitState(
          discountStoreListResult: state.discountStoreListResult));
      var result = await _dio.get('/discountStore/list/all', queryParameters: {
        'page': state.discountStoreListResult.currentPage,
      });
      emit(LoadedDiscountStoreListCubitState(
          discountStoreListResult: state.discountStoreListResult
              .copywithFromJson(result.data, 'all')));
      print('DiscountStoreList:');
      state.discountStoreListResult.discountStoreList
          .forEach((store) => print('${store.toString()}'));
    } catch (e) {
      emit(ErrorDiscountStoreListCubitState(
          discountStoreListResult: state.discountStoreListResult,
          errorMessage: e.toString()));
    }
  }

  loadDiscountStoreListFilter(String category) async {
    try {
      if (state is LoadingDiscountStoreListCubitState ||
          state is ErrorDiscountStoreListCubitState) {
        return;
      }
      print(state.discountStoreListResult.currentPage);
      emit(LoadingDiscountStoreListCubitState(
          discountStoreListResult: state.discountStoreListResult));
      var result =
          await _dio.get('/discountStore/list/${category}', queryParameters: {
        'page': state.discountStoreListResult.currentPage,
      });
      emit(LoadedDiscountStoreListCubitState(
          discountStoreListResult:
              category != state.discountStoreListResult.category
                  ? state.discountStoreListResult
                      .copywithFromJsonFilter(result.data, category)
                  : state.discountStoreListResult
                      .copywithFromJson(result.data, category)));
      print('DiscountStoreList:');
      state.discountStoreListResult.discountStoreList
          .forEach((store) => print('${store.toString()}'));
    } catch (e) {
      emit(ErrorDiscountStoreListCubitState(
          discountStoreListResult: state.discountStoreListResult,
          errorMessage: e.toString()));
    }
  }

  void search(String key) async {
    try {
      if (state is LoadingDiscountStoreListCubitState ||
          state is ErrorDiscountStoreListCubitState) {
        return;
      }
      emit(LoadingDiscountStoreListCubitState(
          discountStoreListResult: state.discountStoreListResult));
      var result = await _dio
          .get('/discountStore/search', queryParameters: {'storeName': key});
      print('result: ${result.data}');
      emit(LoadedDiscountStoreListCubitState(
        discountStoreListResult:
            state.discountStoreListResult.copywithFromJsonSearch(result.data),
      ));
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
  const LoadingDiscountStoreListCubitState(
      {required super.discountStoreListResult});

  @override
  List<Object?> get props => [discountStoreListResult];
}

class LoadedDiscountStoreListCubitState extends DiscountStoreListCubitState {
  const LoadedDiscountStoreListCubitState(
      {required super.discountStoreListResult});

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
