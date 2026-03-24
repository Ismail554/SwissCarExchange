import 'package:flutter/material.dart';
import 'package:rionydo/core/utils/app_spacing.dart';
import 'package:rionydo/core/widgets/common_background.dart';
import 'package:rionydo/core/widgets/widget_outlined_btn.dart';
import 'package:rionydo/views/auth/sign_up/verify_sign_up/presentations/subs_view.dart';
import 'package:rionydo/views/auth/sign_up/verify_sign_up/widget/widget_common_top_logocard.dart';

class BeforeSubsView extends StatelessWidget {
  const BeforeSubsView({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonBackground(
      child: Column(
        children: [
          AppSpacing.h24,
          // --- Section 1: Logo with Circular Ring ---
          WidgetCommonTopLogocard(
            title: "Welcome to the App",
            subtitle: "Your account has been successfully verified",
          ),
          AppSpacing.h40,
          WidgetOutlinedBtn(
            title: 'Select Your Subscription',
            icon: Icons.arrow_forward,
            themeColor: Colors.yellow[700]!,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SubscriptionView(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
