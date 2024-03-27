import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jeonbuk_front/screen/login_screen.dart';
import 'package:jeonbuk_front/screen/register_info_screen.dart';
import 'package:jeonbuk_front/screen/register_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      routes: {
        '/': (context) => LoginScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/register/info': (context) => RegisterInfoScreen(),
      },
    );
  }
}
