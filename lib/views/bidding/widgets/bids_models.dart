// ---------------------------------------------------------------------------
// Models & dummy data for the Bids / Analytics screen
// ---------------------------------------------------------------------------

enum TransactionStatus { paid, payNow }

class Transaction {
  final String carName;
  final String date;
  final String amount;
  final TransactionStatus status;

  const Transaction({
    required this.carName,
    required this.date,
    required this.amount,
    required this.status,
  });
}

class PeriodStats {
  final String winRate;
  final String winRateBadge;
  final String avgBid;
  final String auctionsWon;
  final String auctionParticipate;

  const PeriodStats({
    required this.winRate,
    required this.winRateBadge,
    required this.avgBid,
    required this.auctionsWon,
    required this.auctionParticipate,
  });
}

// ---------------------------------------------------------------------------
// Constants
// ---------------------------------------------------------------------------

const List<String> kBidsChips = ['7D', '30D', '90D', '1Y'];

/// Data points per period — count matches label count for 1:1 mapping.
/// 7D  = 7 daily points   (Mon–Sun)
/// 30D = 4 weekly points  (W1–W4)
/// 90D = 3 monthly points (3-month window)
/// 1Y  = 12 monthly points (Jan–Dec)
const Map<String, List<double>> kChartData = {
  '7D': [0.30, 0.45, 0.40, 0.55, 0.50, 0.65, 0.70],
  '30D': [0.42, 0.58, 0.70, 0.88],
  '90D': [0.40, 0.62, 0.85],
  '1Y': [0.10, 0.20, 0.35, 0.30, 0.45, 0.55, 0.50, 0.60, 0.75, 0.70, 0.85, 0.95],
};

/// X-axis labels matching the chart granularity per period.
const Map<String, List<String>> kChartLabels = {
  '7D':  ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
  '30D': ['W1', 'W2', 'W3', 'W4'],
  '90D': ['Jan', 'Feb', 'Mar'],
  '1Y':  ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
};

const Map<String, PeriodStats> kStatsData = {
  '7D': PeriodStats(winRate: '72%', winRateBadge: '+2%', avgBid: '38k', auctionsWon: '3',   auctionParticipate: '5'),
  '30D': PeriodStats(winRate: '68%', winRateBadge: '+5%', avgBid: '42k', auctionsWon: '14',  auctionParticipate: '26'),
  '90D': PeriodStats(winRate: '65%', winRateBadge: '+8%', avgBid: '45k', auctionsWon: '38',  auctionParticipate: '72'),
  '1Y': PeriodStats(winRate: '61%', winRateBadge: '+12%', avgBid: '51k', auctionsWon: '124', auctionParticipate: '210'),
};

const List<Transaction> kAllTransactions = [
  Transaction(carName: 'Audi RS6 Avant',       date: 'Oct 11, 2023', amount: 'CHF 112,000', status: TransactionStatus.paid),
  Transaction(carName: 'Porsche 911 GT3',       date: 'Oct 5, 2023',  amount: 'CHF 185,000', status: TransactionStatus.paid),
  Transaction(carName: 'Mercedes-AMG GT',       date: 'Sep 28, 2023', amount: 'CHF 95,000',  status: TransactionStatus.payNow),
  Transaction(carName: 'BMW M4 Competition',    date: 'Sep 15, 2023', amount: 'CHF 78,000',  status: TransactionStatus.paid),
  Transaction(carName: 'Ferrari 488 GTB',       date: 'Aug 20, 2023', amount: 'CHF 220,000', status: TransactionStatus.paid),
  Transaction(carName: 'Lamborghini Urus',      date: 'Aug 5, 2023',  amount: 'CHF 310,000', status: TransactionStatus.payNow),
  Transaction(carName: 'Bentley Continental',   date: 'Jul 18, 2023', amount: 'CHF 260,000', status: TransactionStatus.paid),
  Transaction(carName: 'McLaren 720S',          date: 'Jun 29, 2023', amount: 'CHF 290,000', status: TransactionStatus.paid),
];

/// Max number of transactions visible per selected period
const Map<String, int> kPeriodTxCount = {
  '7D': 2,
  '30D': 4,
  '90D': 6,
  '1Y': 8,
};
