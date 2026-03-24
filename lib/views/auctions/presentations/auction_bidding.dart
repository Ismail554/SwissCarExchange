import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/core/constants/font_manager.dart';
import 'package:rionydo/core/utils/app_colors.dart';
import 'package:rionydo/core/widgets/custom_button.dart';
import 'package:rionydo/core/widgets/custom_back_button.dart';
import 'package:rionydo/core/widgets/widget_snackbar.dart';

class AuctionBidding extends StatefulWidget {
  final Map<String, dynamic> data;
  const AuctionBidding({super.key, required this.data});

  @override
  State<AuctionBidding> createState() => _AuctionBiddingState();
}

class _AuctionBiddingState extends State<AuctionBidding> {
  bool _isAutoBidEnabled = true;
  late int _currentBid;
  late int _userBid;
  final int _minIncrement = 150;

  @override
  void initState() {
    super.initState();
    _currentBid = int.parse(
      widget.data['currentBid'].replaceAll(RegExp(r'[^0-9]'), ''),
    );
    _userBid = _currentBid + _minIncrement;
  }

  String _formatCurrency(int amount) {
    final str = amount.toString();
    if (str.length > 3) {
      return "${str.substring(0, str.length - 3)},${str.substring(str.length - 3)}";
    }
    return str;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: CustomScrollView(
        slivers: [
          // Header image and app bar
          SliverAppBar(
            backgroundColor: AppColors.primaryColor,
            expandedHeight: 250.h,
            pinned: true,
            leading: Padding(
              padding: EdgeInsets.only(left: 16.w),
              child: Align(
                alignment: Alignment.centerLeft,
                child: const CustomBackButton(),
              ),
            ),
            leadingWidth: 64.w,
            title: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.sceGold, width: 1),
                borderRadius: BorderRadius.circular(20.r),
                color: AppColors.sceCardBg.withOpacity(0.8),
              ),
              child: Text(
                "3. LIVE BIDDING",
                style: FontManager.labelSmall(color: AppColors.sceGold),
              ),
            ),
            centerTitle: true,
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 16.w, top: 8.h, bottom: 8.h),
                child: CircleAvatar(
                  backgroundColor: AppColors.sceCardBg.withOpacity(0.8),
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
                  Container(
                    margin: EdgeInsets.only(bottom: 20.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                    ),
                    child: Image.asset(widget.data['image'], fit: BoxFit.cover),
                  ),
                  if (_isAutoBidEnabled)
                    Positioned(
                      top: 100.h,
                      left: 16.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.sceTeal,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.trending_up,
                              color: Colors.white,
                              size: 14.sp,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              "Auto Bid Enabled",
                              style: FontManager.labelSmall(
                                color: Colors.white,
                              ).copyWith(fontSize: 10.sp),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Lot Info
                  Text(
                    widget.data['title'],
                    style: FontManager.heading2(color: Colors.white),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "Lot €4557",
                    style: FontManager.bodySmall(color: AppColors.textHint),
                  ),
                  SizedBox(height: 16.h),

                  // Current Bid
                  Text(
                    "CURRENT BID",
                    style: FontManager.labelSmall(
                      color: AppColors.textHint,
                    ).copyWith(letterSpacing: 0.5),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        "CHF ",
                        style: FontManager.heading2(color: Colors.white),
                      ),
                      Text(
                        widget.data['currentBid'],
                        style: FontManager.heading1(
                          color: AppColors.sceTeal,
                        ).copyWith(fontSize: 32.sp),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Time Remaining
                  Text(
                    "TIME REMAINING",
                    style: FontManager.labelSmall(
                      color: AppColors.textHint,
                    ).copyWith(letterSpacing: 0.5),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      _buildTimeBox("00", "DAYS"),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Text(
                          ":",
                          style: FontManager.heading3(
                            color: AppColors.textHint,
                          ),
                        ),
                      ),
                      _buildTimeBox("03", "HRS"),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Text(
                          ":",
                          style: FontManager.heading3(
                            color: AppColors.textHint,
                          ),
                        ),
                      ),
                      _buildTimeBox("34", "MIN"),
                    ],
                  ),
                  SizedBox(height: 24.h),

                  // Recent Bids Header
                  Row(
                    children: [
                      Container(
                        width: 3.w,
                        height: 16.h,
                        color: AppColors.sceTeal,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "RECENT BIDS",
                        style: FontManager.labelMedium(
                          color: Colors.white,
                        ).copyWith(letterSpacing: 0.5),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),

                  // Recent Bids List
                  _buildBidTile(
                    "Anonymous 1",
                    "1 min ago",
                    "35,700",
                    const LinearGradient(colors: [Colors.purple, Colors.blue]),
                  ),
                  _buildBidTile(
                    "You",
                    "5 min ago",
                    "35,500",
                    const LinearGradient(
                      colors: [Colors.grey, Colors.blueGrey],
                    ),
                  ),
                  _buildBidTile(
                    "Anonymous 3",
                    "10 min ago",
                    "35,200",
                    const LinearGradient(colors: [Colors.orange, Colors.pink]),
                  ),
                  SizedBox(height: 24.h),

                  // Your Bid Header
                  Text(
                    "Your Bid",
                    style: FontManager.labelMedium(color: Colors.white),
                  ),
                  SizedBox(height: 12.h),

                  // Bid Input Container
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.sceCardBg,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.white.withOpacity(0.05)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "CHF",
                          style: FontManager.labelSmall(
                            color: AppColors.textHint,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatCurrency(_userBid),
                              style: FontManager.heading1(
                                color: Colors.white,
                              ).copyWith(color: Colors.white.withOpacity(0.4)),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _userBid += _minIncrement;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(8.w),
                                decoration: BoxDecoration(
                                  color: AppColors.sceTeal,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: AppColors.sceTealStatBg,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: AppColors.sceTeal.withOpacity(0.2),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Minimum bid increment: CHF 150",
                                style: FontManager.bodySmall(
                                  color: AppColors.sceTeal,
                                ).copyWith(fontSize: 11.sp),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                "Next minimum bid: CHF ${_formatCurrency(_userBid)}",
                                style: FontManager.bodySmall(
                                  color: AppColors.textHint,
                                ).copyWith(fontSize: 11.sp),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Quick Bids Header
                  Text(
                    "Quick Bids",
                    style: FontManager.labelSmall(color: AppColors.textHint),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(child: _buildQuickBidButton(150)),
                      SizedBox(width: 12.w),
                      Expanded(child: _buildQuickBidButton(300)),
                      SizedBox(width: 12.w),
                      Expanded(child: _buildQuickBidButton(500)),
                    ],
                  ),
                  SizedBox(height: 24.h),

                  // Place Bid Button
                  CustomButton(
                    text: "PLACE BID",
                    onPressed: () {
                      AppSnackBar.success(context, "Bid placed successfully!");
                    },
                  ),
                  SizedBox(height: 24.h),

                  // Auto Bid Section
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColors.sceTealStatBg.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: AppColors.sceTeal.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 24.w,
                          width: 24.w,
                          child: Checkbox(
                            value: _isAutoBidEnabled,
                            onChanged: (bool? value) {
                              setState(() {
                                _isAutoBidEnabled = value ?? false;
                              });
                            },
                            activeColor: AppColors.sceTeal,
                            checkColor: Colors.white,
                            side: BorderSide(
                              color: AppColors.sceTeal.withOpacity(0.5),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          "Enable Auto Bidding",
                          style: FontManager.labelMedium(
                            color: AppColors.sceTeal,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Max Bid Amount Container
                  if (_isAutoBidEnabled) ...[
                    SizedBox(height: 16.h),
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: AppColors.sceCardBg.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "MAXIMUM BID AMOUNT",
                            style: FontManager.labelSmall(
                              color: AppColors.sceTeal,
                            ).copyWith(letterSpacing: 0.5),
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            children: [
                              Text(
                                "CHF",
                                style: FontManager.labelLarge(
                                  color: AppColors.textHint,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 12.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Text(
                                    "36,850",
                                    style: FontManager.bodyMedium(
                                      color: AppColors.textHint,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            "System will automatically bid up to this amount in CHF 150 increments",
                            style: FontManager.bodySmall(
                              color: AppColors.textHint,
                            ).copyWith(fontSize: 12.sp),
                          ),
                        ],
                      ),
                    ),
                  ],
                  SizedBox(height: 48.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeBox(String value, String label) {
    return Container(
      width: 65.w,
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.sceCardBg,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: FontManager.heading3(
              color: Colors.white,
            ).copyWith(fontSize: 22.sp),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: FontManager.labelSmall(
              color: AppColors.textHint,
            ).copyWith(fontSize: 10.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildBidTile(
    String name,
    String time,
    String amount,
    Gradient gradient,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.sceCardBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: gradient,
            ),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: FontManager.labelMedium(color: Colors.white)),
              SizedBox(height: 2.h),
              Text(
                time,
                style: FontManager.bodySmall(
                  color: AppColors.textHint,
                ).copyWith(fontSize: 11.sp),
              ),
            ],
          ),
          const Spacer(),
          Text(amount, style: FontManager.heading3(color: AppColors.sceTeal)),
        ],
      ),
    );
  }

  Widget _buildQuickBidButton(int increment) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _userBid += increment;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        alignment: Alignment.center,
        child: Text(
          "+$increment",
          style: FontManager.labelMedium(color: Colors.white),
        ),
      ),
    );
  }
}
