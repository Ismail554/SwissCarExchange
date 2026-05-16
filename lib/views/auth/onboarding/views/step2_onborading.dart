import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../onboardign_common_scaff.dart';

class Step2Onboarding extends StatelessWidget {
  const Step2Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardignCommonScaff(
      stepNumber: '02',
      title: 'Swiss Precision\nTrading',
      subtitle:
          'Transparent pricing, verified histories, and secure transactions — built to the standards you expect.',
      currentIndex: 1,
      nextText: 'Next ➔',
      onNext: () {
        context.go('/onboarding/step3');
      },
      // onSkip: () {
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(builder: (_) => const HomeView()),
      //   );
      // },
    );
  }
}
