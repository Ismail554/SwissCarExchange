class NotificationResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<NotificationItem> results;

  NotificationResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) => NotificationResponse(
        count: json["count"] ?? 0,
        next: json["next"],
        previous: json["previous"],
        results: json["results"] == null 
            ? [] 
            : List<NotificationItem>.from(json["results"].map((x) => NotificationItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}

class NotificationItem {
  final int id;
  final String category;
  final String notificationType;
  final String title;
  final String body;
  final NotificationData data;
  final DateTime? readAt;
  final DateTime createdAt;

  NotificationItem({
    required this.id,
    required this.category,
    required this.notificationType,
    required this.title,
    required this.body,
    required this.data,
    this.readAt,
    required this.createdAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) => NotificationItem(
        id: json["id"] ?? 0,
        category: json["category"] ?? '',
        notificationType: json["notification_type"] ?? '',
        title: json["title"] ?? '',
        body: json["body"] ?? '',
        data: json["data"] != null ? NotificationData.fromJson(json["data"]) : NotificationData(),
        readAt: json["read_at"] == null ? null : DateTime.tryParse(json["read_at"]),
        createdAt: json["created_at"] == null ? DateTime.now() : DateTime.tryParse(json["created_at"]) ?? DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category": category,
        "notification_type": notificationType,
        "title": title,
        "body": body,
        "data": data.toJson(),
        "read_at": readAt?.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
      };
}

class NotificationData {
  final int? auctionId;
  final String? newAmount;

  NotificationData({
    this.auctionId,
    this.newAmount,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) => NotificationData(
        auctionId: json["auction_id"],
        newAmount: json["new_amount"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "auction_id": auctionId,
        "new_amount": newAmount,
      };
}