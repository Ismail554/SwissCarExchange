import 'package:flutter/material.dart';
import 'package:wynante/views/home/presentation/home_view.dart';

import '../onboardign_common_scaff.dart';
import 'step2_onborading.dart';

class Step1Onboarding extends StatelessWidget {
  const Step1Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardignCommonScaff(
      stepNumber: '01',
      title: 'Live B2B Auctions',
      subtitle: 'Bid in real-time on verified vehicles from licensed dealers across Switzerland. Every auction is legally binding.',
      currentIndex: 0,
      nextText: 'Next ➔',
      onNext: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const Step2Onboarding()),
        );
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
