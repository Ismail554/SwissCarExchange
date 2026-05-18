import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/app_router.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';

class PlatformUtils {
  static bool get isIOS =>
      foundation.defaultTargetPlatform == TargetPlatform.iOS;
  static bool get isAndroid =>
      foundation.defaultTargetPlatform == TargetPlatform.android;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(402, 851),
      builder: (context, child) {
        return MaterialApp.router(
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
          routerConfig: appRouter,
        );
      },
    );
  }
}
