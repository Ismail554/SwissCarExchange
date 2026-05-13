class PaymentInfoResponse {
  final int auctionId;
  final String auctionTitle;
  final String amount;
  final String currency;
  final DateTime? paymentDeadline;
  final String bankName;
  final String accountName;
  final String iban;

  PaymentInfoResponse({
    required this.auctionId,
    required this.auctionTitle,
    required this.amount,
    required this.currency,
    this.paymentDeadline,
    required this.bankName,
    required this.accountName,
    required this.iban,
  });

  factory PaymentInfoResponse.fromJson(Map<String, dynamic> json) {
    return PaymentInfoResponse(
      auctionId: json['auction_id'] ?? 0,
      auctionTitle: json['auction_title'] ?? "",
      amount: json['amount'] ?? "0.00",
      currency: json['currency'] ?? "",
      paymentDeadline: json['payment_deadline'] != null
          ? DateTime.tryParse(json['payment_deadline'].toString().endsWith('Z')
              ? json['payment_deadline']
              : '${json['payment_deadline']}Z')?.toLocal()
          : null,
      bankName: json['bank_name'] ?? "",
      accountName: json['account_name'] ?? "",
      iban: json['iban'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'auction_id': auctionId,
      'auction_title': auctionTitle,
      'amount': amount,
      'currency': currency,
      'payment_deadline': paymentDeadline?.toIso8601String(),
      'bank_name': bankName,
      'account_name': accountName,
      'iban': iban,
    };
  }
}