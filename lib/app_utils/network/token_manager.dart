import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:rionydo/app_helper/secure_storage_helper.dart';
import 'package:rionydo/app_utils/constants/api_service.dart';


/// Handles access token caching, validation, and refresh lifecycle.
class TokenManager {
  TokenManager._();

  static String? _cachedToken;
  static DateTime? _cachedAt;
  static Future<String?>? _refreshLock;

  static const _cacheValidMinutes = 5;
  static const _tag = 'TOKEN';

  static void clear() {
    _cachedToken = null;
    _cachedAt = null;
    _refreshLock = null;
  }

  static Future<void> logout() async {
    await SecureStorageHelper.clearSession();
    clear();
  }

  static Future<String?> getValidToken() async {
    if (_isCacheValid()) {
      log('🟢 Using cached token', name: _tag);
      return _cachedToken;
    }

    final stored = await SecureStorageHelper.getAccessToken();
    if (stored != null && stored.isNotEmpty) {
      log('🟢 Using stored token', name: _tag);
      _setCache(stored);
      return stored;
    }

    return _refresh();
  }

  static bool _isCacheValid() =>
      _cachedToken != null &&
      _cachedAt != null &&
      DateTime.now().difference(_cachedAt!).inMinutes < _cacheValidMinutes;

  static void _setCache(String token) {
    _cachedToken = token;
    _cachedAt = DateTime.now();
  }

  static Future<String?> _refresh() async {
    // Lock prevents concurrent refresh calls
    if (_refreshLock != null) return _refreshLock;

    final completer = Completer<String?>();
    _refreshLock = completer.future;

    try {
      final refreshToken = await SecureStorageHelper.getRefreshToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        log('⚠️ No refresh token found', name: _tag);
        completer.complete(null);
        return null;
      }

      log('🔄 Refreshing access token...', name: _tag);

      final dio = Dio(BaseOptions(baseUrl: ApiService.baseUrl));
      final response = await dio.post(
        '/auth/token/refresh/',
        data: {'refresh': refreshToken},
      );

      if (response.statusCode == 200) {
        final newAccess = response.data['access'] as String?;
        final newRefresh = response.data['refresh'] as String?;

        if (newAccess != null && newAccess.isNotEmpty) {
          _setCache(newAccess);
          await SecureStorageHelper.saveAccessToken(newAccess);

          if (newRefresh != null && newRefresh.isNotEmpty) {
            await SecureStorageHelper.saveRefreshToken(newRefresh);
          }

          log('✅ Token refreshed', name: _tag);
          completer.complete(newAccess);
          return newAccess;
        }
      }

      log('❌ Invalid refresh response [${response.statusCode}]', name: _tag);
      await logout();
      completer.complete(null);
      return null;
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      log('❌ Refresh failed [$status]: ${e.message}', name: _tag);

      if (status == 400 || status == 401) await logout();

      completer.complete(null);
      return null;
    } finally {
      _refreshLock = null;
    }
  }
}