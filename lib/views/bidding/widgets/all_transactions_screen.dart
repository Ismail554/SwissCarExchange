import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/core/constants/font_manager.dart';
import 'package:rionydo/core/utils/app_colors.dart';
import 'package:rionydo/views/bidding/widgets/bids_models.dart';
import 'package:rionydo/views/bidding/widgets/payment_option_sheet.dart';
import 'package:rionydo/views/bidding/widgets/transaction_row.dart';

/// Full-screen list of all transactions — opened via the slide-up route.
class AllTransactionsScreen extends StatelessWidget {
  final List<Transaction> transactions;

  const AllTransactionsScreen({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sceDarkBg,
      appBar: AppBar(
        backgroundColor: AppColors.sceDarkBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.white,
          ),
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
          return TransactionRow(
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
