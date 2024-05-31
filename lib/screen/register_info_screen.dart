import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jeonbuk_front/api/openapis.dart';
import 'package:jeonbuk_front/components/custom_text_field.dart';
import 'package:jeonbuk_front/const/color.dart';
import 'package:jeonbuk_front/screen/login_screen.dart';

class RegisterInfoScreen extends StatefulWidget {
  final String id;
  final String password;

  const RegisterInfoScreen(
      {super.key, required this.id, required this.password});

  @override
  State<RegisterInfoScreen> createState() => _RegisterInfoScreenState();
}

class _RegisterInfoScreenState extends State<RegisterInfoScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emergencyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('프로필 설정'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '이름',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
            ),
            CustomTextField(
              controller: _nameController,
              hintText: '이름을 입력하세요',
              obscure: false,
              height: 50.0,
            ),
            const SizedBox(height: 8),
            Text(
              '전화번호',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
            ),
            CustomTextField(
              controller: _phoneController,
              hintText: '본인의 전화번호를 입력하세요',
              obscure: false,
              height: 50.0,
            ),
            const SizedBox(height: 8),
            Text(
              '긴급연락망',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
            ),
            CustomTextField(
              controller: _emergencyController,
              hintText: '긴급상황시 연락이 갈 전화번호를 입력하세요.',
              obscure: false,
              height: 50.0,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                int statusCode = await OpenApis().register(
                    widget.id,
                    widget.password,
                    _nameController.text,
                    _phoneController.text,
                    _emergencyController.text);
                if (statusCode == 200) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('회원가입 성공!')),
                  );
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                    (Route<dynamic> route) => false,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('회원가입에 실패하셨습니다.')),
                  );
                }
              },
              child: Text('다음'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: BLUE_COLOR,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
