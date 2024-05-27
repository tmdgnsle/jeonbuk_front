import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:jeonbuk_front/api/openapis.dart';
import 'package:jeonbuk_front/model/festival_list_result.dart';

class FestivalListCubit extends Cubit<FestivalListCubitState> {
  late Dio _dio;

  FestivalListCubit() : super(InitFestivalListCubitState()) {
    _dio = Dio(BaseOptions(
      baseUrl: 'http://34.64.170.83:8080',
      connectTimeout: Duration(seconds: 30),
      // 연결 타임아웃
      receiveTimeout: Duration(seconds: 30),
      headers: {
        'Authorization': jwt,
      },
    ));
    loadFestivalList();
  }

  loadFestivalList() async {
    try {
      if (state is LoadingFestivalListCubitState ||
          state is ErrorFestivalListCubitState) {
        return;
      }
      print(state.festivalListResult.currentPage);
      emit(LoadingFestivalListCubitState(
          festivalListResult: state.festivalListResult));
      var result = await _dio.get('/festival/list/all', queryParameters: {
        'page': state.festivalListResult.currentPage,
      });
      emit(LoadedFestivalListCubitState(
          festivalListResult:
              state.festivalListResult.copywithFromJson(result.data)));
      print('FestivalList:');
      state.festivalListResult.festivalList
          .forEach((store) => print('${store.toString()}'));
    } catch (e) {
      emit(ErrorFestivalListCubitState(
          festivalListResult: state.festivalListResult,
          errorMessage: e.toString()));
    }
  }
}

abstract class FestivalListCubitState extends Equatable {
  final FestivalListResult festivalListResult;

  const FestivalListCubitState({required this.festivalListResult});
}

class InitFestivalListCubitState extends FestivalListCubitState {
  InitFestivalListCubitState()
      : super(festivalListResult: FestivalListResult.init());

  @override
  List<Object?> get props => [festivalListResult];
}

class LoadingFestivalListCubitState extends FestivalListCubitState {
  const LoadingFestivalListCubitState({required super.festivalListResult});

  @override
  List<Object?> get props => [festivalListResult];
}

class LoadedFestivalListCubitState extends FestivalListCubitState {
  const LoadedFestivalListCubitState({required super.festivalListResult});

  @override
  List<Object?> get props => [festivalListResult];
}

class ErrorFestivalListCubitState extends FestivalListCubitState {
  String errorMessage;

  ErrorFestivalListCubitState(
      {required super.festivalListResult, required this.errorMessage});

  @override
  List<Object?> get props => [festivalListResult, errorMessage];
}
