import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/core/utils/app_colors.dart';
import 'package:rionydo/views/auth/sign_up/presentations/sign_up_view.dart';
import 'package:rionydo/views/auth/sign_up/verify_sign_up/presentations/before_subs_view.dart';
import 'package:rionydo/views/auth/sign_up/verify_sign_up/presentations/subs_view.dart';
import 'package:rionydo/views/auth/sign_up/verify_sign_up/presentations/pending_view.dart';
import 'package:rionydo/views/splash/splash_screen.dart';

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
            brightness: Brightness.dark,
            scaffoldBackgroundColor: AppColors.sceDarkBg,
            colorScheme: ColorScheme.dark(
              primary: AppColors.sceTeal,
              surface: AppColors.sceDarkBg,
              onSurface: AppColors.defTextColor,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              scrolledUnderElevation: 0,
              foregroundColor: AppColors.defTextColor,
            ),
            useMaterial3: true,
          ),
          home: child,
        );
      },
      child: const SplashScreen(),
    );
  }
}
