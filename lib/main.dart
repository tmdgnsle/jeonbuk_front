import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:jeonbuk_front/cubit/id_jwt_cubit.dart';
import 'package:jeonbuk_front/screen/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await NaverMapSdk.instance.initialize(
      clientId: 'nf68z75anv',
      onAuthFailed: (error) {
        print('Auth failed: $error');
      });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => IdJwtCubit(),
      child: MaterialApp(
        theme: ThemeData(fontFamily: 'JeonbukState_SB'),
        debugShowCheckedModeBanner: false,
        title: 'JeonBuk',
        home: const LoginScreen(),
      ),
    );
  }
}
