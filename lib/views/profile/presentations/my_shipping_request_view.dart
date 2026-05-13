import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/controllers/profile/my_shipping_provider.dart';
import 'package:rionydo/core/widgets/common_background.dart';
import 'package:rionydo/core/widgets/custom_back_button.dart';
import 'package:rionydo/views/profile/widgets/shipping_request_card.dart';

class MyShippingRequestView extends StatefulWidget {
  const MyShippingRequestView({super.key});

  @override
  State<MyShippingRequestView> createState() => _MyShippingRequestViewState();
}

class _MyShippingRequestViewState extends State<MyShippingRequestView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MyShippingProvider>().fetchShippingRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CommonBackground(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const CustomBackButton(),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Shipping Requests",
              style: FontManager.titleText(
                color: Colors.white,
              ).copyWith(fontSize: 18.sp),
            ),
            Text("Track your shipments", style: FontManager.hintText()),
          ],
        ),
      ),
      child: Consumer<MyShippingProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return _buildShimmer();
          }

          if (provider.errorMessage != null) {
            return _buildError(provider.errorMessage!, provider);
          }

          final items = provider.requests;

          return RefreshIndicator(
            color: AppColors.sceTeal,
            backgroundColor: AppColors.sceCardBg,
            onRefresh: provider.fetchShippingRequests,
            child: items.isEmpty
                ? _buildEmpty()
                : ListView.builder(
                    padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                    itemCount: items.length,
                    itemBuilder: (context, index) =>
                        ShippingRequestCard(item: items[index]),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildEmpty() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: 400.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 72.w,
                height: 72.h,
                decoration: BoxDecoration(
                  color: AppColors.sceCardBg,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.07),
                  ),
                ),
                child: Icon(
                  Icons.local_shipping_outlined,
                  color: AppColors.sceTeal.withValues(alpha: 0.5),
                  size: 32.sp,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                "No shipping requests",
                style: FontManager.bodyMedium(color: Colors.white),
              ),
              SizedBox(height: 6.h),
              Text(
                "Requests will appear here after\na won auction is settled.",
                textAlign: TextAlign.center,
                style: FontManager.hintText(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildError(String message, MyShippingProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.wifi_off_rounded,
            color: AppColors.errorRed.withValues(alpha: 0.6),
            size: 40.sp,
          ),
          SizedBox(height: 12.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: FontManager.bodyMedium(color: AppColors.errorRed),
          ),
          SizedBox(height: 16.h),
          GestureDetector(
            onTap: provider.fetchShippingRequests,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColors.sceTeal.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: AppColors.sceTeal.withValues(alpha: 0.4),
                ),
              ),
              child: Text(
                "Retry",
                style: FontManager.bodyMedium(color: AppColors.sceTeal),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmer() {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
      itemCount: 5,
      itemBuilder: (context, _) => Padding(
        padding: EdgeInsets.only(bottom: 14.h),
        child: Shimmer.fromColors(
          baseColor: Colors.white.withValues(alpha: 0.05),
          highlightColor: Colors.white.withValues(alpha: 0.1),
          child: Container(
            height: 140.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
        ),
      ),
    );
  }
}
