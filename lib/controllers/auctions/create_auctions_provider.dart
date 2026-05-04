import 'dart:io';
import 'package:flutter/material.dart';
import 'package:rionydo/app_helper/s3_upload_helper.dart';
import 'package:rionydo/app_utils/constants/api_service.dart';
import 'package:rionydo/app_utils/network/dio_manager.dart';
import 'package:rionydo/app_utils/network/enums.dart';

class CreateAuctionProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
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
          _showError(context, "Failed to upload images.");
        }
        _setLoading(false);
        return false;
      }

      // 2. Upload Video (if any)
      String? videoUrl;
      if (video != null) {
        videoUrl = await S3UploadHelper.presignAndUpload(
          video,
          presignedEndpoint: ApiService.auctionPresignedUrl,
        );
      }

      // 3. Upload Document (if any)
      String? documentUrl;
      if (document != null) {
        documentUrl = await S3UploadHelper.presignAndUpload(
          document,
          presignedEndpoint: ApiService.auctionPresignedUrl,
        );
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
        successCode: 201
      );

      return response.fold(
        (error) {
          if (context.mounted) {
            _showError(context, error);
          }
          _setLoading(false);
          return false;
        },
        (data) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Auction created successfully!"),
                backgroundColor: Colors.green,
              ),
            );
          }
          _setLoading(false);
          return true;
        },
      );
    } catch (e) {
      if (context.mounted) {
        _showError(context, "An unexpected error occurred: $e");
      }
      _setLoading(false);
      return false;
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
