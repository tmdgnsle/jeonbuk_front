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
    return Scaffold(
      appBar: AppBar(
        title: Text('MY 설정'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('개인정보 수정'),
              SizedBox(
                height: 10,
              ),
              Text('이름'),
              CustomTextField(
                controller: nameController,
                obscure: false,
                height: 50,
                enable: modify,
              ),
              SizedBox(
                height: 10,
              ),
              Text('전화번호'),
              CustomTextField(
                controller: phoneController,
                obscure: false,
                height: 50,
                enable: modify,
              ),
              SizedBox(
                height: 10,
              ),
              Text('긴급연락망'),
              CustomTextField(
                controller: emergencyController,
                obscure: false,
                height: 50,
                enable: modify,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
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
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Text('계정'),
              SizedBox(
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
                      child: Text('로그아웃')),
                  TextButton(onPressed: () {}, child: Text('탈퇴하기')),
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
