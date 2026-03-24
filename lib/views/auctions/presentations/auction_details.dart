import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wynante/core/font_manager.dart';
import 'package:wynante/core/app_colors.dart';
import 'package:wynante/core/widgets/custom_button.dart';
import 'package:wynante/views/auctions/presentations/auction_bidding.dart';

class AuctionDetails extends StatelessWidget {
  final Map<String, dynamic> data;
  const AuctionDetails({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Image Header with Title Overlay
              SliverAppBar(
                backgroundColor: AppColors.primaryColor,
                expandedHeight: 300.h,
                pinned: true,
                leading: Padding(
                  padding: EdgeInsets.only(left: 16.w, top: 8.h, bottom: 8.h),
                  child: CircleAvatar(
                    backgroundColor: Colors.black45,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: EdgeInsets.only(
                      right: 16.w,
                      top: 8.h,
                      bottom: 8.h,
                    ),
                    child: CircleAvatar(
                      backgroundColor: Colors.black45,
                      child: IconButton(
                        icon: const Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Placeholder styling for Image
                      Container(
                        color: Colors.white.withOpacity(0.1),
                        child: Image.asset(data['image'], fit: BoxFit.cover),
                      ),
                      // Gradient overlay at bottom for text
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 120.h,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.9),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Title Text overlay
                      Positioned(
                        bottom: 16.h,
                        left: 16.w,
                        right: 16.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['title'],
                              style: FontManager.displaySmall(
                                color: Colors.white,
                              ).copyWith(fontSize: 24.sp),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              "Lot €4557 • 12 Gebote",
                              style: FontManager.bodyMedium(
                                color: AppColors.textHint,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Scrollable Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 24.h),

                      // Current Bid Container
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: AppColors.sceTealStatBg,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: AppColors.sceTeal.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "AKTUELLES HÖCHSTGEBOT",
                              style: FontManager.labelSmall(
                                color: AppColors.sceTeal,
                              ).copyWith(letterSpacing: 1.2),
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  "CHF ",
                                  style: FontManager.heading1(
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  data['currentBid'],
                                  style: FontManager.heading1(
                                    color: AppColors.sceTeal,
                                  ).copyWith(fontSize: 32.sp),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24.h),
                      Text(
                        "Fahrzeugdaten",
                        style: FontManager.heading3(color: Colors.white),
                      ),
                      SizedBox(height: 16.h),

                      // Adaptive Grid for Vehicle Data
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 12.h,
                        crossAxisSpacing: 12.w,
                        childAspectRatio: 2.2,
                        children: [
                          _buildDataCard(
                            Icons.calendar_today_outlined,
                            "Baujahr",
                            data['year'],
                          ),
                          _buildDataCard(
                            Icons.speed_outlined,
                            "Kilometerstand",
                            "45,000 km",
                          ),
                          _buildDataCard(
                            Icons.local_gas_station_outlined,
                            "Kraftstoff",
                            "Benzin",
                          ),
                          _buildDataCard(
                            Icons.location_on_outlined,
                            "Standort",
                            "Zürich, CH",
                          ),
                        ],
                      ),

                      SizedBox(height: 24.h),
                      Text(
                        "Beschreibung",
                        style: FontManager.heading3(color: Colors.white),
                      ),
                      SizedBox(height: 16.h),

                      // Description Card
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: AppColors.sceCardBg,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.05),
                          ),
                        ),
                        child: Text(
                          "Dieser BMW M5 2023 befindet sich in hervorragendem Zustand. Das Fahrzeug wurde regelmäßig gewartet und verfügt über eine vollständige Servicehistorie. Alle wichtigen Komponenten sind in einwandfreiem Zustand.",
                          style: FontManager.bodyMedium(
                            color: AppColors.textHint,
                          ).copyWith(height: 1.5),
                        ),
                      ),
                      SizedBox(height: 100.h), // Space for bottom button
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Bottom Sticky Button
          Positioned(
            bottom: 14.h,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(16.w).copyWith(bottom: 24.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.primaryColor,
                    AppColors.primaryColor.withOpacity(0.0),
                  ],
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50.h,
                child: CustomButton(
                  text: "JETZT BIETEN",
                  // Override default color if CustomButton supports it, else wrap nicely
                  // Assuming AppColors.sceTeal is needed for background
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AuctionBidding(data: data),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataCard(IconData icon, String subtitle, String value) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.sceCardBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.sceTeal, size: 16.sp),
              SizedBox(width: 6.w),
              Text(
                subtitle,
                style: FontManager.bodySmall(
                  color: AppColors.textHint,
                ).copyWith(fontSize: 12.sp),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: FontManager.bodyMedium(
              color: Colors.white,
            ).copyWith(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
