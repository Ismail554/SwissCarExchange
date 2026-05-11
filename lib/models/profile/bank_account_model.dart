class BankAccountModel {
  final String bankName;
  final String accountName;
  final String iban;

  BankAccountModel({
    required this.bankName,
    required this.accountName,
    required this.iban,
  });

  factory BankAccountModel.fromJson(Map<String, dynamic> json) {
    return BankAccountModel(
      bankName: json['bank_name'] ?? '',
      accountName: json['account_name'] ?? '',
      iban: json['iban'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bank_name': bankName,
      'account_name': accountName,
      'iban': iban,
    };
  }
}
