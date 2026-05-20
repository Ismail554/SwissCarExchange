import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';

class UidCountry {
  final String code;
  final String prefix;
  final String flag;
  final String name;
  final String hintText;

  const UidCountry({
    required this.code,
    required this.prefix,
    required this.flag,
    required this.name,
    required this.hintText,
  });
}

const List<UidCountry> uidCountries = [
  UidCountry(
    code: 'CHE',
    prefix: 'CHE-',
    flag: '🇨🇭',
    name: 'Switzerland',
    hintText: '123.456.789',
  ),
  UidCountry(
    code: 'DE',
    prefix: 'DE',
    flag: '🇩🇪',
    name: 'Germany',
    hintText: '123456789',
  ),
  UidCountry(
    code: 'FR',
    prefix: 'FR',
    flag: '🇫🇷',
    name: 'France',
    hintText: 'XX123456789',
  ),
  UidCountry(
    code: 'IT',
    prefix: 'IT',
    flag: '🇮🇹',
    name: 'Italy',
    hintText: '12345678901',
  ),
  UidCountry(
    code: 'AT',
    prefix: 'AT',
    flag: '🇦🇹',
    name: 'Austria',
    hintText: 'U12345678',
  ),
];

class UidParserResult {
  final UidCountry country;
  final String suffix;

  const UidParserResult({
    required this.country,
    required this.suffix,
  });
}

UidParserResult parseUid(String rawUid) {
  final cleanUid = rawUid.trim().toUpperCase();
  for (final country in uidCountries) {
    if (cleanUid.startsWith(country.prefix.toUpperCase())) {
      final suffix = cleanUid.substring(country.prefix.length);
      return UidParserResult(country: country, suffix: suffix);
    }
  }
  return UidParserResult(country: uidCountries.first, suffix: cleanUid);
}

class UidCountrySelector extends StatelessWidget {
  final UidCountry selectedCountry;
  final ValueChanged<UidCountry> onSelected;

  const UidCountrySelector({
    super.key,
    required this.selectedCountry,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<UidCountry>(
      tooltip: 'Select country format',
      offset: Offset(0, 48.h),
      color: const Color(0xFF1E2630),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
      ),
      onSelected: onSelected,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(selectedCountry.flag, style: TextStyle(fontSize: 18.sp)),
            SizedBox(width: 6.w),
            Text(
              selectedCountry.code,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 4.w),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.sceGreyA0,
              size: 16.sp,
            ),
          ],
        ),
      ),
      itemBuilder: (BuildContext context) {
        return uidCountries.map((UidCountry country) {
          final isSelected = country.code == selectedCountry.code;
          return PopupMenuItem<UidCountry>(
            value: country,
            child: Row(
              children: [
                Text(country.flag, style: TextStyle(fontSize: 18.sp)),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        country.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                      Text(
                        'Format: ${country.prefix}${country.hintText}',
                        style: TextStyle(color: Colors.white38, fontSize: 11.sp),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_rounded,
                    color: AppColors.sceTeal,
                    size: 16.sp,
                  ),
              ],
            ),
          );
        }).toList();
      },
    );
  }
}
