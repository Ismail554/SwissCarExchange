import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/core/constants/font_manager.dart';
import 'package:rionydo/core/utils/app_colors.dart';
import 'package:rionydo/core/widgets/common_background.dart';
import 'package:rionydo/views/bidding/widgets/all_transactions_screen.dart';
import 'package:rionydo/views/bidding/widgets/bids_models.dart';
import 'package:rionydo/views/bidding/widgets/payment_option_sheet.dart';
import 'package:rionydo/views/bidding/widgets/pinned_header_delegate.dart';
import 'package:rionydo/views/bidding/widgets/slide_up_route.dart';
import 'package:rionydo/views/bidding/widgets/spending_chart.dart';
import 'package:rionydo/views/bidding/widgets/stats_grid.dart';
import 'package:rionydo/views/bidding/widgets/time_chip.dart';
import 'package:rionydo/views/bidding/widgets/transaction_row.dart';

class BidsView extends StatefulWidget {
  const BidsView({super.key});

  @override
  State<BidsView> createState() => _BidsViewState();
}

class _BidsViewState extends State<BidsView> {
  String _selectedPeriod = '30D';

  List<Transaction> get _filteredTransactions =>
      kAllTransactions.take(kPeriodTxCount[_selectedPeriod]!).toList();

  PeriodStats get _stats => kStatsData[_selectedPeriod]!;
  List<double> get _chartPoints => kChartData[_selectedPeriod]!;
  List<String> get _chartLabels => kChartLabels[_selectedPeriod]!;

  void _selectPeriod(String period) => setState(() => _selectedPeriod = period);

  void _openAllTransactions() {
    Navigator.of(context).push(
      SlideUpRoute(
        child: AllTransactionsScreen(transactions: _filteredTransactions),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return CommonBackground(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildPinnedHeader(),
          _buildBody(),
          _buildTransactionSliver(),
          SliverToBoxAdapter(child: SizedBox(height: 32.h)),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Pinned "Analytics" title
  // ---------------------------------------------------------------------------

  Widget _buildPinnedHeader() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: PinnedHeaderDelegate(
        minHeight: 56.h,
        maxHeight: 56.h,
        child: Container(
          color: AppColors.sceDarkBg.withOpacity(0.92),
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Analytics',
              style: FontManager.heading1(color: AppColors.white),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Scrollable content above the transaction list
  // ---------------------------------------------------------------------------

  Widget _buildBody() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12.h),

          // Time-period chips
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: kBidsChips.map((label) {
                return Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: BidsTimeChip(
                    label: label,
                    isSelected: label == _selectedPeriod,
                    onTap: () => _selectPeriod(label),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 16.h),

          // Spending chart
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, anim) =>
                  FadeTransition(opacity: anim, child: child),
              child: Container(
                key: ValueKey(_selectedPeriod),
                height: 160.h,
                decoration: BoxDecoration(
                  color: AppColors.sceChartBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.grey.withOpacity(0.15)),
                ),
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SPENDING OVERVIEW',
                      style: FontManager.labelSmall(color: AppColors.grey),
                    ),
                    SizedBox(height: 8.h),
                    Expanded(
                      child: SpendingChart(
                        points: _chartPoints,
                        xLabels: _chartLabels,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 16.h),

          // Stats grid
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              child: StatsGrid(key: ValueKey(_selectedPeriod), stats: _stats),
            ),
          ),
          SizedBox(height: 20.h),

          // Recent transactions header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'RECENT TRANSACTIONS',
                  style: FontManager.labelSmall(color: AppColors.grey),
                ),
                GestureDetector(
                  onTap: _openAllTransactions,
                  child: Text(
                    'View All',
                    style: FontManager.labelSmall(color: AppColors.sceTeal),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Transaction list as a sliver
  // ---------------------------------------------------------------------------

  Widget _buildTransactionSliver() {
    final transactions = _filteredTransactions;
    final itemCount = transactions.length * 2 - 1;

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          if (index.isOdd) {
            return Divider(color: AppColors.grey.withOpacity(0.15), height: 1);
          }
          final tx = transactions[index ~/ 2];
          return TransactionRow(
            transaction: tx,
            onPayNow: () => showPaymentOptionSheet(
              context,
              carName: tx.carName,
              amount: tx.amount,
            ),
          );
        }, childCount: itemCount),
      ),
    );
  }
}
