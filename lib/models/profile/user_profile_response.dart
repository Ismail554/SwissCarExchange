enum UserType { private, company }

// ------------------------------------------------------------------
// SUBSCRIPTION MODEL
// ------------------------------------------------------------------
class Subscription {
  final bool hasSubscription;
  final String? plan;
  final String? status;
  final DateTime? currentPeriodStart;
  final DateTime? currentPeriodEnd;
  final bool cancelAtPeriodEnd;

  const Subscription({
    required this.hasSubscription,
    this.plan,
    this.status,
    this.currentPeriodStart,
    this.currentPeriodEnd,
    required this.cancelAtPeriodEnd,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      hasSubscription: json['has_subscription'] as bool? ?? false,
      plan: json['plan'] as String?,
      status: json['status'] as String?,
      currentPeriodStart: json['current_period_start'] != null
          ? DateTime.tryParse(json['current_period_start'] as String)
          : null,
      currentPeriodEnd: json['current_period_end'] != null
          ? DateTime.tryParse(json['current_period_end'] as String)
          : null,
      cancelAtPeriodEnd: json['cancel_at_period_end'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'has_subscription': hasSubscription,
        'plan': plan,
        'status': status,
        'current_period_start': currentPeriodStart?.toIso8601String(),
        'current_period_end': currentPeriodEnd?.toIso8601String(),
        'cancel_at_period_end': cancelAtPeriodEnd,
      };
}

// ------------------------------------------------------------------
// BASE / SHARED FIELDS (SEALED CLASS)
// ------------------------------------------------------------------
sealed class UserProfileResponse {
  final int id;
  final String email;
  final String role;
  final String phone;
  final String address;
  final String website;
  final DateTime createdAt;
  final bool isTwoFactorEnabled;
  final Subscription subscription;
  final UserType userType;

  const UserProfileResponse({
    required this.id,
    required this.email,
    required this.role,
    required this.phone,
    required this.address,
    required this.website,
    required this.createdAt,
    required this.isTwoFactorEnabled,
    required this.subscription,
    required this.userType,
  });

  /// Factory: delegates to the correct subclass based on `user_type`.
  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    final type = json['user_type'] as String?;
    return switch (type) {
      'company' => CompanyUserProfile.fromJson(json),
      // Defaults to private if missing or unknown to prevent crashes
      _ => PrivateUserProfile.fromJson(json), 
    };
  }

  Map<String, dynamic> toJson();

  /// Shared fields used by both subclass toJson() methods.
  Map<String, dynamic> baseJson() => {
        'id': id,
        'email': email,
        'role': role,
        'phone': phone,
        'address': address,
        'website': website,
        'created_at': createdAt.toIso8601String(),
        'is_two_factor_enabled': isTwoFactorEnabled,
        'subscription': subscription.toJson(),
        'user_type': userType.name,
      };
}

// ------------------------------------------------------------------
// PRIVATE USER SUBCLASS
// ------------------------------------------------------------------
class PrivateUserProfile extends UserProfileResponse {
  final String photoUrl;
  final String idDocumentUrl;
  final String fullName;

  const PrivateUserProfile({
    required super.id,
    required super.email,
    required super.role,
    required super.phone,
    required super.address,
    required super.website,
    required super.createdAt,
    required super.isTwoFactorEnabled,
    required super.subscription,
    required this.photoUrl,
    required this.idDocumentUrl,
    required this.fullName,
  }) : super(userType: UserType.private);

  factory PrivateUserProfile.fromJson(Map<String, dynamic> json) {
    return PrivateUserProfile(
      id: json['id'] as int? ?? 0,
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      address: json['address'] as String? ?? '',
      website: json['website'] as String? ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      isTwoFactorEnabled: json['is_two_factor_enabled'] as bool? ?? false,
      subscription: json['subscription'] != null
          ? Subscription.fromJson(json['subscription'] as Map<String, dynamic>)
          : const Subscription(hasSubscription: false, cancelAtPeriodEnd: false),
      photoUrl: json['photo_url'] as String? ?? '',
      idDocumentUrl: json['id_document_url'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        ...baseJson(),
        'photo_url': photoUrl,
        'id_document_url': idDocumentUrl,
        'full_name': fullName,
      };

  PrivateUserProfile copyWith({
    int? id,
    String? email,
    String? role,
    String? phone,
    String? address,
    String? website,
    DateTime? createdAt,
    bool? isTwoFactorEnabled,
    Subscription? subscription,
    String? photoUrl,
    String? idDocumentUrl,
    String? fullName,
  }) {
    return PrivateUserProfile(
      id: id ?? this.id,
      email: email ?? this.email,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      website: website ?? this.website,
      createdAt: createdAt ?? this.createdAt,
      isTwoFactorEnabled: isTwoFactorEnabled ?? this.isTwoFactorEnabled,
      subscription: subscription ?? this.subscription,
      photoUrl: photoUrl ?? this.photoUrl,
      idDocumentUrl: idDocumentUrl ?? this.idDocumentUrl,
      fullName: fullName ?? this.fullName,
    );
  }
}

// ------------------------------------------------------------------
// COMPANY USER SUBCLASS
// ------------------------------------------------------------------
class CompanyUserProfile extends UserProfileResponse {
  final String company;
  final String uid;
  final String licenseUrl;

  const CompanyUserProfile({
    required super.id,
    required super.email,
    required super.role,
    required super.phone,
    required super.address,
    required super.website,
    required super.createdAt,
    required super.isTwoFactorEnabled,
    required super.subscription,
    required this.company,
    required this.uid,
    required this.licenseUrl,
  }) : super(userType: UserType.company);

  factory CompanyUserProfile.fromJson(Map<String, dynamic> json) {
    return CompanyUserProfile(
      id: json['id'] as int? ?? 0,
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      address: json['address'] as String? ?? '',
      website: json['website'] as String? ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      isTwoFactorEnabled: json['is_two_factor_enabled'] as bool? ?? false,
      subscription: json['subscription'] != null
          ? Subscription.fromJson(json['subscription'] as Map<String, dynamic>)
          : const Subscription(hasSubscription: false, cancelAtPeriodEnd: false),
      company: json['company'] as String? ?? '',
      uid: json['uid'] as String? ?? '',
      licenseUrl: json['license_url'] as String? ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        ...baseJson(),
        'company': company,
        'uid': uid,
        'license_url': licenseUrl,
      };

  CompanyUserProfile copyWith({
    int? id,
    String? email,
    String? role,
    String? phone,
    String? address,
    String? website,
    DateTime? createdAt,
    bool? isTwoFactorEnabled,
    Subscription? subscription,
    String? company,
    String? uid,
    String? licenseUrl,
  }) {
    return CompanyUserProfile(
      id: id ?? this.id,
      email: email ?? this.email,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      website: website ?? this.website,
      createdAt: createdAt ?? this.createdAt,
      isTwoFactorEnabled: isTwoFactorEnabled ?? this.isTwoFactorEnabled,
      subscription: subscription ?? this.subscription,
      company: company ?? this.company,
      uid: uid ?? this.uid,
      licenseUrl: licenseUrl ?? this.licenseUrl,
    );
  }
}