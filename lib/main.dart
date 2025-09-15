import 'package:flutter/material.dart';
import 'package:koin/user/login_screen.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Pretendard',
      ),
      debugShowCheckedModeBanner: false,
      // 앱의 첫 화면을 SplashScreenWrapper로 지정
      home: const SplashScreenWrapper(),
    ),
  );
}
