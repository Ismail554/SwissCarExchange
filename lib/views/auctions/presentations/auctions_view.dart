import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wynante/core/font_manager.dart';
import 'package:wynante/core/widgets/common_background.dart';
import 'package:wynante/core/widgets/custom_text_field.dart';
import 'package:wynante/core/app_colors.dart';
import 'package:wynante/core/assets_manager.dart';

class AuctionsView extends StatefulWidget {
  const AuctionsView({super.key});

  @override
  State<AuctionsView> createState() => _AuctionsViewState();
}

class _AuctionsViewState extends State<AuctionsView> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = ["All", "Ending Soon", "Watched", "Upcoming"];

  @override
  Widget build(BuildContext context) {
    return CommonBackground(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: Text(
          "Auction",
          style: FontManager.heading1(color: Colors.white),
        ),
        centerTitle: false,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            // Custom search bar
            CustomTextField(
              hintText: "Search make, model...",
              prefixIcon: const Icon(Icons.search, color: AppColors.textHint),
            ),
            SizedBox(height: 20.h),
            // Filter chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_filters.length, (index) {
                  final isSelected = _selectedFilterIndex == index;
                  return Padding(
                    padding: EdgeInsets.only(right: 12.w),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedFilterIndex = index;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.sceTeal
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.sceTeal
                                : Colors.white.withOpacity(0.1),
                          ),
                        ),
                        child: Row(
                          children: [
                            if (_filters[index] == "Watched") ...[
                              Icon(
                                Icons.star_border,
                                color: AppColors.textHint,
                                size: 16.sp,
                              ),
                              SizedBox(width: 4.w),
                            ],
                            Text(
                              _filters[index],
                              style: FontManager.bodyMedium(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textHint,
                              ).copyWith(fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              "4 Auctions found",
              style: FontManager.bodyMedium(color: AppColors.textHint),
            ),
            SizedBox(height: 16.h),
            // Grid View
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.only(bottom: 20.h),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.w,
                  mainAxisSpacing: 16.h,
                  childAspectRatio: 0.58,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return _buildAuctionCard(index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuctionCard(int index) {
    // Dummy titles and prices based on the provided images
    final List<Map<String, dynamic>> dummyData = [
      {
        "title": "BMW M5 2023",
        "year": "2023",
        "currentBid": "35,700",
        "timeRemaining": "2h 12m",
        "isLive": false,
        "image": ImageAssets.car1,
      },
      {
        "title": "Audi RS6 2022",
        "year": "2022",
        "currentBid": "28,400",
        "timeRemaining": "-1h -38m",
        "isLive": true,
        "image": ImageAssets.car2,
      },
      {
        "title": "Porsche 911 Turbo",
        "year": "2023",
        "currentBid": "47,900",
        "timeRemaining": "0h 47m",
        "isLive": false,
        "image": ImageAssets.car3,
      },
      {
        "title": "Mercedes-Benz",
        "year": "2023",
        "currentBid": "42,300",
        "timeRemaining": "3h 57m",
        "isLive": false,
        "image": ImageAssets.car4,
      },
    ];

    final data = dummyData[index];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.sceCardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          Expanded(
            flex: 4,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16.r),
                    ),
                    color: Colors.white.withOpacity(0.1),
                    image: DecorationImage(
                      image: AssetImage(data['image']),
                      fit: BoxFit.cover,
                    ),
                  ),
                  width: double.infinity,
                ),
                if (data['isLive'] == true)
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: Container(
                      width: 10.w,
                      height: 10.w,
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Details Section
          Expanded(
            flex: 5,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 18.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['title'],
                        style: FontManager.bodyMedium(
                          color: Colors.white,
                        ).copyWith(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        data['year'],
                        style: FontManager.bodySmall(color: AppColors.textHint),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Current Bid",
                        style: FontManager.bodySmall(color: AppColors.textHint),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        data['currentBid'],
                        style: FontManager.heading2(
                          color: AppColors.sceTeal,
                        ).copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        data['timeRemaining'],
                        style: FontManager.bodySmall(color: AppColors.textHint),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
