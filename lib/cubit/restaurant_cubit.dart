import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:jeonbuk_front/model/restaurant_result.dart';

class RestaurantCubit extends Cubit<RestaurantCubitState>{
  late Dio _dio;
  RestaurantCubit() : super(InitRestaurantCubitState()){
    _dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8080'));
    loadRestaurantList();
  }

  loadRestaurantList() async {
    try{
      if(state is LoadingRestaurantCubitState || state is ErrorRestaurantCubitState){
        return;
      }
      print(state.restaurantResult.currentPage);
      emit(LoadingRestaurantCubitState(restaurantResult: state.restaurantResult));
      var result = await _dio.get('/restaurant/list/all', queryParameters: {
        'page': state.restaurantResult.currentPage,
      });
      await Future.delayed(Duration(milliseconds: 500));
      emit(LoadedRestaurantCubitState(restaurantResult: state.restaurantResult.copywithFromJson(result.data)));
    } catch (e) {
      emit(ErrorRestaurantCubitState(restaurantResult: state.restaurantResult, errorMessage: e.toString()));
    }
  }
}

abstract class RestaurantCubitState extends Equatable{
  final RestaurantResult restaurantResult;
  const RestaurantCubitState({required this.restaurantResult});
}

class InitRestaurantCubitState extends RestaurantCubitState{
  InitRestaurantCubitState() : super(restaurantResult: RestaurantResult.init());

  @override
  List<Object?> get props => [restaurantResult];

}

class LoadingRestaurantCubitState extends RestaurantCubitState{
  const LoadingRestaurantCubitState({required super.restaurantResult});

  @override
  List<Object?> get props => [restaurantResult];

}

class LoadedRestaurantCubitState extends RestaurantCubitState{
  const LoadedRestaurantCubitState({required super.restaurantResult});

  @override
  List<Object?> get props => [restaurantResult];

}

class ErrorRestaurantCubitState extends RestaurantCubitState{
  String errorMessage;
  ErrorRestaurantCubitState({required super.restaurantResult, required this.errorMessage});
  @override
  List<Object?> get props => [restaurantResult, errorMessage];

}

