import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
        context.go('/login');
      },
      //   onSkip: () {
      //     Navigator.pushReplacement(
      //       context,
      //       MaterialPageRoute(builder: (_) => const LoginViews()),
      //     );
      //   },
    );
  }
}
