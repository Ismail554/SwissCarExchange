import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:rionydo/app_utils/constants/api_service.dart';
import 'package:rionydo/app_utils/network/token_manager.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SocketService {
  WebSocketChannel? _channel;
  ValueNotifier<bool> isConnected = ValueNotifier(false);
  
  // Broadcast stream for all incoming WebSocket events
  final StreamController<Map<String, dynamic>> _eventController = StreamController.broadcast();
  Stream<Map<String, dynamic>> get events => _eventController.stream;

  // Reconnection logic
  int _retryCount = 0;
  Timer? _reconnectTimer;
  String? _lastAuctionId;
  bool _isManuallyClosed = false;

  // Singleton
  static final SocketService instance = SocketService._internal();
  SocketService._internal();
  factory SocketService() => instance;

  /// 🔹 Connect to WebSocket for a specific auction
  Future<void> connectToAuction(String auctionId) async {
    _lastAuctionId = auctionId;
    _isManuallyClosed = false;

    if (isConnected.value && _channel != null) {
      _closeInternal();
    }

    debugPrint("🔹 Connecting to WebSocket for auction $auctionId... (Attempt: ${_retryCount + 1})");

    try {
      // Get the latest valid token
      final token = await TokenManager.getValidToken();
      if (token == null || token.isEmpty) {
        debugPrint("⚠️ WebSocket Connection Failed: No valid token available.");
        return;
      }

      // Construct the WebSocket URL. Prefer SOCKET_URL from .env if defined.
      final String? envWsUrl = dotenv.env['SOCKET_URL'];
      String wsUrl;
      
      if (envWsUrl != null && envWsUrl.isNotEmpty) {
        wsUrl = '$envWsUrl/ws/auctions/$auctionId/?token=$token';
      } else {
        final String baseUrl = ApiService.baseUrl;
        final String wsBaseUrl = baseUrl.startsWith('https') 
            ? baseUrl.replaceFirst('https', 'wss') 
            : baseUrl.replaceFirst('http', 'ws');
        wsUrl = '$wsBaseUrl/ws/auctions/$auctionId/?token=$token';
      }
      
      final uri = Uri.parse(wsUrl);

      _channel = IOWebSocketChannel.connect(uri);
      debugPrint("🟢 WebSocket Connection Initiated to $wsUrl");

      // Listen to the stream
      _channel!.stream.listen(
        (message) {
          _retryCount = 0; // Reset retry count on successful message
          if (!isConnected.value) {
            isConnected.value = true;
          }
          _handleMessage(message);
        },
        onError: (error) {
          debugPrint("⚠️ WebSocket Error: $error");
          isConnected.value = false;
          _handleReconnect();
        },
        onDone: () {
          debugPrint("🔴 WebSocket Disconnected");
          isConnected.value = false;
          if (!_isManuallyClosed) {
            _handleReconnect();
          }
        },
      );
    } catch (e) {
      debugPrint("⚠️ WebSocket Connection Failed: $e");
      isConnected.value = false;
      _handleReconnect();
    }
  }

  void _handleReconnect() {
    if (_isManuallyClosed || _lastAuctionId == null) return;

    _reconnectTimer?.cancel();
    
    _retryCount++;
    // Exponential backoff: 2s, 4s, 8s, 16s, max 30s
    int delaySeconds = (pow(2, _retryCount).toInt()).clamp(2, 30);
    
    debugPrint("🔄 Scheduling WebSocket reconnection in $delaySeconds seconds...");
    _reconnectTimer = Timer(Duration(seconds: delaySeconds), () {
      connectToAuction(_lastAuctionId!);
    });
  }

  void _handleMessage(dynamic message) {
    try {
      if (message is String) {
        final data = jsonDecode(message);
        debugPrint(
            "📌 WebSocket Message: ${message.length > 200 ? '${message.substring(0, 200)}...' : message}");

        if (data is Map<String, dynamic>) {
          // Push event to listeners (UI or Providers)
          _eventController.sink.add(data);
        }
      }
    } catch (e, stack) {
      debugPrint("⚠️ Error parsing WebSocket message: $e");
      debugPrint("⚠️ Stack trace: $stack");
    }
  }

  /// 🔌 Internal close
  void _closeInternal() {
    if (_channel != null) {
      _channel!.sink.close();
      _channel = null;
    }
    _reconnectTimer?.cancel();
    isConnected.value = false;
  }

  /// 🔌 Disconnect socket manually
  void disconnect() {
    _isManuallyClosed = true;
    _lastAuctionId = null;
    _closeInternal();
    debugPrint("🛑 WebSocket manually closed");
  }
}

// Add power function for backoff
num pow(num x, num y) {
  num result = 1;
  for (int i = 0; i < y; i++) {
    result *= x;
  }
  return result;
}
