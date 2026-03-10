import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wynante/core/widgets/common_background.dart';
import 'package:wynante/core/assets_manager.dart';
import 'package:wynante/views/home/home_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _contentOpacity;
  late Animation<double> _dividerWidth;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000), // 3 second total splash
    );

    // Listen to animation completion to trigger navigation securely
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeView()),
          );
        }
      }
    });

    // TweenSequence for Fade In (0-30%), Hold (30-80%), Fade Out (80-100%)
    _contentOpacity = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 30.0,
      ),
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 50.0),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 20.0,
      ),
    ]).animate(_controller);

    // TweenSequence for Divider Width: Wait (0-20%), Expand (20-70%), Hold (70-100%)
    _dividerWidth = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 20.0),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 128.0,
        ).chain(CurveTween(curve: Curves.fastOutSlowIn)),
        weight: 50.0,
      ),
      TweenSequenceItem(tween: ConstantTween<double>(128.0), weight: 30.0),
    ]).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CommonBackground(
      child: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            // Apply the sequence opacity to the entire column naturally
            return Opacity(
              opacity: _contentOpacity.value,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo Image
                  Image.asset(IconAssets.app_logo, width: 286.w, height: 112.h),

                  SizedBox(height: 32.h),

                  // Animated Gradient Divider
                  Opacity(
                    opacity: 0.63,
                    child: Container(
                      width: _dividerWidth.value,
                      height: 4,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.transparent,
                            Color(0xFF0CFFE5),
                            Colors.transparent,
                          ],
                          stops: [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
