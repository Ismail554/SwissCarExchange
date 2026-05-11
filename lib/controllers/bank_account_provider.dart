import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rionydo/app_utils/constants/api_service.dart';
import 'package:rionydo/app_utils/network/dio_manager.dart';
import 'package:rionydo/app_utils/network/enums.dart';
import 'package:rionydo/models/profile/bank_account_model.dart';

class BankAccountProvider extends ChangeNotifier {
  static const _storage = FlutterSecureStorage();
  static const String _bankAccountCacheKey = 'cached_bank_account';

  BankAccountModel? _bankAccount;
  BankAccountModel? get bankAccount => _bankAccount;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Fetches existing bank details (supports local cache for offline)
  Future<void> fetchBankDetails() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // 1. Try to load cached data first for offline capability
    final cachedData = await _storage.read(key: _bankAccountCacheKey);
    if (cachedData != null) {
      try {
        _bankAccount = BankAccountModel.fromJson(jsonDecode(cachedData));
        notifyListeners(); // update UI instantly with cache
      } catch (e) {
        debugPrint('BANK_ACCOUNT: ❌ Error decoding cache: $e');
      }
    }

    try {
      final response = await DioManager.apiRequest(
        url: ApiService.allBankDetails,
        method: Methods.get,
        skipAuth: false,
      );

      await response.fold(
        (error) async {
          debugPrint('BANK_ACCOUNT: ❌ fetchBankDetails error: $error');
          // If user specifically has no bank account (404/not found), clear cache
          final errLower = error.toLowerCase();
          if (errLower.contains('404') || errLower.contains('not found')) {
            _bankAccount = null;
            await _storage.delete(key: _bankAccountCacheKey);
          } else {
            // Keep local cached details if network is unavailable
            if (_bankAccount == null) {
              _errorMessage = error;
            }
          }
        },
        (data) async {
          debugPrint('BANK_ACCOUNT: ✅ fetchBankDetails success');
          if (data != null && data.isNotEmpty) {
            _bankAccount = BankAccountModel.fromJson(data);
            await _storage.write(
              key: _bankAccountCacheKey,
              value: jsonEncode(data),
            );
          } else {
            _bankAccount = null;
            await _storage.delete(key: _bankAccountCacheKey);
          }
        },
      );
    } catch (e) {
      debugPrint('BANK_ACCOUNT: ❌ Unexpected error: $e');
      // Maintain cached data on connection failures
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Adds new bank details
  Future<bool> addBankDetails(Map<String, dynamic> body) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await DioManager.apiRequest(
        url: ApiService.addBankDetails,
        method: Methods.post,
        body: body,
        skipAuth: false,
      );

      return await response.fold(
        (error) {
          debugPrint('BANK_ACCOUNT: ❌ addBankDetails error: $error');
          _errorMessage = error;
          _isSaving = false;
          notifyListeners();
          return false;
        },
        (data) async {
          debugPrint('BANK_ACCOUNT: ✅ addBankDetails success');
          // Cache the new details instantly
          _bankAccount = BankAccountModel.fromJson(body);
          await _storage.write(
            key: _bankAccountCacheKey,
            value: jsonEncode(body),
          );

          fetchBankDetails(); // Refresh details in background
          _isSaving = false;
          notifyListeners();
          return true;
        },
      );
    } catch (e) {
      debugPrint('BANK_ACCOUNT: ❌ Unexpected error: $e');
      _errorMessage = 'Failed to add bank details. Please try again.';
      _isSaving = false;
      notifyListeners();
      return false;
    }
  }

  /// Modifies existing bank details
  Future<bool> modifyBankDetails(Map<String, dynamic> body) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await DioManager.apiRequest(
        url: ApiService.modifyBankDetails,
        method: Methods.post,
        body: body,
        skipAuth: false,
      );

      return await response.fold(
        (error) {
          debugPrint('BANK_ACCOUNT: ❌ modifyBankDetails error: $error');
          _errorMessage = error;
          _isSaving = false;
          notifyListeners();
          return false;
        },
        (data) async {
          debugPrint('BANK_ACCOUNT: ✅ modifyBankDetails success');
          // Cache updated details instantly
          _bankAccount = BankAccountModel.fromJson(body);
          await _storage.write(
            key: _bankAccountCacheKey,
            value: jsonEncode(body),
          );

          fetchBankDetails(); // Refresh details in background
          _isSaving = false;
          notifyListeners();
          return true;
        },
      );
    } catch (e) {
      debugPrint('BANK_ACCOUNT: ❌ Unexpected error: $e');
      _errorMessage = 'Failed to modify bank details. Please try again.';
      _isSaving = false;
      notifyListeners();
      return false;
    }
  }

  /// Deletes existing bank details
  Future<bool> deleteBankDetails() async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await DioManager.apiRequest(
        url: ApiService.deleteBankDetails,
        method: Methods.delete,
        skipAuth: false,
      );

      return await response.fold(
        (error) {
          debugPrint('BANK_ACCOUNT: ❌ deleteBankDetails error: $error');
          _errorMessage = error;
          _isSaving = false;
          notifyListeners();
          return false;
        },
        (data) async {
          debugPrint('BANK_ACCOUNT: ✅ deleteBankDetails success');
          _bankAccount = null;
          await _storage.delete(key: _bankAccountCacheKey);
          _isSaving = false;
          notifyListeners();
          return true;
        },
      );
    } catch (e) {
      debugPrint('BANK_ACCOUNT: ❌ Unexpected error: $e');
      _errorMessage = 'Failed to delete bank details. Please try again.';
      _isSaving = false;
      notifyListeners();
      return false;
    }
  }
}
