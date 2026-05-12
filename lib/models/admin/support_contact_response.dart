class SupportContactResponse {
  final String supportEmail;
  final String supportPhone;

  SupportContactResponse({
    required this.supportEmail,
    required this.supportPhone,
  });

  factory SupportContactResponse.fromJson(Map<String, dynamic> json) {
    return SupportContactResponse(
      supportEmail: json['support_email'] ?? '',
      supportPhone: json['support_phone'] ?? '',
    );
  }
}
