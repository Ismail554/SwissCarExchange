import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/app_utils/utils/assets_manager.dart';
import 'package:rionydo/core/widgets/common_background.dart';
import 'package:rionydo/core/widgets/custom_back_button.dart';
import 'package:rionydo/views/won_auction/widgets/won_auction_card.dart';

class WonAuctionHome extends StatelessWidget {
  const WonAuctionHome({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonBackground(
      appBar: AppBar(
        leading: const CustomBackButton(),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Won Auctions',
              style: FontManager.titleText(color: AppColors.white),
            ),
            Text(
              '3 vehicles won',
              style: FontManager.bodySmall(color: AppColors.sceGreyA0),
            ),
          ],
        ),
      ),
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        children: const [
          WonAuctionCard(
            imageUrl: ImageAssets.car1,
            title: 'Porsche 911 GT3',
            date: 'Oct 15, 2023',
            price: 'CHF 185,000',
            isPaymentCompleted: true,
          ),
          WonAuctionCard(
            imageUrl: ImageAssets.car2,
            title: 'Audi RS6 Avant',
            date: 'Oct 11, 2023',
            price: 'CHF 112,000',
            isPaymentCompleted: false,
          ),
          WonAuctionCard(
            imageUrl: ImageAssets.car3,
            title: 'Mercedes-AMG GT',
            date: 'Sep 28, 2023',
            price: 'CHF 95,000',
            isPaymentCompleted: false,
          ),
        ],
      ),
    );
  }
}
