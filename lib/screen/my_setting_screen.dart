import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeonbuk_front/api/openapis.dart';
import 'package:jeonbuk_front/components/app_navigation_bar.dart';
import 'package:jeonbuk_front/components/custom_text_field.dart';
import 'package:jeonbuk_front/const/color.dart';
import 'package:jeonbuk_front/cubit/id_jwt_cubit.dart';
import 'package:jeonbuk_front/screen/login_screen.dart';

class MySettingScreen extends StatefulWidget {
  const MySettingScreen({super.key});

  @override
  State<MySettingScreen> createState() => _MySettingScreenState();
}

class _MySettingScreenState extends State<MySettingScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emergencyController = TextEditingController();

  bool modify = false;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<IdJwtCubit>(context);
    nameController.text = bloc.state.idJwt.name!;
    phoneController.text = bloc.state.idJwt.phoneNum!;
    emergencyController.text = bloc.state.idJwt.emergencyNum!;

    Widget Dialog() {
      TextEditingController idController = TextEditingController();
      TextEditingController passwordController = TextEditingController();

      return AlertDialog(
        title: const Text('회원 탈퇴'),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              controller: idController,
              hintText: '아이디(jeonbuk1234)',
              obscure: false,
              prefixIcons: const Icon(Icons.email_outlined),
              height: 50.0,
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: passwordController,
              hintText: '비밀번호',
              obscure: true,
              prefixIcons: const Icon(Icons.lock_outline),
              height: 50.0,
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('취소')),
          TextButton(
              onPressed: () async {
                final int statusCode = await OpenApis().deleteInformation(
                    idController.text, passwordController.text);
                if (statusCode == 200) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('알림'),
                          content: const Text('회원탈퇴 완료!'),
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
                                child: const Text('확인'))
                          ],
                        );
                      });
                } else if (statusCode == 400) {
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
                                child: const Text('확인'))
                          ],
                        );
                      });
                }
              },
              child: const Text('탈퇴')),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('MY 설정'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('개인정보 수정'),
              const SizedBox(
                height: 10,
              ),
              const Text('이름'),
              const SizedBox(
                height: 5,
              ),
              CustomTextField(
                controller: nameController,
                obscure: false,
                height: 50,
                enable: modify,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('전화번호'),
              const SizedBox(
                height: 5,
              ),
              CustomTextField(
                controller: phoneController,
                obscure: false,
                height: 50,
                enable: modify,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('긴급연락망'),
              const SizedBox(
                height: 5,
              ),
              CustomTextField(
                controller: emergencyController,
                obscure: false,
                height: 50,
                enable: modify,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        color: modify == false ? Colors.red : BLUE_COLOR),
                    width: 150,
                    height: 50,
                    child: InkWell(
                      onTap: () {
                        if (modify) {
                          OpenApis().modifyInformation(
                              bloc.state.idJwt.id!,
                              nameController.text,
                              phoneController.text,
                              emergencyController.text);
                          bloc.Modify(nameController.text, phoneController.text,
                              emergencyController.text);
                        }
                        setState(() {
                          modify = !modify;
                        });
                      },
                      child: Center(
                        child: Text(
                          modify == false ? '수정' : '완료',
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const Text('계정'),
              const SizedBox(
                height: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                      onPressed: () {
                        bloc.Logout();
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: const Text('로그아웃')),
                  TextButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog();
                            });
                      },
                      child: const Text('탈퇴하기')),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppNavigationBar(
        currentIndex: 3,
      ),
    );
  }
}
