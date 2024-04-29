import 'package:flutter/material.dart';
import 'package:jeonbuk_front/components/app_navigation_bar.dart';
import 'package:jeonbuk_front/components/custom_text_field.dart';
import 'package:jeonbuk_front/const/color.dart';

class AddSafeScreen extends StatefulWidget {
  const AddSafeScreen({super.key});

  @override
  State<AddSafeScreen> createState() => _AddSafeScreenState();
}

class _AddSafeScreenState extends State<AddSafeScreen> {
  final TextEditingController pathController = TextEditingController();
  final TextEditingController startController = TextEditingController();
  final TextEditingController endController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('안심귀가 추가'),
        actions: [
          TextButton(
              onPressed: () {},
              child: Text(
                '저장',
                style: TextStyle(color: BLUE_COLOR),
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('이름'),
            CustomTextField(
                controller: pathController,
                hintText: '경로 이름을 정해주세요.',
                obscure: false,
                height: 50),
            SizedBox(
              height: 10,
            ),
            Text('출발지'),
            CustomTextField(
                controller: startController,
                hintText: '주소를 정확하게 입력해주세요.',
                obscure: false,
                height: 50),
            SizedBox(
              height: 10,
            ),
            Text('도착치'),
            CustomTextField(
              controller: endController,
              hintText: '주소를 정확하게 입력해주세요.',
              obscure: false,
              height: 50,
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppNavigationBar(),
    );
  }
}
