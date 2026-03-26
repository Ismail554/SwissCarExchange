import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/core/constants/font_manager.dart';
import 'package:rionydo/core/utils/app_colors.dart';
import 'package:rionydo/core/utils/app_spacing.dart';
import 'package:rionydo/core/widgets/common_background.dart';
import 'package:rionydo/core/widgets/custom_back_button.dart';
import 'package:rionydo/core/widgets/custom_button.dart';
import 'package:rionydo/views/profile/presentations/transaction_completed_view.dart';
import 'package:url_launcher/url_launcher.dart';

class AuctionContactView extends StatelessWidget {
  const AuctionContactView({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonBackground(
      appBar: AppBar(
        leading: const CustomBackButton(),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Auction Contact',
              style: FontManager.titleText(color: AppColors.white),
            ),
            Text(
              "Seller Information",
              style: FontManager.bodySmall(color: AppColors.sceGreyA0),
            ),
          ],
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 3-Day Communication Window ---
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: const Color(0xFF1E140C), // Dark brown/orange tint
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: AppColors.sceOnboardingGold.withOpacity(0.3),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: AppColors.sceOnboardingGold,
                        size: 24.sp,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '3-Day Communication Window',
                              style: FontManager.bodyMedium(
                                color: AppColors.white,
                              ).copyWith(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Contact each other to arrange payment & delivery',
                              style: FontManager.bodySmall(
                                color: AppColors.sceGreyA0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A1B0D),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '3d 0h remaining',
                          style: FontManager.heading3(
                            color: AppColors.sceOnboardingGold,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Expires on 3/13/2026',
                          style: FontManager.bodySmall(
                            color: AppColors.sceGreyA0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.h32,

            // --- CONTACT DETAILS ---
            Text(
              'CONTACT DETAILS',
              style: FontManager.labelMedium(color: AppColors.sceGreyA0),
            ),
            AppSpacing.h12,
            Container(
              decoration: BoxDecoration(
                color: AppColors.sceCardBg,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppColors.white.withOpacity(0.05)),
              ),
              child: Column(
                children: [
                  const _ContactDetailTile(
                    icon: Icons.person_outline,
                    title: 'Contact Person',
                    subtitle: 'Michael Weber',
                    isTealSubtitle: false,
                  ),
                  Divider(color: AppColors.white.withOpacity(0.05), height: 1),
                  const _ContactDetailTile(
                    icon: Icons.business_outlined,
                    title: 'Company',
                    subtitle: 'Premium Motors AG',
                    isTealSubtitle: false,
                  ),
                  Divider(color: AppColors.white.withOpacity(0.05), height: 1),
                  const _ContactDetailTile(
                    icon: Icons.email_outlined,
                    title: 'Email',
                    subtitle: 'info@premiummotors.ch',
                    isTealSubtitle: true,
                  ),
                  Divider(color: AppColors.white.withOpacity(0.05), height: 1),
                  const _ContactDetailTile(
                    icon: Icons.phone_outlined,
                    title: 'Phone',
                    subtitle: '+41 79 123 45 67',
                    isTealSubtitle: true,
                  ),
                ],
              ),
            ),
            AppSpacing.h32,

            // --- CHOOSE DELIVERY METHOD ---
            Text(
              'CHOOSE DELIVERY METHOD',
              style: FontManager.labelMedium(color: AppColors.sceGreyA0),
            ),
            AppSpacing.h12,
            const _DeliveryMethodCard(
              title: 'Shipping',
              subtitle: 'Arrange vehicle shipping with seller',
              icon: Icons.local_shipping_outlined,
              isSelected: true,
            ),
            AppSpacing.h12,
            const _DeliveryMethodCard(
              title: 'Local Pickup',
              subtitle: "Pick up vehicle at seller's location",
              icon: Icons.inventory_2_outlined,
              isSelected: false,
            ),
            AppSpacing.h32,

            // --- Buttons ---
            CustomButton(
              text: 'Call Seller',
              onPressed: () async {
                final Uri launchUri = Uri(
                  scheme: 'tel',
                  path: '+41 79 123 45 67',
                );
                if (await canLaunchUrl(launchUri)) {
                  await launchUrl(launchUri);
                }
              },
            ),
            AppSpacing.h12,
            CustomButton(
              text: 'Send Email',
              onPressed: () async {
                final Uri launchUri = Uri(
                  scheme: 'mailto',
                  path: 'info@premiummotors.ch',
                );
                if (await canLaunchUrl(launchUri)) {
                  await launchUrl(launchUri);
                }
              },
              isPrimary: false,
            ),
            AppSpacing.h12,
            Container(
              width: double.infinity,
              height: 54.h,
              decoration: BoxDecoration(
                color: const Color(0xFF0F1B1A), // Dark teal tint
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.sceTeal.withOpacity(0.3)),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12.r),
                  onTap: () {
                    // Navigate back or complete action
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TransactionCompletedView(),
                      ),
                    );
                  },
                  child: Center(
                    child: Text(
                      'Mark Shipping as Complete',
                      style: FontManager.buttonText(color: AppColors.sceTeal),
                    ),
                  ),
                ),
              ),
            ),
            AppSpacing.h40,
          ],
        ),
      ),
    );
  }
}

class _ContactDetailTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isTealSubtitle;

  const _ContactDetailTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isTealSubtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.sceTeal, size: 20.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: FontManager.bodySmall(color: AppColors.sceGreyA0),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: FontManager.bodyMedium(
                    color: isTealSubtitle ? AppColors.sceTeal : AppColors.white,
                  ).copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DeliveryMethodCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;

  const _DeliveryMethodCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.sceCardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isSelected
              ? AppColors.sceTeal
              : AppColors.white.withOpacity(0.05),
          width: isSelected ? 1.5 : 1.0,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.sceTeal.withOpacity(0.1)
                  : AppColors.white.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isSelected ? AppColors.sceTeal : AppColors.sceGreyA0,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: FontManager.bodyMedium(
                    color: AppColors.white,
                  ).copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: FontManager.bodySmall(color: AppColors.sceGreyA0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
