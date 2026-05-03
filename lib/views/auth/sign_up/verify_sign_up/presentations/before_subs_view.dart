import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rionydo/app_utils/utils/app_spacing.dart';
import 'package:rionydo/controllers/auth/auth_provider.dart';
import 'package:rionydo/core/widgets/common_background.dart';
import 'package:rionydo/core/widgets/widget_outlined_btn.dart';
import 'package:rionydo/views/auth/sign_up/verify_sign_up/presentations/subs_view.dart';
import 'package:rionydo/views/auth/sign_up/verify_sign_up/widget/widget_common_top_logocard.dart';
import 'package:rionydo/views/profile/widgets/logout_button.dart';

class BeforeSubsView extends StatefulWidget {
  const BeforeSubsView({super.key});

  @override
  State<BeforeSubsView> createState() => _BeforeSubsViewState();
}

class _BeforeSubsViewState extends State<BeforeSubsView> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startSubscriptionCheck();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startSubscriptionCheck() {
    // Poll subscription status every 1 minute
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) async {
      if (!mounted) return;
      final shouldCancel = await context.read<AuthProvider>().checkSubscriptionStatus(context);
      if (shouldCancel) {
        _timer?.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CommonBackground(
      child: SafeArea(
        child: Column(
          children: [
            AppSpacing.h24,
            // --- Section 1: Logo with Circular Ring ---
            const WidgetCommonTopLogocard(
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
            const Spacer(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: LogoutButton(),
            ),
          ],
        ),
      ),
    );
  }
}
