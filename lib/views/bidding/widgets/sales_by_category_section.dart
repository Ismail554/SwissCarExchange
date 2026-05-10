import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/controllers/premium_analytics_provider.dart';
import 'package:rionydo/models/premium/premium_analytics_response.dart';

class SalesByCategorySection extends StatelessWidget {
  const SalesByCategorySection({super.key});

  static const _barColors = [
    AppColors.sceTeal,
    AppColors.sceGold,
    AppColors.scePremiumOrange,
    AppColors.blue,
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PremiumAnalyticsProvider>();

    // If not loading, no error, and there is no category data, don't show the section.
    if (!provider.isLoading &&
        provider.error == null &&
        (provider.salesByCategory == null ||
            provider.salesByCategory!.results.isEmpty)) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.sceChartBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.grey.withOpacity(0.15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'SALES BY CATEGORY',
                  style: FontManager.labelSmall(color: AppColors.grey),
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.scePremiumGold,
                        AppColors.scePremiumOrange,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'PREMIUM',
                    style: FontManager.labelSmall(
                      color: AppColors.black,
                    ).copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            if (provider.isLoading)
              const _CategorySkeleton()
            else if (provider.error != null)
              _ErrorState(message: provider.error!)
            else
              ...provider.salesByCategory!.results.asMap().entries.map((e) {
                final color = _barColors[e.key % _barColors.length];
                return _CategoryBar(result: e.value, barColor: color);
              }),
          ],
        ),
      ),
    );
  }
}

class _CategoryBar extends StatelessWidget {
  final CategoryResult result;
  final Color barColor;

  const _CategoryBar({required this.result, required this.barColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  result.categoryLabel,
                  style: FontManager.heading2(color: AppColors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                '${result.count} (${result.percentage.toStringAsFixed(1)}%)',
                style: FontManager.labelSmall(color: AppColors.grey),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          LayoutBuilder(
            builder: (context, constraints) {
              final fraction = (result.percentage / 100).clamp(0.0, 1.0);
              return Stack(
                children: [
                  Container(
                    height: 6.h,
                    width: constraints.maxWidth,
                    decoration: BoxDecoration(
                      color: AppColors.grey.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOut,
                    height: 6.h,
                    width: constraints.maxWidth * fraction,
                    decoration: BoxDecoration(
                      color: barColor,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: barColor.withOpacity(0.4),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CategorySkeleton extends StatelessWidget {
  const _CategorySkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        4,
        (_) => Padding(
          padding: EdgeInsets.only(bottom: 14.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 12.h,
                width: 120.w,
                decoration: BoxDecoration(
                  color: AppColors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(height: 6.h),
              Container(
                height: 6.h,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: AppColors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Text(
          message,
          style: FontManager.heading2(color: AppColors.errorRed),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

