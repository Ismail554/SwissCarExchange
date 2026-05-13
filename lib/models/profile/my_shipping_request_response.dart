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
  final String buyerEmail;
  final String amount;
  final String shippingMethod;
  final String status;
  final DateTime createdAt;

  ShippingResult({
    required this.auctionId,
    required this.auctionTitle,
    required this.buyerEmail,
    required this.amount,
    required this.shippingMethod,
    required this.status,
    required this.createdAt,
  });

  factory ShippingResult.fromJson(Map<String, dynamic> json) {
    return ShippingResult(
      auctionId: json['auction_id'] ?? 0,
      auctionTitle: json['auction_title'] ?? '',
      buyerEmail: json['buyer_email'] ?? '',
      amount: json['amount'] ?? '0.00',
      shippingMethod: json['shipping_method'] ?? '',
      status: json['status'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'auction_id': auctionId,
    'auction_title': auctionTitle,
    'buyer_email': buyerEmail,
    'amount': amount,
    'shipping_method': shippingMethod,
    'status': status,
    'created_at': createdAt.toIso8601String(),
  };
}
