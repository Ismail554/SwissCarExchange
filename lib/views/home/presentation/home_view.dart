import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rionydo/core/utils/app_colors.dart';
import 'package:rionydo/core/utils/app_spacing.dart';
import 'package:rionydo/core/utils/assets_manager.dart';
import 'package:rionydo/core/constants/global_state.dart';
import 'package:rionydo/core/widgets/common_background.dart';
import 'package:rionydo/core/constants/font_manager.dart';
import 'package:rionydo/core/widgets/custom_button.dart';
import 'package:rionydo/views/home/widgets/auction_card.dart';
import 'package:rionydo/views/home/widgets/notification_badge.dart';
import 'package:rionydo/views/home/widgets/premium_dealer_card.dart';
import 'package:rionydo/views/home/widgets/section_header.dart';
import 'package:rionydo/views/home/widgets/stat_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    final isPremium = context.watch<GlobalState>().isPremium;

    return CommonBackground(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Top Header (Logo) - Scrolls Away ──────────────────────────
          SliverToBoxAdapter(
            child: Center(
              child: Image.asset(IconAssets.app_logo, height: 70.h),
            ),
          ),

          // ── Welcome Row - Pinned AppBar ─────────────────────────────
          SliverAppBar(
            pinned: true,
            toolbarHeight: 70.h,
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppColors.sceDarkBg.withOpacity(0.95),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 2.h),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Welcome back',
                          style: FontManager.bodySmall(
                            color: Colors.white60,
                            fontSize: 14.sp,
                          ),
                        ),
                        Text(
                          context.watch<GlobalState>().userName,
                          style: FontManager.heading3(
                            color: Colors.white,
                            fontSize: 20.sp,
                          ).copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        // Text(
                        //   isPremium ? "Premium" : "Basic",
                        //   style: TextStyle(color: AppColors.sceGold, fontSize: 12.sp, fontWeight: FontWeight.bold),
                        // ),
                        // Switch(
                        //   value: isPremium,
                        //   activeColor: AppColors.sceGold,
                        //   onChanged: (val) {
                        //     context.read<GlobalState>().isPremium = val;
                        //   },
                        // ),
                        SizedBox(width: 8.w),
                        const NotificationBadge(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Content Sections ──────────────────────────────────────────
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                AppSpacing.h24,
                // ── Stats Row ───────────────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        label: 'CURRENT BALANCE',
                        value: 'CHF 32,500',
                        subValue: '+ 5.4%',
                        accentColor: AppColors.sceTeal,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: StatCard(
                        label: 'WATCHLIST',
                        value: '24',
                        labelDesc: 'Active Auctions',
                        accentColor: AppColors.sceGold,
                        isWatchlist: true,
                      ),
                    ),
                  ],
                ),
                AppSpacing.h20,

                // ── Premium Card ────────────────────────────────────────
                const PremiumDealerCard(),
                AppSpacing.h20,

                // ── Search Button ───────────────────────────────────────
                CustomButton(
                  text: 'SEARCH VEHICLE',
                  onPressed: () {},
                  isPrimary: true,
                ),
                AppSpacing.h32,

                // ── Live Auctions Section ────────────────────────────────
                const SectionHeader(title: 'LIVE AUCTIONS'),
                AppSpacing.h16,
                const AuctionCard(
                  title: 'BMW M5 2023',
                  lotNo: 'Lct 4357',
                  currentBid: 'CHF 35,700',
                  isLive: true,
                  countdown: {'hrs': '03', 'min': '12', 'sec': '45'},
                  imageUrl:
                      'https://images.unsplash.com/photo-1555215695-3004980ad54e?auto=format&fit=crop&q=80&w=800',
                ),
                AppSpacing.h20,
                const AuctionCard(
                  title: 'Audi RS6 2022',
                  lotNo: 'Lct 4358',
                  currentBid: 'CHF 28,400',
                  isLive: true,
                  badge: 'Ending Soon',
                  countdown: {'hrs': '00', 'min': '22', 'sec': '57'},
                  imageUrl:
                      'https://images.unsplash.com/photo-1555215695-3004980ad54e?auto=format&fit=crop&q=80&w=800',
                ),
                AppSpacing.h32,

                // ── Upcoming Auctions Section ────────────────────────────
                const SectionHeader(title: 'UPCOMING AUCTIONS'),
                AppSpacing.h16,
                const AuctionCard(
                  title: 'Porsche 911 Turbo',
                  lotNo: 'Lct 4359',
                  currentBid: 'CHF 4560',
                  isLive: false,
                  desc: 'Date: 18/03/23',
                  timeMeta: '10h 32m',
                  userCount: '47',
                  imageUrl:
                      'https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&q=80&w=800',
                ),
                AppSpacing.h20,
                const AuctionCard(
                  title: 'Mercedes-Benz AMG GT 2023',
                  lotNo: 'Lct 4360',
                  currentBid: 'CHF 4560',
                  isLive: false,
                  desc: 'Date: 18/03/23',
                  timeMeta: '14h 07m',
                  userCount: '12',
                  imageUrl:
                      'https://images.unsplash.com/photo-1614164185128-e4ec99c436d7?auto=format&fit=crop&q=80&w=800',
                ),
                AppSpacing.h40,
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
