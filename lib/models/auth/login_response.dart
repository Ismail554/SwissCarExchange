import 'package:rionydo/models/profile/user_profile_response.dart';

// ------------------------------------------------------------------
// LOGIN RESPONSE
// ------------------------------------------------------------------
class LoginResponse {
  final bool isTwoFactorRequired;
  final bool isEmailVerified;
  final String access;
  final String refresh;
  final int userId;
  final String email;
  final String role;
  final String approvalStatus;
  final String userType;
  final String company;
  final Subscription? subscription;

  /// Only present when `isTwoFactorRequired == true`
  final String? twoFactorToken;
  final String? message;

  const LoginResponse({
    required this.isTwoFactorRequired,
    required this.isEmailVerified,
    required this.access,
    required this.refresh,
    required this.userId,
    required this.email,
    required this.role,
    required this.approvalStatus,
    required this.userType,
    required this.company,
    this.subscription,
    this.twoFactorToken,
    this.message,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      isTwoFactorRequired: json['is_two_factor_required'] as bool? ?? false,
      isEmailVerified: json['is_email_verified'] as bool? ?? false,
      access: json['access'] as String? ?? '',
      refresh: json['refresh'] as String? ?? '',
      userId: json['user_id'] as int? ?? 0,
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? '',
      approvalStatus: json['approval_status'] as String? ?? '',
      userType: json['user_type'] as String? ?? '',
      company: json['company'] as String? ?? '',
      subscription: json['subscription'] != null
          ? Subscription.fromJson(json['subscription'] as Map<String, dynamic>)
          : null,
      twoFactorToken: json['two_factor_token'] as String?,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'is_two_factor_required': isTwoFactorRequired,
        'is_email_verified': isEmailVerified,
        'access': access,
        'refresh': refresh,
        'user_id': userId,
        'email': email,
        'role': role,
        'approval_status': approvalStatus,
        'user_type': userType,
        'company': company,
        if (subscription != null) 'subscription': subscription!.toJson(),
        if (twoFactorToken != null) 'two_factor_token': twoFactorToken,
        if (message != null) 'message': message,
      };

  LoginResponse copyWith({
    bool? isTwoFactorRequired,
    bool? isEmailVerified,
    String? access,
    String? refresh,
    int? userId,
    String? email,
    String? role,
    String? approvalStatus,
    String? userType,
    String? company,
    Subscription? subscription,
    String? twoFactorToken,
    String? message,
  }) {
    return LoginResponse(
      isTwoFactorRequired: isTwoFactorRequired ?? this.isTwoFactorRequired,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      access: access ?? this.access,
      refresh: refresh ?? this.refresh,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      role: role ?? this.role,
      approvalStatus: approvalStatus ?? this.approvalStatus,
      userType: userType ?? this.userType,
      company: company ?? this.company,
      subscription: subscription ?? this.subscription,
      twoFactorToken: twoFactorToken ?? this.twoFactorToken,
      message: message ?? this.message,
    );
  }
}