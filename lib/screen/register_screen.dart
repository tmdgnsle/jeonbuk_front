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
            CustomTextField(
              controller: _idController,
              hintText: '아이디(jeonbuk123)',
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
                          title: const Text('알림'),
                          content: const Text('이 아이디는 사용 가능합니다.'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('확인'),
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
                          title: const Text('알림'),
                          content: const Text('이 아이디는 사용 가능하지 않습니다.'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('확인'),
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
                child: const Text(
                  '중복확인',
                  style: TextStyle(color: BLUE_COLOR),
                ),
              ),
              height: 50.0,
            ),
            const SizedBox(height: 8),

            //TODO 사용자 비밀번호 최소 6자 이상
            CustomTextField(
              controller: _passwordController,
              hintText: '비밀번호',
              obscure: true,
              prefixIcons: const Icon(Icons.lock_outline),
              height: 50.0,
            ),
            const SizedBox(height: 8),

            CustomTextField(
              controller: _passwordconfirmController,
              hintText: '비밀번호 재입력',
              obscure: true,
              prefixIcons: const Icon(Icons.lock_outline),
              height: 50.0,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                final String? idError = validateLength(_idController.text);
                final String? passError =
                    validateLength(_passwordController.text);

                if (idError == null && passError == null) {
                  if (_passwordController.text ==
                      _passwordconfirmController.text) {
                    if (check == true) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterInfoScreen(
                                    id: _idController.text,
                                    password: _passwordController.text,
                                  )));
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('알림'),
                            content: const Text('아이디 중복체크를 하지 않았습니다.'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('확인'),
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
                          title: const Text('알림'),
                          content: const Text('비밀번호가 일치하지 않습니다.'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('확인'),
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
                        title: const Text('알림'),
                        content: Text(idError ?? passError!),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('확인'),
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
              child: const Text('다음'),
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
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) => false,
                );
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

String? validateLength(String? value) {
  if (value == null || value.isEmpty || value.length < 6) {
    return '아이디와 비밀번호는 최소 6글자 이상이어야합니다.';
  }
  return null; // The input is valid
}
