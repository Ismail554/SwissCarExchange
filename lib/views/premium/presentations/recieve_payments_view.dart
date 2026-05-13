import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/core/widgets/common_background.dart';
import 'package:rionydo/core/widgets/custom_back_button.dart';

import 'package:rionydo/app_utils/constants/api_service.dart';
import 'package:rionydo/app_utils/network/dio_manager.dart';
import 'package:rionydo/app_utils/network/enums.dart';
import 'package:rionydo/models/transactions/analytics_response.dart';

import 'package:rionydo/views/premium/widgets/payment_stat_card.dart';
import 'package:rionydo/views/premium/widgets/payment_filter_chip.dart';
import 'package:rionydo/views/bidding/widgets/bids_models.dart';
import 'package:rionydo/views/bidding/widgets/transaction_row.dart';
import 'package:rionydo/views/premium/widgets/payment_info_card.dart';

class RecievePayments extends StatefulWidget {
  const RecievePayments({super.key});

  @override
  State<RecievePayments> createState() => _RecievePaymentsState();
}

class _RecievePaymentsState extends State<RecievePayments> {
  int _selectedIndex = 0; // 0 for Pending, 1 for Completed
  bool _isLoading = true;
  List<DealerTransactionItem> _transactions = [];
  double _pendingAmount = 0.0;
  double _receivedAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchPayments();
  }

  Future<void> _fetchPayments() async {
    setState(() => _isLoading = true);
    try {
      debugPrint("Fetching dealer transactions...");
      final response = await DioManager.apiRequest(
        url: ApiService.dealerTransaction,
        method: Methods.get,
      );

      response.fold(
        (error) {
          debugPrint('Failed to load dealer transactions: $error');
        },
        (data) {
          if (data != null && mounted) {
            try {
              debugPrint("Data received: $data");
              final parsed = DealerTransactionResponse.fromJson(
                data as Map<String, dynamic>,
              );
              debugPrint(
                "Parsed successfully! Pending: ${parsed.pendingAmount}, Received: ${parsed.receivedAmount}, Results: ${parsed.results.length}",
              );
              setState(() {
                _transactions = parsed.results;
                _pendingAmount = parsed.pendingAmount;
                _receivedAmount = parsed.receivedAmount;

                // Automatically switch to 'Completed' tab if there are no pending transactions but there are completed ones.
                if (_pendingTransactions.isEmpty &&
                    _completedTransactions.isNotEmpty) {
                  _selectedIndex = 1;
                }
              });
            } catch (e, stacktrace) {
              debugPrint("Error parsing dealer transactions: $e");
              debugPrint(stacktrace.toString());
            }
          }
        },
      );
    } catch (e, stacktrace) {
      debugPrint('Error fetching dealer transactions: $e');
      debugPrint(stacktrace.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<DealerTransactionItem> get _pendingTransactions => _transactions
      .where((tx) => tx.status.toLowerCase() == 'payment_pending')
      .toList();

  List<DealerTransactionItem> get _completedTransactions => _transactions
      .where((tx) => tx.status.toLowerCase() != 'payment_pending')
      .toList();

  String _formatAmount(double amount) {
    if (amount >= 1000) {
      final kValue = amount / 1000;
      return '${kValue.toStringAsFixed(kValue % 1 == 0 ? 0 : 1)}k';
    }
    return amount.toStringAsFixed(0);
  }

  String _formatTxAmount(String amountStr) {
    final amount = double.tryParse(amountStr) ?? 0.0;
    final intValue = amount.toInt();
    final str = intValue.toString();
    return str.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return '--';
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  Widget _buildTransactionList(List<DealerTransactionItem> list) {
    if (list.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 32.h),
          child: Text(
            "No transactions found.",
            style: FontManager.bodyMedium(color: AppColors.sceGrey99),
          ),
        ),
      );
    }

    return Column(
      children: list.map((tx) {
        final isPending = tx.status.toLowerCase() == 'payment_pending';
        final carNameText = tx.buyerCompany.isNotEmpty 
            ? '${tx.buyerCompany} - ${tx.auctionTitle}' 
            : tx.auctionTitle;

        final mappedTx = Transaction(
          carName: carNameText,
          date: _formatDate(tx.soldAt),
          amount: 'CHF ${_formatTxAmount(tx.amount)}',
          status: isPending ? TransactionStatus.unpaid : TransactionStatus.paid,
          auctionId: tx.auctionId?.toString(),
        );

        return TransactionRow(transaction: mappedTx);
      }).toList(),
    );
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
            Row(
              children: [
                Text(
                  "Receive Payments",
                  style: FontManager.titleText(
                    color: Colors.white,
                  ).copyWith(fontSize: 18.sp),
                ),
                SizedBox(width: 4.w),
                Icon(
                  Icons.workspace_premium_rounded,
                  color: AppColors.sceGold,
                  size: 18.sp,
                ),
              ],
            ),
            Text("Track your earnings", style: FontManager.hintText()),
          ],
        ),
      ),
      child: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.sceTeal),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  SizedBox(height: 16.h),

                  // ── TOP STATS ──
                  Row(
                    children: [
                      Expanded(
                        child: PaymentStatCard(
                          label: "PENDING",
                          value: _formatAmount(_pendingAmount),
                          accentColor: AppColors.sceGold,
                          bgColor: AppColors.sceGoldStatBg,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: PaymentStatCard(
                          label: "RECEIVED",
                          value: _formatAmount(_receivedAmount),
                          accentColor: AppColors.sceTeal,
                          bgColor: AppColors.sceTealStatBg,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 24.h),

                  // ── TOGGLE CHIPS ──
                  Row(
                    children: [
                      PaymentFilterChip(
                        label: "Pending (${_pendingTransactions.length})",
                        isSelected: _selectedIndex == 0,
                        onTap: () => setState(() => _selectedIndex = 0),
                      ),
                      SizedBox(width: 12.w),
                      PaymentFilterChip(
                        label: "Completed (${_completedTransactions.length})",
                        isSelected: _selectedIndex == 1,
                        onTap: () => setState(() => _selectedIndex = 1),
                      ),
                    ],
                  ),

                  SizedBox(height: 24.h),

                  // ── PAYMENT LIST ──
                  _buildTransactionList(
                    _selectedIndex == 0
                        ? _pendingTransactions
                        : _completedTransactions,
                  ),

                  SizedBox(height: 24.h),

                  // ── INFO CARD ──
                  const PaymentInfoCard(),

                  SizedBox(height: 40.h),
                ],
              ),
            ),
    );
  }
}
