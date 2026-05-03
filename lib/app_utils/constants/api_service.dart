class ApiService {
  static String baseUrl = "https://doleritic-goutily-shila.ngrok-free.dev";

  //Auth
  static String register = "$baseUrl/api/auth/register/";
  static String login = "$baseUrl/api/auth/login/";
  static String resendOtp = "$baseUrl/api/auth/resend-verification-code/"; // body: {"email": ""}
  static String verifyOtp = "$baseUrl/api/auth/verify-email/"; // body: {"code": "994405", "email": ""}
  

  // Presigned URL — append ?content_type=...&file_name=... dynamically
  static String presignedUrl = "$baseUrl/api/auth/register/presigned-url/";

}