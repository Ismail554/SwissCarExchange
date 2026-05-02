class ApiService {
  static String baseUrl = "https://doleritic-goutily-shila.ngrok-free.dev";

  //Auth
  static String register = "$baseUrl/api/auth/register/";
  static String login = "$baseUrl/api/auth/login/";

  // Presigned URL — append ?content_type=...&file_name=... dynamically
  static String presignedUrl = "$baseUrl/api/auth/register/presigned-url/";
}