class MyShippingRequest {
  final int count;
  final String? next;
  final String? previous;
  final List<ShippingResult> results;

  MyShippingRequest({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory MyShippingRequest.fromJson(Map<String, dynamic> json) {
    return MyShippingRequest(
      count: json['count'] ?? 0,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results:
          (json['results'] as List<dynamic>?)
              ?.map(
                (item) => ShippingResult.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'count': count,
    'next': next,
    'previous': previous,
    'results': results.map((item) => item.toJson()).toList(),
  };
}

class ShippingResult {
  final int auctionId;
  final String auctionTitle;
  final Buyer buyer;
  final String amount;
  final String shippingMethod;
  final String status;
  final DateTime createdAt;

  ShippingResult({
    required this.auctionId,
    required this.auctionTitle,
    required this.buyer,
    required this.amount,
    required this.shippingMethod,
    required this.status,
    required this.createdAt,
  });

  factory ShippingResult.fromJson(Map<String, dynamic> json) {
    return ShippingResult(
      auctionId: json['auction_id'] ?? 0,
      auctionTitle: json['auction_title'] ?? '',
      buyer: json['buyer'] != null
          ? Buyer.fromJson(json['buyer'])
          : Buyer.empty(),
      amount: json['amount'] ?? '0.00',
      shippingMethod: json['shipping_method'] ?? '',
      status: json['status'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'auction_id': auctionId,
    'auction_title': auctionTitle,
    'buyer': buyer.toJson(),
    'amount': amount,
    'shipping_method': shippingMethod,
    'status': status,
    'created_at': createdAt.toIso8601String(),
  };
}

class Buyer {
  final String email;
  final String fullName;
  final String phone;
  final String address;
  final String company;

  Buyer({
    required this.email,
    required this.fullName,
    required this.phone,
    required this.address,
    required this.company,
  });

  factory Buyer.fromJson(Map<String, dynamic> json) {
    return Buyer(
      email: json['email'] ?? '',
      fullName: json['full_name'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      company: json['company'] ?? '',
    );
  }

  // Helper factory for null safety fallback
  factory Buyer.empty() {
    return Buyer(email: '', fullName: '', phone: '', address: '', company: '');
  }

  Map<String, dynamic> toJson() => {
    'email': email,
    'full_name': fullName,
    'phone': phone,
    'address': address,
    'company': company,
  };
}
