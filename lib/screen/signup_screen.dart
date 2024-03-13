import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jeonbuk_front/components/custom_text_field.dart';
import 'package:jeonbuk_front/const/color.dart';
import 'package:jeonbuk_front/screen/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _idController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _passwordconfirmController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
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
            CustomTextField(
                controller: _idController,
                hintText: 'yourID',
                obscure: false,
                prefixIcons: const Icon(Icons.email_outlined),
            ),
            const SizedBox(height: 8),
            Text(
              'PASSWORD',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
            ),
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
              onPressed: () {},
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
