import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/core/widgets/custom_dropdown_field.dart';
import 'package:rionydo/core/widgets/custom_text_field.dart';
import 'section_header.dart';

class VehicleInfoFields extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController brandController;
  final TextEditingController modelController;
  final TextEditingController yearController;
  final TextEditingController mileageController;
  final TextEditingController vinController;
  final TextEditingController carCategoryController;
  final TextEditingController descriptionController;
  final TextEditingController fuelTypeController;
  final TextEditingController locationController;

  const VehicleInfoFields({
    super.key,
    required this.titleController,
    required this.brandController,
    required this.modelController,
    required this.yearController,
    required this.mileageController,
    required this.vinController,
    required this.carCategoryController,
    required this.descriptionController,
    required this.fuelTypeController,
    required this.locationController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AuctionSectionHeader(title: "VEHICLE INFORMATION"),
        SizedBox(height: 12.h),

        // Auction Title
        CustomTextField(
          validationMinLength: 3,
          validationMaxLength: 30,
          textInputAction: TextInputAction.next,
          hintText: "Auction Title",
          controller: titleController,
        ),
        SizedBox(height: 12.h),

        // Brand & Model row
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                hintText: "Brand",
                controller: brandController,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: CustomTextField(
                hintText: "Model",
                controller: modelController,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),

        // Year & Mileage row
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                hintText: "Year",
                controller: yearController,
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: CustomTextField(
                hintText: "Mileage (km)",
                controller: mileageController,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),

        // VIN Number
        CustomTextField(hintText: "VIN Number", controller: vinController),
        SizedBox(height: 12.h),

        // Fuel Type & Location row
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                textInputAction: TextInputAction.next,
                hintText: "Fuel Type",
                controller: fuelTypeController,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: CustomTextField(
                textInputAction: TextInputAction.next,
                hintText: "Location",
                controller: locationController,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        // Car Category
        CustomDropdownField(
          textInputAction: TextInputAction.next,
          hintText: "Car Category",
          items: const ["Sports Car", "SUV", "Luxury Sedan", "Classic Car"],
          value: carCategoryController.text.isNotEmpty
              ? carCategoryController.text
              : null,
          onChanged: (value) {
            carCategoryController.text = value ?? "";
          },
        ),
        SizedBox(height: 12.h),

        // Description (multiline)
        TextFormField(
          textInputAction: TextInputAction.newline,
          controller: descriptionController,
          maxLines: 4,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: "Description",
            hintStyle: TextStyle(color: AppColors.sceGreyA0, fontSize: 14.sp),
            filled: true,
            fillColor: Colors.white.withOpacity(0.04),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 16.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(
                color: AppColors.sceOnboardingGold,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
