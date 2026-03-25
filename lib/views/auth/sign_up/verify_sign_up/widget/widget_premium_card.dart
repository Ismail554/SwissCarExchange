import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:rionydo/core/constants/font_manager.dart';
import 'package:rionydo/core/utils/app_spacing.dart';
import 'package:rionydo/core/utils/app_colors.dart';

class WidgetPremiumCard extends StatelessWidget {
  final String title;
  final String price;
  final String period;
  final String roleText;
  final List<String> features;
  final bool isPremium;
  final VoidCallback onSelect;

  const WidgetPremiumCard({
    super.key,
    required this.title,
    required this.price,
    this.period = '/ month',
    required this.roleText,
    required this.features,
    this.isPremium = false,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final themeColor = isPremium ? AppColors.sceRegistrationGold : Colors.white;
    final checkColor = isPremium
        ? AppColors.sceRegistrationGold
        : AppColors.success;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.sceDarkBgAlternative.withOpacity(0.4),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isPremium
                  ? AppColors.sceRegistrationGold.withOpacity(0.3)
                  : Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: FontManager.heading3(
                          color: themeColor,
                          fontSize: 18,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            price,
                            style: FontManager.heading3(
                              color: themeColor,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            period,
                            style: FontManager.bodySmall(
                              color: Colors.white54,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  AppSpacing.h8,
                  Text(
                    roleText,
                    style: FontManager.bodySmall(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                  AppSpacing.h24,
                  ...features.map(
                    (feature) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: checkColor,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              feature,
                              style: FontManager.bodyMedium(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  AppSpacing.h16,
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: onSelect,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: isPremium
                            ? AppColors.sceRegistrationGold.withOpacity(0.1)
                            : Colors.white.withOpacity(0.05),
                        side: BorderSide(
                          color: isPremium
                              ? AppColors.sceRegistrationGold.withOpacity(0.5)
                              : Colors.white.withOpacity(0.2),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Select $title',
                        style: FontManager.labelLarge(
                          color: isPremium
                              ? const Color(0xFFE2B93B)
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (isPremium)
                Positioned(
                  top: -24,
                  right: -24,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: const BoxDecoration(
                      color: AppColors.sceRegistrationGold,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                    ),
                    child: Text(
                      'Recommended',
                      style: FontManager.labelSmall(
                        color: Colors.black,
                        fontSize: 10,
                      ).copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
