import 'package:flutter/material.dart';
import 'package:wynante/core/utils/app_spacing.dart';
import 'package:wynante/core/widgets/common_background.dart';
import 'package:wynante/views/auth/sign_up/verify_sign_up/widget/widget_common_top_logocard.dart';
import 'package:wynante/views/auth/sign_up/verify_sign_up/widget/widget_premium_card.dart';

class SubscriptionView extends StatelessWidget {
  const SubscriptionView({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonBackground(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            AppSpacing.h24,
            // --- Section 1: Logo with Circular Ring ---
            const WidgetCommonTopLogocard(
              title: "Welcome to the App",
              subtitle: "Your account has been successfully verified",
            ),
            AppSpacing.h40,
            
            // Premium Cards
            WidgetPremiumCard(
              title: "Basic",
              price: "CHF 150",
              roleText: "Buyer Role Only",
              features: const [
                "Browse all live auctions",
                "Participate in live bidding",
                "Use auto-bid agent",
                "Track active & won bids",
              ],
              onSelect: () {},
            ),
            AppSpacing.h24,
            WidgetPremiumCard(
              title: "Premium",
              price: "CHF 350",
              roleText: "Buyer + Seller Role",
              isPremium: true,
              features: const [
                "Everything in Basic",
                "Create & publish auctions",
                "Set reserve & buy now prices",
                "Access performance analytics",
              ],
              onSelect: () {},
            ),
            AppSpacing.h40,
          ],
        ),
      ),
    );
  }
}
