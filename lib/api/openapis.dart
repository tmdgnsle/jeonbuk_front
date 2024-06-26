import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

late String jwt;

class OpenApis {
  final Dio _dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30)));
  final String _baseUrl = 'http://34.64.170.83:8080';

  OpenApis() {
    _dio.options.validateStatus = (status) {
      return status! < 500;
    };
  }

  // 회원가입 기능을 수행합니다. 사용자 아이디와 비밀번호를 서버로 전송합니다.
  Future<int> register(String id, String password, String name,
      String phoneNumber, String emergencyNumber) async {
    try {
      final response = await _dio.post('$_baseUrl/account/register', data: {
        'id': id,
        'password': password,
        'name': name,
        'phoneNumber': phoneNumber,
        'emergencyNumber': emergencyNumber,
      });
      // 회원가입 성공 시, 서버로부터 받은 회원 ID를 문자열로 반환합니다.
      return response.statusCode!.toInt();
    } catch (e) {
      // 회원가입 실패 시, 예외를 발생시킵니다.
      throw Exception('회원가입에 실패하였습니다.\n ${e.toString()}');
    }
  }



  // 로그인 기능을 수행합니다. 사용자 아이디와 비밀번호를 서버로 전송합니다.
  Future<List<String>> login(String id, String password) async {
    try {
      final response = await _dio.post('$_baseUrl/account/login', data: {
        'id': id,
        'password': password,
      });
      if (response.statusCode == 200) {
        jwt = response.headers['authorization']
            .toString()
            .replaceAll(RegExp(r'[\[\]]'), '');
        final String name = response.data['name'].toString();
        final String phoneNum = response.data['phoneNumber'].toString();
        final String emergencyNum = response.data['emergencyNumber'].toString();

        return [jwt, name, phoneNum, emergencyNum];
      } else if (response.statusCode == 401) {
        return ['login failed'];
      } else
        throw Exception('예상치 못한 오류가 발생했습니다. 상태 코드: ${response.statusCode}');
    } catch (e) {
      // 로그인 실패 시, 예외를 발생시킵니다.
      throw Exception('로그인에 실패하였습니다.\n ${e.toString()}');
    }
  }

  // 아이디 중복 확인 기능을 수행합니다. 사용자 아이디를 서버로 전송하여 중복 여부를 확인합니다.
  Future<bool> checkDuplicatedId(String id) async {
    try {
      final response = await _dio.get('$_baseUrl/account/register/$id');
      // 중복되지 않은 아이디일 경우 true를 반환합니다.
      if (response.statusCode == 200) {
        return true; // 중복되지 않음
      } else if (response.statusCode == 400) {
        return false; // 아이디 중복
      } else {
        // 다른 HTTP 상태 코드를 처리합니다.
        throw Exception('예상치 못한 오류가 발생했습니다. 상태 코드: ${response.statusCode}');
      }
    } catch (e) {
      // 그 외 예외 상황을 처리합니다.
      throw Exception('아이디 중복 확인에 실패하였습니다.\n ${e.toString()}');
    }
  }

  Future<int> modifyInformation(
      String id, String name, String phoneNum, String emergencyNum) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/account/modify',
        data: {
          'id': id,
          'name': name,
          'phoneNumber': phoneNum,
          'emergencyNumber': emergencyNum
        },
        options: Options(
          headers: {
            'Authorization': jwt,
          },
        ),
      );
      if (response.statusCode == 200) {
        return response.statusCode!.toInt();
      } else if (response.statusCode == 401) {
        return response.statusCode!.toInt();
      } else
        throw Exception('예상치 못한 오류가 발생했습니다. 상태 코드: ${response.statusCode}');
    } catch (e) {
      // 로그인 실패 시, 예외를 발생시킵니다.
      throw Exception('로그인에 실패하였습니다.\n ${e.toString()}');
    }
  }

  Future<int> deleteInformation(String memberId, String password) async {
    try {
      final response = await _dio.delete('$_baseUrl/account/delete',
          data: {'id': memberId, 'password': password},
          options: Options(
            headers: {
              'Authorization': jwt,
            },
          ));
      if (response.statusCode == 200) {
        return response.statusCode!.toInt();
      } else if (response.statusCode == 400) {
        return response.statusCode!.toInt();
      } else
        throw Exception('예상치 못한 오류가 발생했습니다. 상태 코드: ${response.statusCode}');
    } catch (e) {
      throw Exception('회원탈퇴에 실패하였습니다.\n ${e.toString()}');
    }
  }

  Future<int> findPassword(String memberId, String newPassword, String name,
      String phoneNumber, String emergencyNumber) async {
    try {
      final response =
          await _dio.post('$_baseUrl/account/password/find', data: {
        'id': memberId,
        'password': newPassword,
        'name': name,
        'phoneNumber': phoneNumber,
        'emergencyNumber': emergencyNumber,
      });
      if (response.statusCode == 200) {
        return response.statusCode!.toInt();
      } else if (response.statusCode == 400) {
        return response.statusCode!.toInt();
      } else
        throw Exception('예상치 못한 오류가 발생했습니다. 상태 코드: ${response.statusCode}');
    } catch (e) {
      throw Exception('회원탈퇴에 실패하였습니다.\n ${e.toString()}');
    }
  }

  Future<void> bookmarkStore(
      String memberId, int storeId, String bookmarkType) async {
    String? store;

    switch (bookmarkType) {
      case 'DISCOUNT_STORE':
        store = 'discountStore';
        break;
      case 'RESTAURANT':
        store = 'restaurant';
        break;
      case 'TOWN_STROLL':
        store = 'townStroll';
        break;
      case 'FESTIVAL':
        store = 'festival';
        break;
    }

    try {
      await _dio.post('$_baseUrl/$store/bookmark',
          data: {
            'memberId': memberId,
            'typeId': storeId,
            'bookmarkType': bookmarkType,
          },
          options: Options(
            headers: {
              'Authorization': jwt,
            },
          ));
    } catch (e) {
      throw Exception('즐겨찾기에 실패하였습니다. \n ${e.toString()}');
    }
  }

  Future<void> deleteBookmark(
      String memberId, int storeId, String bookmarkType) async {
    try {
      await _dio.delete('$_baseUrl/bookmark/delete',
          data: {
            'memberId': memberId,
            'typeId': storeId,
            'bookmarkType': bookmarkType,
          },
          options: Options(
            headers: {
              'Authorization': jwt,
            },
          ));
    } catch (e) {
      throw Exception('즐겨찾기 삭제에 실패하였습니다. \n ${e.toString()}');
    }
  }

  Future<int> isBookmark(
      String memberId, String bookmarkType, int storeId) async {
    try {
      final response = await _dio.get('$_baseUrl/bookmark/check',
          queryParameters: {
            'memberId': memberId,
            'bookmarkType': bookmarkType,
            'typeId': storeId,
          },
          options: Options(
            headers: {
              'Authorization': jwt,
            },
          ));

      if (response.statusCode == 200) {
        return response.data['bookmarkId'] as int; // 북마크 아이디 반환
      } else if (response.statusCode == 400) {
        return 0; // 북마크 안되어있음
      } else {
        // 다른 HTTP 상태 코드를 처리합니다.
        throw Exception('예상치 못한 오류가 발생했습니다.\n 오류: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('예상치 못한 오류가 발생했습니다.. \n ${e.toString()}');
    }
  }

  Future<List<NLatLng>> fetchRoute(NLatLng start, NLatLng end) async {
    const String appKey =
        'qNOUGsj4NV1lip9vQeZ2ea3zik85BaI85FR0duOT'; // Replace with your Tmap API Key
    var dio = Dio();
    final response = await dio.post(
      'https://apis.openapi.sk.com/tmap/routes/pedestrian?version=1&format=json',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'appKey': appKey,
        },
      ),
      data: jsonEncode({
        'startX': start.longitude.toString(),
        'startY': start.latitude.toString(),
        'endX': end.longitude.toString(),
        'endY': end.latitude.toString(),
        'reqCoordType': 'WGS84GEO',
        'resCoordType': 'WGS84GEO',
        'startName': '출발지',
        'endName': '도착지',
      }),
    );

    if (response.statusCode == 200) {
      final data = response.data;
      List<NLatLng> pathPoints = [];
      for (var feature in data['features']) {
        var geometry = feature['geometry'];
        if (geometry['type'] == 'LineString') {
          for (var coord in geometry['coordinates']) {
            double lat =
                (coord[1] is int) ? (coord[1] as int).toDouble() : coord[1];
            double lng =
                (coord[0] is int) ? (coord[0] as int).toDouble() : coord[0];
            pathPoints.add(NLatLng(lat, lng));
          }
        }
      }
      return pathPoints;
    } else {
      throw Exception('Failed to load route');
    }
  }
}
