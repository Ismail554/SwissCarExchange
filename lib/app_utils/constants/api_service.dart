import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  static String get baseUrl => dotenv.env['BASE_URL'] ?? "https://doleritic-goutily-shila.ngrok-free.dev";

  //Auth
  static String get register => "$baseUrl/api/auth/register/";
  static String get login => "$baseUrl/api/auth/login/";
  static String get refreshToken => "$baseUrl/api/auth/token/refresh/"; // body: {"refresh": ""}
  static String get resendOtp => "$baseUrl/api/auth/resend-verification-code/"; // body: {"email": ""}
  static String get verifyOtp => "$baseUrl/api/auth/verify-email/"; // body: {"code": "994405", "email": ""}
  static String get authStatus => "$baseUrl/api/auth/status/"; // validate with access token // response : {"approval_status": "approved"} or {"approval_status": "pending"} or {"approval_status": "suspended"}
  
  // 2FA
  static String get verify2fa => "$baseUrl/api/auth/login/two-factor/verify/"; // body: {"email": "", "two_factor_token": "", "code": ""}

  // Presigned URL — append ?content_type=...&file_name=... dynamically
  static String get presignedUrl => "$baseUrl/api/auth/register/presigned-url/";

  // Profile
  static String get userProfile => "$baseUrl/api/users/me/";
  static String get updateProfile => "$baseUrl/api/users/me/update/"; //PATCH

  // Subscriptions
  static String get subscriptionStatus => "$baseUrl/api/subscriptions/me/";
  static String get subscriptionPlans => "$baseUrl/api/subscriptions/plans/";
  static String get subscriptionCheckout => "$baseUrl/api/subscriptions/checkout/";

  // Auctions
  static String get createAuction => "$baseUrl/api/auctions/create/";
  static String get auctionPresignedUrl => "$baseUrl/api/auctions/upload/presigned-url/"; //allowed "content_type": [ "application/pdf", "image/jpeg", "image/png", "image/webp", "video/mp4", "video/quicktime", "video/webm" ]
  static String editAuction(String auctionId) => "$baseUrl/api/auctions/$auctionId/update/"; //PUT
  static String get myAuctions => "$baseUrl/api/auctions/";
  static String auctionDetail(String auctionId) => "$baseUrl/api/auctions/$auctionId/";
}