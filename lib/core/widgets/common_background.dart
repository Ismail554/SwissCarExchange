import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:wynante/core/app_colors.dart';

class CommonBackground extends StatelessWidget {
  final Widget child;
  final AppBar? appBar;
  const CommonBackground({super.key, required this.child, this.appBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar,
      backgroundColor: AppColors.sceDarkBg,
      body: Stack(
        children: [
          // Background Gradient Overlay
          Container(
            width: double.maxFinite,
            height: double.maxFinite,
            decoration: const BoxDecoration(gradient: AppColors.bgColor),
          ),

          // Blurred Glow Effect Background Sphere
          Center(
            child: Opacity(
              opacity: 0.63,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 64, sigmaY: 64),
                child: Container(
                  width: 384,
                  height: 384,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.sceTeal.withOpacity(0.1),
                  ),
                ),
              ),
            ),
          ),

          // Content
          SafeArea(child: child),
        ],
      ),
    );
  }
}
