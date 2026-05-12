import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/app_utils/utils/app_spacing.dart';
import 'package:rionydo/core/widgets/common_background.dart';
import 'package:rionydo/core/widgets/custom_back_button.dart';
import 'package:rionydo/core/widgets/custom_button.dart';
import 'package:rionydo/views/profile/presentations/transaction_completed_view.dart';
import 'package:rionydo/controllers/auctions/dealer_contact_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AuctionContactView extends StatefulWidget {
  final String auctionId;

  const AuctionContactView({
    super.key,
    required this.auctionId,
  });

  @override
  State<AuctionContactView> createState() => _AuctionContactViewState();
}

class _AuctionContactViewState extends State<AuctionContactView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DealerContactProvider>().fetchDealerContact(widget.auctionId);
    });
  }

  Future<void> _launchPhone(String phone) async {
    final cleanPhone = phone.replaceAll(RegExp(r'\s+'), '');
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: cleanPhone,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  Future<void> _launchEmail(String email) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  Future<void> _launchWebsite(String website) async {
    String urlString = website;
    if (!urlString.startsWith('http://') && !urlString.startsWith('https://')) {
      urlString = 'https://$urlString';
    }
    final Uri launchUri = Uri.parse(urlString);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri, mode: LaunchMode.externalApplication);
    }
  }

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

            Consumer<DealerContactProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return _buildShimmerLoading();
                }

                if (provider.errorMessage != null) {
                  return _buildErrorState(provider);
                }

                final contact = provider.contactData;
                if (contact == null) {
                  return _buildEmptyState();
                }

                final detailTiles = <Widget>[];

                if (contact.company.isNotEmpty) {
                  detailTiles.add(
                    _ContactDetailTile(
                      icon: Icons.business_outlined,
                      title: 'Company',
                      subtitle: contact.company,
                      isTealSubtitle: false,
                    ),
                  );
                }

                if (contact.email.isNotEmpty) {
                  if (detailTiles.isNotEmpty) {
                    detailTiles.add(Divider(color: AppColors.white.withOpacity(0.05), height: 1));
                  }
                  detailTiles.add(
                    GestureDetector(
                      onTap: () => _launchEmail(contact.email),
                      child: _ContactDetailTile(
                        icon: Icons.email_outlined,
                        title: 'Email',
                        subtitle: contact.email,
                        isTealSubtitle: true,
                      ),
                    ),
                  );
                }

                if (contact.phone.isNotEmpty) {
                  if (detailTiles.isNotEmpty) {
                    detailTiles.add(Divider(color: AppColors.white.withOpacity(0.05), height: 1));
                  }
                  detailTiles.add(
                    GestureDetector(
                      onTap: () => _launchPhone(contact.phone),
                      child: _ContactDetailTile(
                        icon: Icons.phone_outlined,
                        title: 'Phone',
                        subtitle: contact.phone,
                        isTealSubtitle: true,
                      ),
                    ),
                  );
                }

                if (contact.address.isNotEmpty) {
                  if (detailTiles.isNotEmpty) {
                    detailTiles.add(Divider(color: AppColors.white.withOpacity(0.05), height: 1));
                  }
                  detailTiles.add(
                    _ContactDetailTile(
                      icon: Icons.location_on_outlined,
                      title: 'Address',
                      subtitle: contact.address,
                      isTealSubtitle: false,
                    ),
                  );
                }

                if (contact.website.isNotEmpty) {
                  if (detailTiles.isNotEmpty) {
                    detailTiles.add(Divider(color: AppColors.white.withOpacity(0.05), height: 1));
                  }
                  detailTiles.add(
                    GestureDetector(
                      onTap: () => _launchWebsite(contact.website),
                      child: _ContactDetailTile(
                        icon: Icons.language_outlined,
                        title: 'Website',
                        subtitle: contact.website,
                        isTealSubtitle: true,
                      ),
                    ),
                  );
                }

                if (detailTiles.isEmpty) {
                  return _buildEmptyState();
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.sceCardBg,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: AppColors.white.withOpacity(0.05)),
                      ),
                      child: Column(
                        children: detailTiles,
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

                    // --- Action Buttons ---
                    if (contact.phone.isNotEmpty) ...[
                      CustomButton(
                        text: 'Call Seller',
                        onPressed: () => _launchPhone(contact.phone),
                      ),
                      AppSpacing.h12,
                    ],
                    if (contact.email.isNotEmpty) ...[
                      CustomButton(
                        text: 'Send Email',
                        onPressed: () => _launchEmail(contact.email),
                        isPrimary: false,
                      ),
                      AppSpacing.h12,
                    ],
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
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(0.05),
      highlightColor: Colors.white.withOpacity(0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 280.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.sceCardBg,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
          AppSpacing.h32,
          Container(
            height: 20.h,
            width: 150.w,
            color: AppColors.sceCardBg,
          ),
          AppSpacing.h12,
          Container(
            height: 70.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.sceCardBg,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
          AppSpacing.h12,
          Container(
            height: 70.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.sceCardBg,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
          AppSpacing.h32,
          Container(
            height: 54.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.sceCardBg,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          AppSpacing.h12,
          Container(
            height: 54.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.sceCardBg,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(DealerContactProvider provider) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
      decoration: BoxDecoration(
        color: AppColors.sceCardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.red.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.redAccent,
            size: 48.sp,
          ),
          AppSpacing.h16,
          Text(
            provider.errorMessage ?? 'Failed to load contact information',
            style: FontManager.bodyMedium(color: AppColors.white),
            textAlign: TextAlign.center,
          ),
          AppSpacing.h24,
          SizedBox(
            width: 140.w,
            child: CustomButton(
              text: 'Retry',
              onPressed: () {
                provider.fetchDealerContact(widget.auctionId);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
      decoration: BoxDecoration(
        color: AppColors.sceCardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.white.withOpacity(0.05)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.info_outline,
            color: AppColors.sceGreyA0,
            size: 48.sp,
          ),
          AppSpacing.h16,
          Text(
            'No contact details available for this seller.',
            style: FontManager.bodyMedium(color: AppColors.sceGreyA0),
            textAlign: TextAlign.center,
          ),
        ],
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
