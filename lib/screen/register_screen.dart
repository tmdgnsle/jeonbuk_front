import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jeonbuk_front/api/openapis.dart';
import 'package:jeonbuk_front/components/custom_text_field.dart';
import 'package:jeonbuk_front/const/color.dart';
import 'package:jeonbuk_front/screen/login_screen.dart';
import 'package:jeonbuk_front/screen/register_info_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _idController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _passwordconfirmController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool check = false;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'ID',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
            ),
            //TODO 사용자 비밀번호 최소 6자 이상
            CustomTextField(
              controller: _idController,
              hintText: 'yourID',
              obscure: false,
              prefixIcons: const Icon(Icons.email_outlined),
              textButton: TextButton(
                onPressed: () async {
                  check =
                      await OpenApis().checkDuplicatedId(_idController.text);
                  if (check == true) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('알림'),
                          content: Text('이 아이디는 사용 가능합니다.'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('확인'),
                              onPressed: () {
                                Navigator.of(context).pop(); // 알림창 닫기
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('알림'),
                          content: Text('이 아이디는 사용 가능하지 않습니다.'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('확인'),
                              onPressed: () {
                                Navigator.of(context).pop(); // 알림창 닫기
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Text(
                  '중복확인',
                  style: TextStyle(color: BLUE_COLOR),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'PASSWORD',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
            ),
            //TODO 사용자 비밀번호 최소 6자 이상
            CustomTextField(
              controller: _passwordController,
              hintText: 'yourPassword',
              obscure: true,
              prefixIcons: const Icon(Icons.lock_outline),
            ),
            const SizedBox(height: 8),
            Text(
              'PASSWORD CONFIRM',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
            ),
            CustomTextField(
              controller: _passwordconfirmController,
              hintText: 'recheck password',
              obscure: true,
              prefixIcons: const Icon(Icons.lock_outline),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                if (_passwordController.text ==
                    _passwordconfirmController.text) {
                  if (check == true) {
                    final memberId = await OpenApis()
                        .register(_idController.text, _passwordController.text);
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('알림'),
                          content: Text('아이디 중복체크를 하지 않았습니다.'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('확인'),
                              onPressed: () {
                                Navigator.of(context).pop(); // 알림창 닫기
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('알림'),
                        content: Text('비밀번호가 일치하지 않습니다.'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('확인'),
                            onPressed: () {
                              Navigator.of(context).pop(); // 알림창 닫기
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
                Get.to(() => RegisterInfoScreen());
              },
              child: Text('다음'),
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
                  child: Text(
                    "OR",
                    style: TextStyle(fontSize: 16),
                  ),
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
            TextButton(
              onPressed: () {
                Get.to(() => LoginScreen());
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
      ),
    );
  }
}
