import 'package:flutter/material.dart';
import 'package:wynante/views/auth/login/login_views.dart';
import 'package:wynante/views/home/home_view.dart';
import '../onboardign_common_scaff.dart';

class Step3Onboarding extends StatelessWidget {
  const Step3Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardignCommonScaff(
      stepNumber: '03',
      title: 'Your Competitive\nEdge',
      subtitle:
          'Access exclusive inventory before the open market. Set auto-bids, track analytics, and grow your portfolio.',
      currentIndex: 2,
      nextText: 'Enter ➔',
      onNext: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginViews()),
        );
      },
      onSkip: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginViews()),
        );
      },
    );
  }
}
