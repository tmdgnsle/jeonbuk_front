import 'package:flutter/material.dart';
import 'package:jeonbuk_front/api/openapis.dart';
import 'package:jeonbuk_front/components/custom_text_field.dart';
import 'package:jeonbuk_front/const/color.dart';
import 'package:jeonbuk_front/screen/home_screen.dart';
import 'package:jeonbuk_front/screen/login_screen.dart';
import 'package:jeonbuk_front/screen/register_screen.dart';

class FindPasswordScreen extends StatefulWidget {
  const FindPasswordScreen({super.key});

  @override
  State<FindPasswordScreen> createState() => _FindPasswordScreenState();
}

class _FindPasswordScreenState extends State<FindPasswordScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emergencyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextField(
              controller: _idController,
              hintText: '아이디(jeonbuk1234)',
              obscure: false,
              prefixIcons: const Icon(Icons.email_outlined),
              height: 50.0,
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _passwordController,
              hintText: '새로운 비밀번호',
              obscure: true,
              prefixIcons: const Icon(Icons.lock_outline),
              height: 50.0,
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _nameController,
              hintText: '이름',
              obscure: false,
              height: 50.0,
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _phoneController,
              hintText: '전화번호',
              obscure: false,
              height: 50.0,
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _emergencyController,
              hintText: '비상연락망',
              obscure: false,
              height: 50.0,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                final StatusCode = await OpenApis().findPassword(
                    _idController.text,
                    _passwordController.text,
                    _nameController.text,
                    _phoneController.text,
                    _emergencyController.text);

                if (StatusCode == 200) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('알림'),
                          content: const Text('비밀번호 변경이 완료되었습니다.'),
                          actions: <Widget>[
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen()),
                                    (Route<dynamic> route) => false,
                                  );
                                },
                                child: const Text('확인')),
                          ],
                        );
                      });
                } else if (StatusCode == 400) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('알림'),
                          content: const Text('입력하신 정보가 올바르지 않습니다.'),
                          actions: <Widget>[
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('확인')),
                          ],
                        );
                      });
                }
              },
              child: const Text('확인'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: BLUE_COLOR,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Row(
              children: <Widget>[
                Expanded(
                  child: Divider(
                    thickness: 1, // 선의 두께
                    color: Colors.grey, // 선의 색상
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  // 양쪽 여백 조절
                  child: Text("OR"),
                ),
                Expanded(
                  child: Divider(
                    thickness: 1, // 선의 두께
                    color: Colors.grey, // 선의 색상
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterScreen()));
                  },
                  child: const Text(
                    '회원가입',
                    style: TextStyle(
                      color: GREEN_COLOR,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  },
                  child: const Text(
                    '로그인',
                    style: TextStyle(
                      color: GREEN_COLOR,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
