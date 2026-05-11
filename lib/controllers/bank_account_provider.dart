import 'package:flutter/material.dart';
import 'package:rionydo/app_utils/constants/api_service.dart';
import 'package:rionydo/app_utils/network/dio_manager.dart';
import 'package:rionydo/app_utils/network/enums.dart';
import 'package:rionydo/models/profile/bank_account_model.dart';

class BankAccountProvider extends ChangeNotifier {
  BankAccountModel? _bankAccount;
  BankAccountModel? get bankAccount => _bankAccount;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Fetches existing bank details
  Future<void> fetchBankDetails() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await DioManager.apiRequest(
        url: ApiService.allBankDetails,
        method: Methods.get,
        skipAuth: false,
      );

      response.fold(
        (error) {
          debugPrint('BANK_ACCOUNT: ❌ fetchBankDetails error: $error');
          // If no bank details exist, it might return a 404 or specific error.
          // We set it to null so the UI can show the add form.
          _bankAccount = null;
        },
        (data) {
          debugPrint('BANK_ACCOUNT: ✅ fetchBankDetails success');
          if (data != null && data.isNotEmpty) {
            _bankAccount = BankAccountModel.fromJson(data);
          } else {
            _bankAccount = null;
          }
        },
      );
    } catch (e) {
      debugPrint('BANK_ACCOUNT: ❌ Unexpected error: $e');
      _bankAccount = null;
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

      return response.fold(
        (error) {
          debugPrint('BANK_ACCOUNT: ❌ addBankDetails error: $error');
          _errorMessage = error;
          _isSaving = false;
          notifyListeners();
          return false;
        },
        (data) {
          debugPrint('BANK_ACCOUNT: ✅ addBankDetails success');
          // Refresh the details
          fetchBankDetails();
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

      return response.fold(
        (error) {
          debugPrint('BANK_ACCOUNT: ❌ modifyBankDetails error: $error');
          _errorMessage = error;
          _isSaving = false;
          notifyListeners();
          return false;
        },
        (data) {
          debugPrint('BANK_ACCOUNT: ✅ modifyBankDetails success');
          // Refresh the details
          fetchBankDetails();
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

      return response.fold(
        (error) {
          debugPrint('BANK_ACCOUNT: ❌ deleteBankDetails error: $error');
          _errorMessage = error;
          _isSaving = false;
          notifyListeners();
          return false;
        },
        (data) {
          debugPrint('BANK_ACCOUNT: ✅ deleteBankDetails success');
          _bankAccount = null;
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
