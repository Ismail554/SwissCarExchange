import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wynante/core/constants/font_manager.dart';
import 'package:wynante/core/utils/app_colors.dart';
import 'package:wynante/core/widgets/common_background.dart';
import 'package:wynante/views/bidding/widgets/payment_option_sheet.dart';

// ---------------------------------------------------------------------------
// Model
// ---------------------------------------------------------------------------

enum TransactionStatus { paid, payNow }

class _Transaction {
  final String carName;
  final String date;
  final String amount;
  final TransactionStatus status;

  const _Transaction({
    required this.carName,
    required this.date,
    required this.amount,
    required this.status,
  });
}

// ---------------------------------------------------------------------------
// Dummy data keyed by time period
// ---------------------------------------------------------------------------

const _chips = ['7D', '30D', '90D', '1Y'];

/// Chart data points (normalised 0–1) per period
const Map<String, List<double>> _chartData = {
  '7D': [0.30, 0.45, 0.40, 0.55, 0.50, 0.65, 0.70],
  '30D': [0.45, 0.42, 0.50, 0.38, 0.55, 0.60, 0.52, 0.70, 0.80, 0.95],
  '90D': [0.20, 0.35, 0.30, 0.48, 0.55, 0.50, 0.65, 0.72, 0.68, 0.80, 0.88, 0.92],
  '1Y': [0.10, 0.20, 0.35, 0.30, 0.45, 0.55, 0.50, 0.60, 0.75, 0.70, 0.85, 0.95],
};

/// Stats per period
class _PeriodStats {
  final String winRate;
  final String winRateBadge;
  final String avgBid;
  final String auctionsWon;
  final String auctionParticipate;

  const _PeriodStats({
    required this.winRate,
    required this.winRateBadge,
    required this.avgBid,
    required this.auctionsWon,
    required this.auctionParticipate,
  });
}

const Map<String, _PeriodStats> _statsData = {
  '7D': _PeriodStats(winRate: '72%', winRateBadge: '+2%', avgBid: '38k', auctionsWon: '3', auctionParticipate: '5'),
  '30D': _PeriodStats(winRate: '68%', winRateBadge: '+5%', avgBid: '42k', auctionsWon: '14', auctionParticipate: '26'),
  '90D': _PeriodStats(winRate: '65%', winRateBadge: '+8%', avgBid: '45k', auctionsWon: '38', auctionParticipate: '72'),
  '1Y': _PeriodStats(winRate: '61%', winRateBadge: '+12%', avgBid: '51k', auctionsWon: '124', auctionParticipate: '210'),
};

/// Transactions shown per period (last 4 always shown in the mini list)
const List<_Transaction> _allTransactions = [
  _Transaction(carName: 'Audi RS6 Avant', date: 'Oct 11, 2023', amount: 'CHF 112,000', status: TransactionStatus.paid),
  _Transaction(carName: 'Porsche 911 GT3', date: 'Oct 5, 2023', amount: 'CHF 185,000', status: TransactionStatus.paid),
  _Transaction(carName: 'Mercedes-AMG GT', date: 'Sep 28, 2023', amount: 'CHF 95,000', status: TransactionStatus.payNow),
  _Transaction(carName: 'BMW M4 Competition', date: 'Sep 15, 2023', amount: 'CHF 78,000', status: TransactionStatus.paid),
  _Transaction(carName: 'Ferrari 488 GTB', date: 'Aug 20, 2023', amount: 'CHF 220,000', status: TransactionStatus.paid),
  _Transaction(carName: 'Lamborghini Urus', date: 'Aug 5, 2023', amount: 'CHF 310,000', status: TransactionStatus.payNow),
  _Transaction(carName: 'Bentley Continental', date: 'Jul 18, 2023', amount: 'CHF 260,000', status: TransactionStatus.paid),
  _Transaction(carName: 'McLaren 720S', date: 'Jun 29, 2023', amount: 'CHF 290,000', status: TransactionStatus.paid),
];

/// How many transactions belong to each period
const Map<String, int> _periodTxCount = {
  '7D': 2,
  '30D': 4,
  '90D': 6,
  '1Y': 8,
};

// ---------------------------------------------------------------------------
// Main View
// ---------------------------------------------------------------------------

class BidsView extends StatefulWidget {
  const BidsView({super.key});

  @override
  State<BidsView> createState() => _BidsViewState();
}

class _BidsViewState extends State<BidsView> {
  String _selectedPeriod = '30D';

  List<_Transaction> get _filteredTransactions =>
      _allTransactions.take(_periodTxCount[_selectedPeriod]!).toList();

  _PeriodStats get _stats => _statsData[_selectedPeriod]!;
  List<double> get _chartPoints => _chartData[_selectedPeriod]!;

  void _selectPeriod(String period) => setState(() => _selectedPeriod = period);

  void _openAllTransactions() {
    Navigator.of(context).push(
      _SlideUpRoute(
        child: _AllTransactionsScreen(transactions: _filteredTransactions),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonBackground(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // --- Pinned header ---
          SliverPersistentHeader(
            pinned: true,
            delegate: _PinnedHeaderDelegate(
              minHeight: 56.h,
              maxHeight: 56.h,
              child: _buildPinnedHeader(),
            ),
          ),

          // --- Scrollable body ---
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12.h),

                // Time chips
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: _buildTimeChips(),
                ),
                SizedBox(height: 16.h),

                // Spending chart
                _buildSpendingChart(),
                SizedBox(height: 16.h),

                // Stats grid
                _buildStatsGrid(),
                SizedBox(height: 20.h),

                // Section header
                _buildRecentTransactionsHeader(),
                SizedBox(height: 12.h),
              ],
            ),
          ),

          // --- Transaction list as sliver ---
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index.isOdd) {
                    return Divider(
                      color: AppColors.grey.withOpacity(0.15),
                      height: 1,
                    );
                  }
                  final tx = _filteredTransactions[index ~/ 2];
                  return _TransactionRow(
                    transaction: tx,
                    onPayNow: () => showPaymentOptionSheet(
                      context,
                      carName: tx.carName,
                      amount: tx.amount,
                    ),
                  );
                },
                childCount: _filteredTransactions.length * 2 - 1,
              ),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: 32.h)),
        ],
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Pinned header widget (transparent background so bg shows through)
  // -------------------------------------------------------------------------

  Widget _buildPinnedHeader() {
    return Container(
      // Subtle frosted look when scrolled over content
      color: AppColors.sceDarkBg.withOpacity(0.92),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Analytics',
          style: FontManager.heading1(color: AppColors.white),
        ),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Time chips (functional)
  // -------------------------------------------------------------------------

  Widget _buildTimeChips() {
    return Row(
      children: _chips.map((label) {
        return Padding(
          padding: EdgeInsets.only(right: 8.w),
          child: _TimeChip(
            label: label,
            isSelected: label == _selectedPeriod,
            onTap: () => _selectPeriod(label),
          ),
        );
      }).toList(),
    );
  }

  // -------------------------------------------------------------------------
  // Spending chart
  // -------------------------------------------------------------------------

  Widget _buildSpendingChart() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (child, animation) =>
            FadeTransition(opacity: animation, child: child),
        child: Container(
          key: ValueKey(_selectedPeriod),
          height: 160.h,
          decoration: BoxDecoration(
            color: const Color(0xFF0F1923),
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
              Expanded(child: _SpendingChart(points: _chartPoints)),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Stats grid
  // -------------------------------------------------------------------------

  Widget _buildStatsGrid() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: _StatsGrid(key: ValueKey(_selectedPeriod), stats: _stats),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Recent transactions header with "View All"
  // -------------------------------------------------------------------------

  Widget _buildRecentTransactionsHeader() {
    return Padding(
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
    );
  }
}

// ---------------------------------------------------------------------------
// Custom slide-up page route (animated transition from bottom)
// ---------------------------------------------------------------------------

class _SlideUpRoute extends PageRoute<void> {
  final Widget child;

  _SlideUpRoute({required this.child});

  @override
  bool get opaque => false;

  @override
  Color? get barrierColor => Colors.black54;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 420);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final curve =
        CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(curve),
      child: child,
    );
  }
}

// ---------------------------------------------------------------------------
// Full-screen transactions screen (opened by "View All")
// ---------------------------------------------------------------------------

class _AllTransactionsScreen extends StatelessWidget {
  final List<_Transaction> transactions;

  const _AllTransactionsScreen({required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sceDarkBg,
      appBar: AppBar(
        backgroundColor: AppColors.sceDarkBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'All Transactions',
          style: FontManager.heading2(color: AppColors.white),
        ),
      ),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        itemCount: transactions.length,
        separatorBuilder: (_, __) =>
            Divider(color: AppColors.grey.withOpacity(0.15), height: 1),
        itemBuilder: (context, index) {
          final tx = transactions[index];
          return _TransactionRow(
            transaction: tx,
            onPayNow: () => showPaymentOptionSheet(
              context,
              carName: tx.carName,
              amount: tx.amount,
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Pinned header SliverPersistentHeaderDelegate
// ---------------------------------------------------------------------------

class _PinnedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _PinnedHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_PinnedHeaderDelegate oldDelegate) =>
      maxHeight != oldDelegate.maxHeight ||
      minHeight != oldDelegate.minHeight ||
      child != oldDelegate.child;
}

// ---------------------------------------------------------------------------
// Time Chip widget
// ---------------------------------------------------------------------------

class _TimeChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TimeChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.sceTeal : const Color(0xFF1C2537),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color:
                isSelected ? AppColors.sceTeal : AppColors.grey.withOpacity(0.25),
          ),
        ),
        child: Text(
          label,
          style: FontManager.labelSmall(
            color: isSelected ? AppColors.black : AppColors.grey,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Spending chart (custom painter, driven by data points)
// ---------------------------------------------------------------------------

class _SpendingChart extends StatelessWidget {
  final List<double> points;

  const _SpendingChart({required this.points});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: _LineChartPainter(points: points),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> points;

  const _LineChartPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final count = points.length;
    if (count < 2) return;

    final linePaint = Paint()
      ..color = AppColors.sceTeal
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.sceTeal.withOpacity(0.35),
          AppColors.sceTeal.withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();

    for (int i = 0; i < count; i++) {
      final x = size.width * i / (count - 1);
      final y = size.height * (1 - points[i]) * 0.88; // leave space for labels
      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, y);
      } else {
        final prevX = size.width * (i - 1) / (count - 1);
        final prevY = size.height * (1 - points[i - 1]) * 0.88;
        final cpX = (prevX + x) / 2;
        path.cubicTo(cpX, prevY, cpX, y, x, y);
        fillPath.cubicTo(cpX, prevY, cpX, y, x, y);
      }
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);

    // X-axis labels
    final months = ['Feb', 'Apr', 'Jun', 'Aug', 'Oct', 'Dec'];
    final tp = TextPainter(textDirection: TextDirection.ltr);
    for (int i = 0; i < months.length; i++) {
      tp.text = TextSpan(
        text: months[i],
        style: const TextStyle(color: Color(0xFF848484), fontSize: 9),
      );
      tp.layout();
      final x = size.width * i / (months.length - 1) - tp.width / 2;
      tp.paint(canvas, Offset(x, size.height - 14));
    }
  }

  @override
  bool shouldRepaint(_LineChartPainter old) => old.points != points;
}

// ---------------------------------------------------------------------------
// Stats grid (receives PeriodStats)
// ---------------------------------------------------------------------------

class _StatsGrid extends StatelessWidget {
  final _PeriodStats stats;

  const _StatsGrid({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              _StatCard(
                label: 'WIN RATE',
                value: stats.winRate,
                valueColor: AppColors.sceTeal,
                badge: stats.winRateBadge,
              ),
              SizedBox(height: 12.h),
              _StatCard(
                label: 'AUCTIONS WON',
                value: stats.auctionsWon,
                valueColor: AppColors.white,
              ),
            ],
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            children: [
              _StatCard(
                label: 'AVG BID',
                value: stats.avgBid,
                valueColor: AppColors.white,
              ),
              SizedBox(height: 12.h),
              _StatCard(
                label: 'AUCTION PARTICIPATE',
                value: stats.auctionParticipate,
                valueColor: AppColors.sceGold,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Stat card
// ---------------------------------------------------------------------------

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  final String? badge;

  const _StatCard({
    required this.label,
    required this.value,
    required this.valueColor,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1923),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.grey.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: FontManager.labelSmall(color: AppColors.grey)),
          SizedBox(height: 6.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  value,
                  key: ValueKey(value),
                  style: FontManager.heading2(color: valueColor),
                ),
              ),
              if (badge != null) ...[
                SizedBox(width: 6.w),
                Text(
                  '⬈ $badge',
                  style: FontManager.labelSmall(color: AppColors.sceTeal),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Transaction row
// ---------------------------------------------------------------------------

class _TransactionRow extends StatelessWidget {
  final _Transaction transaction;
  final VoidCallback onPayNow;

  const _TransactionRow({required this.transaction, required this.onPayNow});

  @override
  Widget build(BuildContext context) {
    final isPaid = transaction.status == TransactionStatus.paid;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: car name + date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.carName,
                  style: FontManager.bodyMedium(color: AppColors.white),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  transaction.date,
                  style: FontManager.labelSmall(color: AppColors.grey),
                ),
              ],
            ),
          ),

          SizedBox(width: 12.w),

          // Right: amount + status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                transaction.amount,
                style: FontManager.bodyMedium(color: AppColors.white),
              ),
              SizedBox(height: 6.h),
              if (isPaid)
                Text(
                  'Paid',
                  style: FontManager.labelSmall(color: AppColors.sceTeal),
                )
              else
                _PayNowButton(onTap: onPayNow),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// "Pay Now" pill button
// ---------------------------------------------------------------------------

class _PayNowButton extends StatelessWidget {
  final VoidCallback onTap;

  const _PayNowButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: AppColors.sceTeal,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          'Pay Now',
          style: FontManager.labelSmall(color: AppColors.black),
        ),
      ),
    );
  }
}
