import 'package:dio/dio.dart';

class OpenApis {
  final Dio _dio = Dio();
  final String _baseUrl = 'http://10.0.2.2:8080';

  OpenApis() {
    _dio.options.validateStatus = (status) {
      return status! < 500;
    };
  }

  // 회원가입 기능을 수행합니다. 사용자 아이디와 비밀번호를 서버로 전송합니다.
  Future<String> register(String id, String password) async {
    try {
      final response = await _dio.post('$_baseUrl/account/register', data: {
        'id': id,
        'password': password,
      });
      // 회원가입 성공 시, 서버로부터 받은 회원 ID를 문자열로 반환합니다.
      return response.data['memberId'].toString();
    } catch (e) {
      // 회원가입 실패 시, 예외를 발생시킵니다.
      throw Exception('회원가입에 실패하였습니다.\n ${e.toString()}');
    }
  }

  // 추가 정보(이름, 전화번호, 비상연락망) 등록 기능을 수행합니다.
  Future<void> registerInfo(String id, String name, String phoneNumber,
      String emergencyNumber) async {
    try {
      await _dio.post('$_baseUrl/account/register/info', data: {
        'id': id,
        'name': name,
        'phoneNumber': phoneNumber,
        'emergencyNumber': emergencyNumber,
      });
      // 정보 등록 성공 시, 별도의 반환값은 없습니다.
    } catch (e) {
      // 정보 등록 실패 시, 예외를 발생시킵니다.
      throw Exception('정보 등록에 실패하였습니다.\n ${e.toString()}');
    }
  }

  // 로그인 기능을 수행합니다. 사용자 아이디와 비밀번호를 서버로 전송합니다.
  Future<List<String>> login(String id, String password) async {
    try {
      final response = await _dio.post('$_baseUrl/account/login', data: {
        'id': id,
        'password': password,
      });
      print('response ${response.headers['authorization'].toString()}');
      if (response.statusCode == 200) {
        final String jwt = response.headers['authoriztion'].toString();
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
      print(response.statusCode);
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
      final response = await _dio.post('$_baseUrl/account/modify', data: {
        'id': id,
        'name': name,
        'phoneNumber': phoneNum,
        'emergencyNumber': emergencyNum
      });
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

  Future<int> bookmarkStore(
      String memberId, int storeId, String bookmarkType) async {
    final String store =
        (bookmarkType == 'RESTAURANT') ? 'restaurant' : 'discountStore';

    print('store: $store');

    try {
      final response = await _dio.post('$_baseUrl/$store/bookmark', data: {
        'memberId': memberId,
        'typeId': storeId,
        'bookmarkType': bookmarkType,
      });

      //TODO 에러메세지일때 반환
      print('response.data: ${response.data}');
      return response.data['bookmarkId'] as int;
    } catch (e) {
      throw Exception('즐겨찾기에 실패하였습니다. \n ${e.toString()}');
    }
  }

  Future<void> deleteBookmark(String memberId, int storeId, String bookmarkType) async {
    try {
      await _dio.delete('$_baseUrl/bookmark/delete', data: {
        'memberId': memberId,
        'typeId': storeId,
        'bookmarkType': bookmarkType,
      });
    } catch (e) {
      throw Exception('즐겨찾기 삭제에 실패하였습니다. \n ${e.toString()}');
    }
  }

  //TODO 로직 수정하기 print가 되고있지않음
  Future<int> isBookmark(
      String memberId, String bookmarkType, int storeId) async {
    try {
      final response =
          await _dio.get('$_baseUrl/bookmark/check', queryParameters: {
        'memberId': memberId,
        'bookmarkType': bookmarkType,
        'typeId': storeId,
      });
      print('response: $response');

      if (response.statusCode == 200) {
        print('북마크 아이디: ${response.data['bookmarkId'] as int}');
        return response.data['bookmarkId'] as int; // 북마크 아이디 반환
      } else if (response.statusCode == 400) {
        return 0; // 북마크 안되어있음
      } else {
        // 다른 HTTP 상태 코드를 처리합니다.
        throw Exception('예상치 못한 오류가 발생했습니다.\n 오류: ${response.toString()}');
      }
    } catch (e) {
      throw Exception('예상치 못한 오류가 발생했습니다.. \n ${e.toString()}');
    }
  }

  Future<int> SafeAdd(String memberId, String name, double startLa, double startLo, double endLa, double endLo) async{
    try{
      final response = await _dio.post('$_baseUrl/SafeHome/add', queryParameters: {
        'memberId': memberId,
        'name': name,
        'startLatitude': startLa,
        'startLongitude': startLo,
        'endLatitude': endLa,
        'endLongitude': endLo,
      });

      print(response.statusCode);

      if(response.statusCode == 200){
        return response.statusCode as int;
      } else throw Exception('안심귀가 추가 실패: ${response.toString()}');

    } catch(e){
      throw Exception('안심귀가 추가 실패: ${e.toString()}');
    }
  }
}
