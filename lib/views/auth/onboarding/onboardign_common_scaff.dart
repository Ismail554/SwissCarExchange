import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/views/auth/login/login_views.dart';
import 'package:rionydo/views/main_navigation/bottom_nav.dart';
import 'package:rionydo/views/home/presentation/home_view.dart';
import 'package:rionydo/views/auctions/presentations/auctions_view.dart';
import 'package:rionydo/views/bidding/presentations/bids_view.dart';
import 'package:rionydo/views/profile/profile_view.dart';

class OnboardignCommonScaff extends StatelessWidget {
  final String stepNumber;
  final String title;
  final String subtitle;
  final int currentIndex;
  final int totalSteps;
  final String nextText;
  final VoidCallback onNext;
  final VoidCallback? onSkip;

  const OnboardignCommonScaff({
    super.key,
    required this.stepNumber,
    required this.title,
    required this.subtitle,
    required this.currentIndex,
    this.totalSteps = 3,
    required this.nextText,
    required this.onNext,
    this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05080F),
      body: Stack(
        children: [
          // Top-right background glow
          Positioned(
            top: 200,
            right: -100,
            child: Transform.rotate(
              angle: -37 * math.pi / 180,
              child: _buildGlow(),
            ),
          ),

          // Bottom-left background glow
          Positioned(
            bottom: 100,
            left: -150,
            child: Transform.rotate(
              angle: -37 * math.pi / 180,
              child: _buildGlow(),
            ),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Right Skip Button
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 8.0,
                    ),
                    child: TextButton(
                      onPressed:
                          onSkip ??
                          () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginViews(),
                              ),
                            );
                          },
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFFA0AABF),
                        textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      child: const Text('Skip'),
                    ),
                  ),
                ),

                const Spacer(flex: 2),

                // Main Content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                stepNumber,
                                style: TextStyle(
                                  color: Color(0xFFD4AF37),
                                  fontSize: 64.sp,
                                  height: 1.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  height: 1.2,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                subtitle,
                                style: const TextStyle(
                                  color: Color(0xFFA0AABF),
                                  fontSize: 15,
                                  height: 1.5,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 40),
                        // Vertical Gradient Line
                        Container(
                          width: 1.5,
                          // Make sure the line extends fully, intrinsic height covers it.
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: currentIndex == 0
                                  ? const [
                                      Color(0xFFD4AF37),
                                      Colors.transparent,
                                    ]
                                  : currentIndex == 1
                                  ? const [
                                      Colors.transparent,
                                      Color(0xFFD4AF37),
                                      Colors.transparent,
                                    ]
                                  : const [
                                      Colors.transparent,
                                      Color(0xFFD4AF37),
                                    ],
                              stops: currentIndex == 0
                                  ? const [0.0, 1.0]
                                  : currentIndex == 1
                                  ? const [0.0, 0.5, 1.0]
                                  : const [0.0, 1.0],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(flex: 3),

                // Bottom Area: Indicators and Next Button
                Padding(
                  padding: const EdgeInsets.only(
                    left: 40.0,
                    right: 40.0,
                    bottom: 48.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Page Indicators
                      Row(
                        children: List.generate(totalSteps, (index) {
                          bool isActive = index == currentIndex;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.only(right: 8.0),
                            height: 4,
                            width: isActive ? 24 : 4,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? const Color(0xFFD4AF37)
                                  : const Color(0xFFFFFFFF).withOpacity(0.08),
                              borderRadius: BorderRadius.circular(2),
                              boxShadow: isActive
                                  ? [
                                      BoxShadow(
                                        color: const Color(
                                          0xFFD4AF37,
                                        ).withOpacity(0.3),
                                        blurRadius: 10,
                                        offset: const Offset(0, 0),
                                      ),
                                    ]
                                  : null,
                            ),
                          );
                        }),
                      ),

                      // Next / Enter Button
                      GestureDetector(
                        onTap: onNext,
                        behavior: HitTestBehavior.opaque,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            nextText,
                            style: const TextStyle(
                              color: Color(0xFF00D5BE),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlow() {
    return Container(
      width: 330,
      height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF25DD6C).withOpacity(0.3),
            blurRadius: 60,
            spreadRadius: 20,
          ),
          BoxShadow(
            color: const Color(0xFF2F9757).withOpacity(0.2),
            blurRadius: 100,
            spreadRadius: 40,
          ),
        ],
      ),
    );
  }
}
