import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/app_utils/utils/app_spacing.dart';
import 'package:rionydo/core/widgets/common_background.dart';
import 'package:rionydo/core/widgets/custom_back_button.dart';
import 'package:rionydo/views/settings/presentations/chat_support_view.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportView extends StatelessWidget {
  const HelpSupportView({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonBackground(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const CustomBackButton(),
        title: Text(
          'Help & Support',
          style: FontManager.titleText(color: AppColors.white),
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(title: "CONTACT US"),
            AppSpacing.h16,
            Container(
              decoration: BoxDecoration(
                color: AppColors.sceCardBg,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Column(
                children: [
                  _ContactItem(
                    icon: Icons.chat_bubble_outline_rounded,
                    title: "Live Chat",
                    subtitle: "Chat with our support team",
                    iconColor: AppColors.sceTeal,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChatSupportView(),
                        ),
                      );
                    },
                  ),
                  Divider(color: Colors.white.withOpacity(0.05), height: 1),
                  _ContactItem(
                    icon: Icons.mail_outline_rounded,
                    title: "Email Support",
                    subtitle: "support@swisscarexchange.ch",
                    iconColor: AppColors.sceTeal,
                    onTap: () {
                      launchUrl(
                        Uri.parse("mailto:[EMAIL_ADDRESS]"),
                        mode: LaunchMode.externalApplication,
                      );
                    },
                  ),
                  Divider(color: Colors.white.withOpacity(0.05), height: 1),
                  _ContactItem(
                    icon: Icons.phone_outlined,
                    title: "Phone Support",
                    subtitle: "+41 44 123 45 67",
                    iconColor: AppColors.sceTeal,
                    onTap: () {
                      launchUrl(
                        Uri.parse("tel:+41441234567"),
                        mode: LaunchMode.externalApplication,
                      );
                    },
                  ),
                ],
              ),
            ),
            AppSpacing.h32,
            _SectionHeader(title: "FREQUENTLY ASKED QUESTIONS"),
            AppSpacing.h16,
            const _FAQItem(
              question: "How do I place a bid?",
              answer:
                  "Navigate to any active auction, review the vehicle details, and click the \"Place Bid\" button. Enter your bid amount and confirm.",
              isExpanded: true,
            ),
            AppSpacing.h12,
            const _FAQItem(
              question: "What payment methods are accepted?",
              answer:
                  "We accept Visa, Mastercard, AMEX, and direct Bank Transfers.",
            ),
            AppSpacing.h12,
            const _FAQItem(
              question: "How long do I have to complete payment?",
              answer:
                  "You typically have 3 business days to complete the payment after winning an auction.",
            ),
            AppSpacing.h12,
            const _FAQItem(
              question: "Can I cancel a bid?",
              answer:
                  "Bids are legally binding and cannot be cancelled once placed. Please check vehicle details carefully.",
            ),
            AppSpacing.h12,
            const _FAQItem(
              question: "What if I'm outbid?",
              answer:
                  "You will receive an instant notification if someone else places a higher bid.",
            ),
            AppSpacing.h32,
            _SectionHeader(title: "RESOURCES"),
            AppSpacing.h16,
            Container(
              decoration: BoxDecoration(
                color: AppColors.sceCardBg,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Column(
                children: [
                  _ResourceItem(
                    icon: Icons.description_outlined,
                    title: "Terms of Service",
                    onTap: () {},
                  ),
                  Divider(color: Colors.white.withOpacity(0.05), height: 1),
                  _ResourceItem(
                    icon: Icons.privacy_tip_outlined,
                    title: "Privacy Policy",
                    onTap: () {},
                  ),
                  Divider(color: Colors.white.withOpacity(0.05), height: 1),
                  _ResourceItem(
                    icon: Icons.menu_book_outlined,
                    title: "User Guide",
                    onTap: () {},
                  ),
                ],
              ),
            ),
            AppSpacing.h40,
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: FontManager.labelMedium(color: AppColors.sceGreyA0),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final VoidCallback onTap;

  const _ContactItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 24.sp),
            ),
            AppSpacing.w16,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: FontManager.bodyMedium(
                      color: AppColors.white,
                    ).copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    subtitle,
                    style: FontManager.bodySmall(color: AppColors.sceGrey99),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.sceGreyA0,
              size: 14.sp,
            ),
          ],
        ),
      ),
    );
  }
}

class _FAQItem extends StatefulWidget {
  final String question;
  final String answer;
  final bool isExpanded;

  const _FAQItem({
    required this.question,
    required this.answer,
    this.isExpanded = false,
  });

  @override
  State<_FAQItem> createState() => _FAQItemState();
}

class _FAQItemState extends State<_FAQItem> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.isExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.sceCardBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: _expanded,
          onExpansionChanged: (val) => setState(() => _expanded = val),
          leading: Icon(
            Icons.help_outline_rounded,
            color: AppColors.sceGreyA0,
            size: 22.sp,
          ),
          title: Text(
            widget.question,
            style: FontManager.bodyMedium(
              color: AppColors.white,
            ).copyWith(fontWeight: FontWeight.w600),
          ),
          trailing: Icon(
            _expanded
                ? Icons.keyboard_arrow_up_rounded
                : Icons.keyboard_arrow_down_rounded,
            color: AppColors.sceGreyA0,
          ),
          childrenPadding: EdgeInsets.only(
            left: 16.w,
            right: 16.w,
            bottom: 16.h,
          ),
          expandedAlignment: Alignment.topLeft,
          children: [
            Divider(color: Colors.white.withOpacity(0.05), height: 1),
            AppSpacing.h12,
            Text(
              widget.answer,
              style: FontManager.bodySmall(
                color: AppColors.sceGrey99,
              ).copyWith(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResourceItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ResourceItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Row(
          children: [
            Icon(icon, color: AppColors.sceGreyA0, size: 22.sp),
            AppSpacing.w16,
            Expanded(
              child: Text(
                title,
                style: FontManager.bodyMedium(
                  color: AppColors.white,
                ).copyWith(fontWeight: FontWeight.w500),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.sceGreyA0,
              size: 14.sp,
            ),
          ],
        ),
      ),
    );
  }
}
