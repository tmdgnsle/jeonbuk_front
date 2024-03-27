import 'package:dio/dio.dart';

class OpenApis {
  final Dio _dio = Dio();
  final String _baseUrl = 'http://10.0.2.2:8080';

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
  Future<void> registerInfo(String id, String name, String phoneNumber, String emergencyNumber) async {
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
  Future<bool> login(String id, String password) async {
    try {
      final response = await _dio.post('$_baseUrl/account/login', data: {
        'id': id,
        'password': password,
      });
      // 로그인 성공 시, true를 반환합니다.
      return response.statusCode == 200;
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
      return response.statusCode == 200;
    } catch (e) {
      // 중복 확인 과정에서 오류가 발생한 경우, 예외를 발생시킵니다.
      throw Exception('아이디 중복 확인에 실패하였습니다.\n ${e.toString()}');
    }
  }
}