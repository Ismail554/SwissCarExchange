import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

class LocalStorageService {
  // single secure storage instance
  static const _storage = FlutterSecureStorage();

  /// ✅ Save theme securely
  static Future<void> saveTheme(String theme) async {
    await _storage.write(key: "theme", value: theme);
  }

  /// ✅ Get saved theme securely
  static Future<String?> getTheme() async {
    return await _storage.read(key: "theme");
  }

  /// ✅ Optional: Clear theme if needed
  static Future<void> clearTheme() async {
    await _storage.delete(key: "theme");
  }
}

class SecureStorageHelper {
  static const _storage = FlutterSecureStorage();

  // Token keys
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  /// Save access token
  static Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  /// Get access token
  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  /// Save refresh token
  static Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  /// Get refresh token
  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  /// Clear all tokens, user data and user type (Full session reset)
  static Future<void> clearSession() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _userTypeKey);
    await _storage.delete(key: _userKey);
  }

  /// Clear access token only
  static Future<void> clearAccessToken() async {
    await _storage.delete(key: _accessTokenKey);
  }

  /// Clear refresh token only
  static Future<void> clearRefreshToken() async {
    await _storage.delete(key: _refreshTokenKey);
  }

  // UUID key
  static const String _uuidKey = 'device_uuid';

  /// Get or Generate UUID
  static Future<String> getUuid() async {
    String? uuid = await _storage.read(key: _uuidKey);
    if (uuid == null || uuid.isEmpty) {
      uuid = const Uuid().v4();
      await _storage.write(key: _uuidKey, value: uuid);
    }
    return uuid;
  }

  /// Check if UUID exists (First time user check)
  static Future<bool> hasUuid() async {
    String? uuid = await _storage.read(key: _uuidKey);
    return uuid != null && uuid.isNotEmpty;
  }

  // User type key
  static const String _userTypeKey = 'user_type';

  /// Save user type
  static Future<void> saveUserType(String userType) async {
    await _storage.write(key: _userTypeKey, value: userType);
  }

  /// Get user type
  static Future<String?> getUserType() async {
    return await _storage.read(key: _userTypeKey);
  }

  /// Clear user type
  static Future<void> clearUserType() async {
    await _storage.delete(key: _userTypeKey);
  }

  // User object key
  static const String _userKey = 'user_data';

  /// Save user object safely
  static Future<void> saveUser(String userJson) async {
    await _storage.write(key: _userKey, value: userJson);
  }

  /// Get user object
  static Future<String?> getUser() async {
    return await _storage.read(key: _userKey);
  }

  /// Clear user object
  static Future<void> clearUser() async {
    await _storage.delete(key: _userKey);
  }

  // Notification toggle key
  static const String _notificationsKey = 'notifications_enabled';

  /// Save notification status
  static Future<void> saveNotificationStatus(bool isEnabled) async {
    await _storage.write(key: _notificationsKey, value: isEnabled.toString());
  }

  /// Get notification status (default true)
  static Future<bool> getNotificationStatus() async {
    final val = await _storage.read(key: _notificationsKey);
    return val == null || val == 'true'; // Default to true if not set
  }
}
