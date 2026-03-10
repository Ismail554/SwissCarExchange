import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:wynante/core/app_colors.dart';

class CommonBackground extends StatelessWidget {
  final Widget child;

  const CommonBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Stack(
        children: [
          // Background Gradient Overlay
          Container(
            width: double.infinity,
            height: double.infinity,
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
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromRGBO(0, 187, 167, 0.1),
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
