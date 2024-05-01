import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:jeonbuk_front/model/bookmark_map.dart';

class BookmarkMapCubit extends Cubit<BookmarkMapCubitState> {
  late Dio _dio;

  BookmarkMapCubit()
      : super(
            InitBookmarkMapCubitState(bookmarkMapResult: BookmarkMap.init())) {
    _dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8080'));
  }

  Future<void> loadBookmarkMapFilter(String memberId, String category) async {
    try {
      emit(LoadingBookmarkMapCubitState(
          bookmarkMapResult: state.bookmarkMapResult));

      var result = await _dio.get('/bookmark/$memberId');

      emit(LoadedBookmarkMapCubitState(
          bookmarkMapResult: BookmarkMap.fromJson(
        result.data,
        category,
      )));
    } catch (e) {
      emit(ErrorBookmarkMapCubitState(
          bookmarkMapResult: state.bookmarkMapResult,
          errorMessage: e.toString()));
    }
  }
}

abstract class BookmarkMapCubitState extends Equatable {
  final BookmarkMap bookmarkMapResult;

  const BookmarkMapCubitState({required this.bookmarkMapResult});
}

class InitBookmarkMapCubitState extends BookmarkMapCubitState {
  InitBookmarkMapCubitState({required BookmarkMap bookmarkMapResult})
      : super(bookmarkMapResult: bookmarkMapResult);

  @override
  List<Object?> get props => [bookmarkMapResult];
}

class LoadingBookmarkMapCubitState extends BookmarkMapCubitState {
  const LoadingBookmarkMapCubitState({required super.bookmarkMapResult});

  @override
  List<Object?> get props => [bookmarkMapResult];
}

class LoadedBookmarkMapCubitState extends BookmarkMapCubitState {
  const LoadedBookmarkMapCubitState({required super.bookmarkMapResult});

  @override
  List<Object?> get props => [bookmarkMapResult];
}

class ErrorBookmarkMapCubitState extends BookmarkMapCubitState {
  String errorMessage;

  ErrorBookmarkMapCubitState(
      {required super.bookmarkMapResult, required this.errorMessage});

  @override
  List<Object?> get props => [bookmarkMapResult, errorMessage];
}
