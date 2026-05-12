class DealerContactResponse {
  final String email;
  final String phone;
  final String company;
  final String address;
  final String website;

  DealerContactResponse({
    required this.email,
    required this.phone,
    required this.company,
    required this.address,
    required this.website,
  });

  factory DealerContactResponse.fromJson(Map<String, dynamic> json) {
    return DealerContactResponse(
      email: json['email'] ?? "",
      phone: json['phone'] ?? "",
      company: json['company'] ?? "",
      address: json['address'] ?? "",
      website: json['website'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'phone': phone,
      'company': company,
      'address': address,
      'website': website,
    };
  }
}