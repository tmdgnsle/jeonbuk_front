import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:jeonbuk_front/cubit/id_jwt_cubit.dart';
import 'package:jeonbuk_front/firebase_options.dart';
import 'package:jeonbuk_front/screen/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('Flutter Error: ${details.exceptionAsString()}');
  };

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print('firebase 연결');

  await NaverMapSdk.instance.initialize(
      clientId: 'nf68z75anv',
      onAuthFailed: (error) {
        print('Auth failed: $error');
      });
  runZonedGuarded(() {
    runApp(MyApp());
  }, (error, stackTrace) {
    debugPrint('Uncaught Error: $error');
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => IdJwtCubit(),
      child: MaterialApp(
        theme: ThemeData(
            fontFamily: 'JeonbukState_SB',
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(backgroundColor: Colors.white)),
        debugShowCheckedModeBanner: false,
        title: 'JeonBuk',
        home: const LoginScreen(),
        navigatorObservers: <NavigatorObserver>[observer],
      ),
    );
  }
}
