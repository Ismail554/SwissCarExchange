import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  static String get baseUrl =>
      dotenv.env['BASE_URL'] ??
      "https://doleritic-goutily-shila.ngrok-free.dev";

  //Auth
  static String get register => "$baseUrl/api/auth/register/";
  static String get login => "$baseUrl/api/auth/login/";
  static String get refreshToken =>
      "$baseUrl/api/auth/token/refresh/"; // body: {"refresh": ""}
  static String get resendOtp =>
      "$baseUrl/api/auth/resend-verification-code/"; // body: {"email": ""}
  static String get verifyOtp =>
      "$baseUrl/api/auth/verify-email/"; // body: {"code": "994405", "email": ""}
  static String get authStatus =>
      "$baseUrl/api/auth/status/"; // validate with access token // response : {"approval_status": "approved"} or {"approval_status": "pending"} or {"approval_status": "suspended"}
  static String get logout =>
      "$baseUrl/api/auth/logout/"; // POST // body: { "refresh": "" }
  // Forgot Password
  static String get forgotPassword =>
      "$baseUrl/api/auth/reset-password/request/"; // body: {"email": ""}
  static String get verifyResetPasswordCode =>
      "$baseUrl/api/auth/reset-password/verify/"; // body: {"email": "", "code": ""}
  static String get resetPassword =>
      "$baseUrl/api/auth/reset-password/reset/"; // body: {"email": "", "new_password": "", "password_reset_token": ""}

  // 2FA
  static String get verify2fa =>
      "$baseUrl/api/auth/login/two-factor/verify/"; // body: {"email": "", "two_factor_token": "", "code": ""}

  // Presigned URL — append ?content_type=...&file_name=... dynamically
  static String get presignedUrl => "$baseUrl/api/auth/register/presigned-url/";

  // Profile
  static String get userProfile => "$baseUrl/api/users/me/";
  static String get updateProfile => "$baseUrl/api/users/me/update/"; //PATCH

  // Subscriptions
  static String get subscriptionStatus => "$baseUrl/api/subscriptions/me/";
  static String get subscriptionPlans => "$baseUrl/api/subscriptions/plans/";
  static String get subscriptionCheckout =>
      "$baseUrl/api/subscriptions/checkout/";

  // Auctions
  static String get createAuction => "$baseUrl/api/auctions/create/";
  static String get auctionPresignedUrl =>
      "$baseUrl/api/auctions/upload/presigned-url/"; //allowed "content_type": [ "application/pdf", "image/jpeg", "image/png", "image/webp", "video/mp4", "video/quicktime", "video/webm" ]
  static String editAuction(String auctionId) =>
      "$baseUrl/api/auctions/$auctionId/update/"; //PUT
  static String get myAuctions => "$baseUrl/api/auctions/";
  static String auctionDetail(String auctionId) =>
      "$baseUrl/api/auctions/$auctionId/";

  // Review & Wishlist
  static String createWishlist(String auctionId) =>
      "$baseUrl/api/auctions/$auctionId/watchlist/";
  static String get myWishlists => "$baseUrl/api/auctions/watchlist/";

  // Bid
  static String placeBid(String auctionId) =>
      "$baseUrl/api/auctions/$auctionId/bid/"; // POST body: { "amount": "12000" }
  static String bidHistory(String auctionId) =>
      "$baseUrl/api/auctions/$auctionId/bid/history/"; // GET
  static String autoBidCreate(String auctionId) =>
      "$baseUrl/api/auctions/$auctionId/auto-bid/"; // POST body: { "max_amount": "12000" }
  static String autoBidDelete(String auctionId) =>
      "$baseUrl/api/auctions/$auctionId/auto-bid/delete/"; // DELETE
  static String bidStatus(String auctionId) =>
      "$baseUrl/api/auctions/$auctionId/auto-bid/status"; // GET

  // Device Register
  static String get registerDevice =>
      "$baseUrl/api/notifications/devices/register/"; // POST body: { "token": "...", "device_type": "..." }
  static String get unregisterDevice =>
      "$baseUrl/api/notifications/devices/remove/"; // POST body: {   "token": "" }
  static String get notificationPreferences =>
      "$baseUrl/api/notifications/preferences/"; // GET // response: { "new_auction_enabled": true, "auction_updates_enabled": true, "admin_messages_enabled": true }
  static String get updateNotificationPreferences =>
      "$baseUrl/api/notifications/preferences/update/"; // PUT // body: { "new_auction_enabled": true, "auction_updates_enabled": true, "admin_messages_enabled": true }
  static String get readAllNotifications =>
      "$baseUrl/api/notifications/read-all/"; // POST
  static String get notificationCount =>
      "$baseUrl/api/notifications/unread-count/"; // GET // response: { "unread_count": 1 }
  static String get notifications => "$baseUrl/api/notifications/"; // GET

  // Transaction
  // non premium user
  static String get bidderStats =>
      "$baseUrl/api/analytics/bidder-stats/"; // GET
  static String get bidderTransaction =>
      "$baseUrl/api/analytics/bidder-transactions/"; // GET
  static String get dealerTransaction =>
      "$baseUrl/api/analytics/dealer-transactions/"; // GET
  // Analytics
  static String spendingOverviewTends(int period) =>
      "$baseUrl/api/analytics/spending-trends/?period=$period"; // GET // Response: { "spending_trends": [ { "label": "May 2026", "amount": "120450.00" } ] }

  // Premium analytics
  static String get premiumStats => "$baseUrl/api/analytics/stats/"; // GET
  static String get premiumTrands => "$baseUrl/api/analytics/trands/"; // GET
  static String get salesByCategory =>
      "$baseUrl/api/analytics/sales-by-category/"; // GET

  static String get advanceStatistics => "$baseUrl/api/analytics/stats/"; // GET

  // Review
  static String get allReviews => "$baseUrl/api/auctions/me/reviews/";
  static String get overallRating =>
      "$baseUrl/api/auctions/me/overall-rating/"; // response: { "overall_rating": 2.0, "total_review_count": 1 }
  static String reviewAndRating(String auctionId) =>
      "$baseUrl/api/auctions/$auctionId/review/"; // Body: { "communication_rating": 4, "transaction_reliability_rating": 3, "vehicle_accuracy_rating": 4, "review_text": "Ismail To superuser" }

  // Auction Management
  static String get auctionManagement =>
      "$baseUrl/api/auctions/me/"; // ?status= `active` - Active * `sold` - Sold * `unsold` - Unsold * `withdrawn` - Withdrawn

  // Bank
  static String get allBankDetails =>
      "$baseUrl/api/users/me/bank-account"; // GET // response: { "bank_name": "", "account_name": "", "iban": "" }
  static String get addBankDetails =>
      "$baseUrl/api/users/me/bank-account/create/"; // POST // body:{ "bank_name": "", "account_name": " account holder name", "iban": "" }
  static String get modifyBankDetails =>
      "$baseUrl/api/users/me/bank-account/update/"; // POST // body:{ "bank_name": "", "account_name": " account holder name", "iban": "" }
  static String get deleteBankDetails =>
      "$baseUrl/api/users/me/bank-account/delete/"; // DELETE

  // Won Auction
  static String get wonAuction => "$baseUrl/api/auctions/me/bid/?filter=won";

  // Dealer Contact
  static String dealerContact(String auctionId) =>
      "$baseUrl/api/auctions/$auctionId/dealer-contact/";

  //  Payment
  static String paymentInfo(String auctionId) =>
      "$baseUrl/api/auctions/$auctionId/transaction/payment-info/"; // GET
  static String markPayment(String auctionId) =>
      "$baseUrl/api/auctions/$auctionId/transaction/mark-payment/"; // POST // respone: { "status": "payment_done", "payment_marked_at": "2026-05-11T23:44:44.667087Z", "shipping_deadline": "2026-05-18T23:44:44.667087Z" }
  // after chosseShipping then markShipping
  static String chooseShipping(String auctionId) =>
      "$baseUrl/api/auctions/$auctionId/transaction/choose-shipping/"; // POST // respone: { "auction_id": 26, "status": "shipping_pending", "shipping_method": "local_pickup", "shipping_deadline": "2026-05-18T23:44:44.667087Z" }
  static String markShipping(String auctionId) =>
      "$baseUrl/api/auctions/$auctionId/transaction/mark-shipping-done/"; // POST // response : { "auction_id": 26, "status": "completed", "shipping_marked_at": "2026-05-12T00:38:08.302624Z" }

  //  Support & Chat
  static String get getSupportContact =>
      "$baseUrl/api/admin/support-contact/"; // GET // response: { "support_email": "", "support_phone": "" }
  static String get startChat =>
      "$baseUrl/api/users/chat/start/"; // POST // body: { "body": "", "attachments": [ { "object_key": "chat-attachmensstsc.pdf", "public_url": "https://cdn.com/t.pdf", "content_type": "application/pdf", "file_name": "t.pdf", "size_bytes": 248123 } ] } // response: { "conversation_id": 2, "message": { "id": 16, "conversation_id": 2, "body": "", "message_type": "text_with_attachment", "created_at": "2026-05-12T21:22:42.416149Z", "sender": { "id": 6, "email": "superuser@jvai.com", "role_kind": "dealer" }, "attachments": [ { "id": 8, "object_key": "chat-attachmenssts/12/2026/04/kyc-d5c.pdf", "public_url": "https://cdn.example.com/chat-attachments/12/2026/04/kyc-doc.pdf", "content_type": "application/pdf", "file_name": "kyc-doc.pdf", "size_bytes": 248123 } ] } }
  static String get chatHistory =>
      "$baseUrl/api/users/chat/messages/"; // GET // response: { "messages": [ { "id": 1, "sender": "user", "content": "Hi, I need help with my account verification.", "timestamp": "2026-05-12T14:45:32.823102Z", "attachments": [ { "object_key": "chat-attachments/12/2026/04/kyc-doc.pdf", "public_url": "https://cdn.example.com/chat-attachments/12/2026/04/kyc-doc.pdf", "content_type": "application/pdf", "file_name": "kyc-doc.pdf", "size_bytes": 248123 } ] } ] }
  static String get sendMessage =>
      "$baseUrl/api/users/chat/messages/send/"; // POST // body: { "body": "Please find the updated document.", "attachments": [ { "object_key": "chat-attachmendsaasssts/12/2026/04/doc-2.pdf", "public_url": "https://cdn.example.com/chat-attacsdshments/12/2026/04/doc-2.pdf", "content_type": "application/pdf", "file_name": "doc-22.pdf", "size_bytes": 78421 } ] }
  static String get attachmentPreUrl =>
      "$baseUrl/api/users/chat/upload/presigned-url/"; // with Params content_type , file_name // response: { "presigned_url": "https://", "object_key": "chat-attachments/6/2026/05/d7dda647c8216d3.png", "public_url": "https://pub-25400/d3.png", "content_type": "image/png" }
}
