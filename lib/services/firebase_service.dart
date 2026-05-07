import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rionydo/app_utils/constants/api_service.dart';
import 'package:rionydo/app_utils/network/dio_manager.dart';
import 'package:rionydo/app_utils/network/enums.dart';


// FCM register and notificaiton service
class FirebaseService {
  static Future<void> initFirebaseMessaging() async {
    if (kIsWeb) return;
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        String? token = await messaging.getToken();
        if (token != null) {
          String deviceType = Platform.isIOS ? 'ios' : 'android';
          await DioManager.apiRequest(
            url: ApiService.registerDevice,
            method: Methods.post,
            body: {
              "token": token,
              "device_type": deviceType,
            },
          );
          debugPrint("FCM token registered");
        }

        FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
          String deviceType = Platform.isIOS ? 'ios' : 'android';
          await DioManager.apiRequest(
            url: ApiService.registerDevice,
            method: Methods.post,
            body: {
              "token": newToken,
              "device_type": deviceType,
            },
          );
        });
      }
    } catch (e) {
      debugPrint("FCM Error: $e");
    }
  }

  static Future<void> unregisterFirebaseMessaging() async {
    if (kIsWeb) return;
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await DioManager.apiRequest(
          url: ApiService.unregisterDevice,
          method: Methods.post,
          body: {
            "token": token,
          },
        );
        debugPrint("FCM token unregistered");
      }
    } catch (e) {
      debugPrint("FCM Unregister Error: \$e");
    }
  }
}