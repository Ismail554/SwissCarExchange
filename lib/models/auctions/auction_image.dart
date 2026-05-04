class AuctionImage {
  final String url;
  final int position;

  const AuctionImage({
    required this.url,
    required this.position,
  });

  factory AuctionImage.fromJson(Map<String, dynamic> json) {
    return AuctionImage(
      url: json['url'] as String? ?? '',
      position: json['position'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'url': url,
        'position': position,
      };

  AuctionImage copyWith({
    String? url,
    int? position,
  }) {
    return AuctionImage(
      url: url ?? this.url,
      position: position ?? this.position,
    );
  }
}
