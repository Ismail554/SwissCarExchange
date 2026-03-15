import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wynante/core/app_colors.dart';
import 'package:wynante/views/auth/sign_up/verify_sign_up/presentations/before_subs_view.dart';
import 'package:wynante/views/auth/sign_up/verify_sign_up/presentations/subs_view.dart';
import 'package:wynante/views/auth/sign_up/verify_sign_up/presentations/pending_view.dart';
import 'package:wynante/views/splash/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(402, 851),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Swiss Car Exchange',
          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.white,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
            primarySwatch: Colors.blue,
          ),
          home: child,
        );
      },
      child: const BeforeSubsView(),
    );
  }
}
