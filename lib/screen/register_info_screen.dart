import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jeonbuk_front/api/openapis.dart';
import 'package:jeonbuk_front/components/custom_text_field.dart';
import 'package:jeonbuk_front/const/color.dart';
import 'package:jeonbuk_front/screen/login_screen.dart';

class RegisterInfoScreen extends StatefulWidget {

  final String? id;

  const RegisterInfoScreen({super.key, this.id,});

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
              hintText: '이름을 적어주세요',
              obscure: false,
            ),
            const SizedBox(height: 8),
            Text(
              '핸드폰',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
            ),
            CustomTextField(
              controller: _phoneController,
              hintText: '전화번호를 적어주세요',
              obscure: false,
            ),
            const SizedBox(height: 8),
            Text(
              '긴급 연락망',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
            ),
            CustomTextField(
              controller: _emergencyController,
              hintText: '전화번호를 적어주세요',
              obscure: false,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async{
                await OpenApis().registerInfo(widget.id!, _nameController.text, _phoneController.text, _emergencyController.text);
                Get.to(() => LoginScreen());
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
