import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:jeonbuk_front/cubit/id_jwt_cubit.dart';
import 'package:jeonbuk_front/screen/login_screen.dart';

void main() async {
  //TODO SplashScreen 만들기
  // WidgetsBinding widgetsBinding =
  WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await NaverMapSdk.instance.initialize(
      clientId: 'nf68z75anv',
      onAuthFailed: (error) {
        print('Auth failed: $error');
      });
  // FlutterNativeSplash.remove();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => IdJwtCubit(),
      child: MaterialApp(
        theme: ThemeData(
            fontFamily: 'JeonbukState_SB',
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: AppBarTheme(backgroundColor: Colors.white)),
        debugShowCheckedModeBanner: false,
        title: 'JeonBuk',
        home: const LoginScreen(),
      ),
    );
  }
}
