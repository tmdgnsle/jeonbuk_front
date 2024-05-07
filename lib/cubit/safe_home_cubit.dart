import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:jeonbuk_front/model/safe_home_list_result.dart';

class SafeHomeCubit extends Cubit<SafeHomeCubitState> {
  late Dio _dio;

  SafeHomeCubit() : super(InitSafeHomeCubitState()) {
    _dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8080'));
  }

  loadSafeHomeList(String memberId) async {
    try {
      if (state is LoadingSafeHomeCubitState ||
          state is ErrorSafeHomeCubitState) {
        return;
      }
      emit(LoadingSafeHomeCubitState(
          safeHomeListResult: state.safeHomeListResult));
      var result = await _dio.get('/SafeHome/list', queryParameters: {
        'memberId': memberId,
      });
      emit(LoadedSafeHomeCubitState(safeHomeListResult: result.data));
    } catch (e) {
      emit(ErrorSafeHomeCubitState(
          safeHomeListResult: state.safeHomeListResult,
          errorMessage: e.toString()));
    }
  }
}

abstract class SafeHomeCubitState extends Equatable {
  final SafeHomeListResult safeHomeListResult;

  SafeHomeCubitState({required this.safeHomeListResult});
}

class InitSafeHomeCubitState extends SafeHomeCubitState {
  InitSafeHomeCubitState()
      : super(safeHomeListResult: SafeHomeListResult.init());

  @override
  List<Object?> get props => [safeHomeListResult];
}

class LoadingSafeHomeCubitState extends SafeHomeCubitState {
  LoadingSafeHomeCubitState({required super.safeHomeListResult});

  @override
  List<Object?> get props => [safeHomeListResult];
}

class LoadedSafeHomeCubitState extends SafeHomeCubitState {
  LoadedSafeHomeCubitState({required super.safeHomeListResult});

  @override
  List<Object?> get props => [safeHomeListResult];
}

class ErrorSafeHomeCubitState extends SafeHomeCubitState {
  String errorMessage;

  ErrorSafeHomeCubitState(
      {required super.safeHomeListResult, required this.errorMessage});

  @override
  List<Object?> get props => [safeHomeListResult, errorMessage];
}
