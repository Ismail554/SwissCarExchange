import 'dart:io';
import 'package:flutter/material.dart';
import 'package:rionydo/app_helper/s3_upload_helper.dart';
import 'package:rionydo/app_utils/constants/api_service.dart';
import 'package:rionydo/app_utils/network/dio_manager.dart';
import 'package:rionydo/app_utils/network/enums.dart';
import 'package:rionydo/core/widgets/widget_snackbar.dart';

class CreateAuctionProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _minAuctionDurationHours = 12;
  int _maxAuctionDurationHours = 360;
  int _minBidIncrement = 180;

  int get minAuctionDurationHours => _minAuctionDurationHours;
  int get maxAuctionDurationHours => _maxAuctionDurationHours;
  int get minBidIncrement => _minBidIncrement;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> fetchAuctionConfig() async {
    final response = await DioManager.apiRequest(
      url: ApiService.auctionCofig,
      method: Methods.get,
    );
    response.fold(
      (error) {
        // Quietly fall back to defaults
      },
      (data) {
        if (data is Map<String, dynamic>) {
          _minAuctionDurationHours = data['min_auction_duration_hours'] ?? 12;
          _maxAuctionDurationHours = data['max_auction_duration_hours'] ?? 360;
          _minBidIncrement = data['min_bid_increment'] ?? 180;
          notifyListeners();
        }
      },
    );
  }

  Future<bool> createAuction({
    required BuildContext context,
    required String title,
    required String description,
    required String brand,
    required String model,
    required String category,
    required int year,
    required int mileage,
    required String vin,
    required String fuelType,
    required String location,
    required String reservePrice,
    required String buyNowPrice,
    required String startsAt,
    required String endsAt,
    required List<File> images,
    File? video,
    File? document,
  }) async {
    _setLoading(true);

    try {
      // 1. Upload Images
      List<String> imageUrls = [];
      for (var file in images) {
        final url = await S3UploadHelper.presignAndUpload(
          file,
          presignedEndpoint: ApiService.auctionPresignedUrl,
        );
        if (url != null) {
          imageUrls.add(url);
        }
      }

      if (imageUrls.isEmpty) {
        if (context.mounted) {
          AppSnackBar.error(context, "Failed to upload images.");
        }
        _setLoading(false);
        return false;
      }

      // 2. Upload Video (if any)
      String videoUrl = "";
      if (video != null) {
        final url = await S3UploadHelper.presignAndUpload(
          video,
          presignedEndpoint: ApiService.auctionPresignedUrl,
        );
        if (url != null) {
          videoUrl = url;
        }
      }

      // 3. Upload Document (if any)
      String documentUrl = "";
      if (document != null) {
        final url = await S3UploadHelper.presignAndUpload(
          document,
          presignedEndpoint: ApiService.auctionPresignedUrl,
        );
        if (url != null) {
          documentUrl = url;
        }
      }

      // 4. Create Auction
      final payload = {
        "title": title,
        "description": description,
        "vehicle_brand": brand,
        "vehicle_model": model,
        "vehicle_category": category,
        "vehicle_year": year,
        "vehicle_mileage": mileage,
        "vehicle_vin_number": vin,
        "vehicle_fuel_type": fuelType,
        "vehicle_location": location,
        "reserve_price": reservePrice,
        "buy_now_price": buyNowPrice,
        "starts_at": startsAt,
        "ends_at": endsAt,
        "image_urls": imageUrls,
        "video_url": videoUrl,
        "document_url": documentUrl,
      };

      final response = await DioManager.apiRequest(
        url: ApiService.createAuction,
        method: Methods.post,
        body: payload,
        successCode: 201,
      );

      return response.fold(
        (error) {
          if (context.mounted) {
            AppSnackBar.error(context, error);
          }
          _setLoading(false);
          return false;
        },
        (data) {
          if (context.mounted) {
            AppSnackBar.success(context, "Auction created successfully!");
          }
          _setLoading(false);
          return true;
        },
      );
    } catch (e) {
      if (context.mounted) {
        AppSnackBar.error(context, "An unexpected error occurred: $e");
      }
      _setLoading(false);
      return false;
    }
  }

  // _showError is now redundant, removed.
}
