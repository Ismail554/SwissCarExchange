class LoginResponse {
  final bool isTwoFactorRequired;
  final String access;
  final String refresh;
  final int userId;
  final String email;
  final String role;
  final String approvalStatus;
  final String userType;
  final String company;

  LoginResponse({
    required this.isTwoFactorRequired,
    required this.access,
    required this.refresh,
    required this.userId,
    required this.email,
    required this.role,
    required this.approvalStatus,
    required this.userType,
    required this.company,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      isTwoFactorRequired: json['is_two_factor_required'] ?? false,
      access: json['access'] ?? '',
      refresh: json['refresh'] ?? '',
      userId: json['user_id'] ?? 0,
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      approvalStatus: json['approval_status'] ?? '',
      userType: json['user_type'] ?? '',
      company: json['company'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_two_factor_required': isTwoFactorRequired,
      'access': access,
      'refresh': refresh,
      'user_id': userId,
      'email': email,
      'role': role,
      'approval_status': approvalStatus,
      'user_type': userType,
      'company': company,
    };
  }
}