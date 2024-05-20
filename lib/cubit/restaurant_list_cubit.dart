import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:jeonbuk_front/model/restaurant_list_result.dart';

class RestaurantListCubit extends Cubit<RestaurantListCubitState> {
  late Dio _dio;

  RestaurantListCubit() : super(InitRestaurantListCubitState()) {
    _dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8080'));
    loadRestaurantList();
  }

  loadRestaurantList() async {
    try {
      if (state is LoadingRestaurantListCubitState ||
          state is ErrorRestaurantListCubitState) {
        return;
      }
      print(state.restaurantListResult.currentPage);
      emit(LoadingRestaurantListCubitState(
          restaurantListResult: state.restaurantListResult));
      var result = await _dio.get('/restaurant/list/all', queryParameters: {
        'page': state.restaurantListResult.currentPage,
      });
      emit(LoadedRestaurantListCubitState(
          restaurantListResult:
              state.restaurantListResult.copywithFromJson(result.data, 'all')));
      print('RestaurantList:');
      state.restaurantListResult.restaurantList
          .forEach((store) => print('${store.toString()}'));
    } catch (e) {
      emit(ErrorRestaurantListCubitState(
          restaurantListResult: state.restaurantListResult,
          errorMessage: e.toString()));
    }
  }

  loadRestaurantListFilter(String category) async {
    try {
      if (state is LoadingRestaurantListCubitState ||
          state is ErrorRestaurantListCubitState) {
        return;
      }
      print(state.restaurantListResult.currentPage);
      emit(LoadingRestaurantListCubitState(
          restaurantListResult: state.restaurantListResult));
      var result =
          await _dio.get('/restaurant/list/${category}', queryParameters: {
        'page': state.restaurantListResult.currentPage,
      });
      emit(LoadedRestaurantListCubitState(
          restaurantListResult: category != state.restaurantListResult.category
              ? state.restaurantListResult
                  .copywithFromJsonFilter(result.data, category)
              : state.restaurantListResult
                  .copywithFromJson(result.data, category)));
      print('RestaurantList:');
      state.restaurantListResult.restaurantList
          .forEach((store) => print('${store.toString()}'));
    } catch (e) {
      emit(ErrorRestaurantListCubitState(
          restaurantListResult: state.restaurantListResult,
          errorMessage: e.toString()));
    }
  }

  void search(String key) async {
    try {
      if (state is LoadingRestaurantListCubitState ||
          state is ErrorRestaurantListCubitState) {
        return;
      }
      emit(LoadingRestaurantListCubitState(
          restaurantListResult: state.restaurantListResult));
      var result = await _dio
          .get('/restaurant/search', queryParameters: {'storeName': key});
      print('result: ${result.data}');
      emit(LoadedRestaurantListCubitState(
        restaurantListResult:
            state.restaurantListResult.copywithFromJsonSearch(result.data),
      ));
    } catch (e) {
      emit(ErrorRestaurantListCubitState(
          restaurantListResult: state.restaurantListResult,
          errorMessage: e.toString()));
    }
  }
}

abstract class RestaurantListCubitState extends Equatable {
  final RestaurantListResult restaurantListResult;

  const RestaurantListCubitState({required this.restaurantListResult});
}

class InitRestaurantListCubitState extends RestaurantListCubitState {
  InitRestaurantListCubitState()
      : super(restaurantListResult: RestaurantListResult.init());

  @override
  List<Object?> get props => [restaurantListResult];
}

class LoadingRestaurantListCubitState extends RestaurantListCubitState {
  const LoadingRestaurantListCubitState({required super.restaurantListResult});

  @override
  List<Object?> get props => [restaurantListResult];
}

class LoadedRestaurantListCubitState extends RestaurantListCubitState {
  const LoadedRestaurantListCubitState({required super.restaurantListResult});

  @override
  List<Object?> get props => [restaurantListResult];
}

class ErrorRestaurantListCubitState extends RestaurantListCubitState {
  String errorMessage;

  ErrorRestaurantListCubitState(
      {required super.restaurantListResult, required this.errorMessage});

  @override
  List<Object?> get props => [restaurantListResult, errorMessage];
}
