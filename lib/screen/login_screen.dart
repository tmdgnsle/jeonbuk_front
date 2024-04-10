import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeonbuk_front/api/openapis.dart';
import 'package:jeonbuk_front/components/custom_text_field.dart';
import 'package:jeonbuk_front/const/color.dart';
import 'package:get/get.dart';
import 'package:jeonbuk_front/cubit/id_jwt_cubit.dart';
import 'package:jeonbuk_front/screen/home_screen.dart';
import 'package:jeonbuk_front/screen/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _idController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

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
                hintText: 'yourID',
                obscure: false,
                prefixIcons: const Icon(Icons.email_outlined)),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _passwordController,
              hintText: 'yourPassword',
              obscure: true,
              prefixIcons: const Icon(Icons.lock_outline),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                final loginJwt = await OpenApis()
                    .login(_idController.text, _passwordController.text);

                if (loginJwt != 'login failed') {
                  final bloc = BlocProvider.of<IdJwtCubit>(context);
                  bloc.Login(
                      IdJwtCubitState.login, _idController.text, loginJwt);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()));
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('알림'),
                        content: Text('아이디 혹은 비밀번호가 틀렸습니다.'),
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
              child: Text('로그인'),
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
            Row(
              children: <Widget>[
                Expanded(
                  child: Divider(
                    thickness: 1, // 선의 두께
                    color: Colors.grey, // 선의 색상
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
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
          ],
        ),
      ),
    );
  }
}
