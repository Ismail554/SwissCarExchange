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
  
  // Forgot Password
  static String get forgotPassword => "$baseUrl/api/auth/reset-password/request/"; // body: {"email": ""}
  static String get verifyResetPasswordCode => "$baseUrl/api/auth/reset-password/verify/"; // body: {"email": "", "code": ""}
  static String get resetPassword => "$baseUrl/api/auth/reset-password/reset/"; // body: {"email": "", "new_password": "", "password_reset_token": ""}
  
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

  // Review & Wishlist
  static String createWishlist(String auctionId) => "$baseUrl/api/auctions/$auctionId/watchlist/";
  static String get myWishlists => "$baseUrl/api/auctions/watchlist/";

  // Bid
  static String placeBid(String auctionId) => "$baseUrl/api/auctions/$auctionId/bid/"; // POST body: { "amount": "12000" }
  static String bidHistory(String auctionId) => "$baseUrl/api/auctions/$auctionId/bid/history/"; // GET
  static String autoBidCreate(String auctionId) => "$baseUrl/api/auctions/$auctionId/auto-bid/"; // POST body: { "max_amount": "12000" }
  static String autoBidDelete(String auctionId) => "$baseUrl/api/auctions/$auctionId/auto-bid/delete/"; // DELETE
  static String bidStatus(String auctionId) => "$baseUrl/api/auctions/$auctionId/auto-bid/status"; // GET

  // Device Register
  static String get registerDevice => "$baseUrl/api/notifications/devices/register/"; // POST body: { "token": "...", "device_type": "..." }
  static String get unregisterDevice => "$baseUrl/api/notifications/devices/remove/"; // POST body: {   "token": "" }
  static String get notificationPreferences => "$baseUrl/api/notifications/preferences/"; // GET // response: { "new_auction_enabled": true, "auction_updates_enabled": true, "admin_messages_enabled": true }
  static String get updateNotificationPreferences => "$baseUrl/api/notifications/preferences/update/"; // PUT // body: { "new_auction_enabled": true, "auction_updates_enabled": true, "admin_messages_enabled": true }
  static String get readAllNotifications => "$baseUrl/api/notifications/read-all/"; // POST
  static String get notificationCount => "$baseUrl/api/notifications/unread-count/"; // GET // response: { "unread_count": 1 }
  static String get notifications => "$baseUrl/api/notifications/"; // GET 

// Transaction 
// non premium user
static String get bidderStats => "$baseUrl/api/analytics/bidder-stats/"; // GET
static String get bidderTransaction => "$baseUrl/api/analytics/bidder-transactions/"; // GET
static String get dealerTransaction => "$baseUrl/api/analytics/dealer-transactions/"; // GET
// 






}