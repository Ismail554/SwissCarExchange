// ------------------------------------------------------------------
// BID HISTORY RESPONSE (Paginated Wrapper)
// ------------------------------------------------------------------
class BidHistoryResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<BidItem> results;

  const BidHistoryResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory BidHistoryResponse.fromJson(Map<String, dynamic> json) {
    return BidHistoryResponse(
      count: json['count'] as int? ?? 0,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => BidItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'count': count,
        'next': next,
        'previous': previous,
        'results': results.map((e) => e.toJson()).toList(),
      };

  BidHistoryResponse copyWith({
    int? count,
    String? next,
    String? previous,
    List<BidItem>? results,
  }) {
    return BidHistoryResponse(
      count: count ?? this.count,
      next: next ?? this.next,
      previous: previous ?? this.previous,
      results: results ?? this.results,
    );
  }
}

// ------------------------------------------------------------------
// BID ITEM
// ------------------------------------------------------------------
class BidItem {
  final String bidderAlias;
  final bool isMe;
  final String increment;
  final String amountAfter;
  final DateTime createdAt;

  const BidItem({
    required this.bidderAlias,
    required this.isMe,
    required this.increment,
    required this.amountAfter,
    required this.createdAt,
  });

  factory BidItem.fromJson(Map<String, dynamic> json) {
    return BidItem(
      bidderAlias: json['bidder_alias'] as String? ?? 'Unknown Bidder',
      isMe: json['is_me'] as bool? ?? false,
      // Monetary values kept as Strings to preserve precision from the backend
      increment: json['increment'] as String? ?? '0.00',
      amountAfter: json['amount_after'] as String? ?? '0.00',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'bidder_alias': bidderAlias,
        'is_me': isMe,
        'increment': increment,
        'amount_after': amountAfter,
        'created_at': createdAt.toIso8601String(),
      };

  BidItem copyWith({
    String? bidderAlias,
    bool? isMe,
    String? increment,
    String? amountAfter,
    DateTime? createdAt,
  }) {
    return BidItem(
      bidderAlias: bidderAlias ?? this.bidderAlias,
      isMe: isMe ?? this.isMe,
      increment: increment ?? this.increment,
      amountAfter: amountAfter ?? this.amountAfter,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}