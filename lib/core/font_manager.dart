import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Font Manager for ScoreLivePro
/// Typography system based on Figma design
/// Note: Verify all font sizes, weights, and families match Figma exactly
class FontManager {
  // ==================== Font Families ====================
  /// Primary font family - Extract from Figma
  static const String primaryFont = "Poppins";
  static const String secondaryFont = "Inter";
  static const String displayFont = "Roboto";
  static const String bodyFont = "Montserrat";

  // ==================== Font Weights ====================
  static const FontWeight w300 = FontWeight.w300; // Light
  static const FontWeight w400 = FontWeight.w400; // Regular
  static const FontWeight w500 = FontWeight.w500; // Medium
  static const FontWeight w600 = FontWeight.w600; // SemiBold
  static const FontWeight w700 = FontWeight.w700; // Bold
  static const FontWeight w800 = FontWeight.w800; // ExtraBold
  static const FontWeight w900 = FontWeight.w900; // Black

  // ==================== Default Text Colors ====================
  static const Color mainTextColor = AppColors.textPrimary;
  static const Color subtitleColor = AppColors.textSecondary;
  static const Color subSubtitleColor = AppColors.textTertiary;
  static const Color hintTextColor = AppColors.textHint;

  // ==================== Display Text Styles ====================

  /// Display Large - For hero titles
  /// Figma: Extract exact specifications
  static TextStyle displayLarge({
    Color color = mainTextColor,
    double? fontSize,
  }) =>
      GoogleFonts.poppins(
        fontSize: (fontSize ?? 48).sp,
        fontWeight: w800,
        color: color,
        letterSpacing: -0.5,
        height: 1.2,
      );

  /// Display Medium - For section titles
  static TextStyle displayMedium({
    Color color = mainTextColor,
    double? fontSize,
  }) =>
      GoogleFonts.poppins(
        fontSize: (fontSize ?? 36).sp,
        fontWeight: w800,
        color: color,
        letterSpacing: 0.0,
        height: 1.2,
      );

  /// Display Small - For large headings
  static TextStyle displaySmall({
    Color color = mainTextColor,
    double? fontSize,
  }) =>
      GoogleFonts.poppins(
        fontSize: (fontSize ?? 28).sp,
        fontWeight: w700,
        color: color,
        letterSpacing: 0.0,
        height: 1.3,
      );

  // ==================== Heading Text Styles ====================

  /// Heading 1 - Main page titles
  static TextStyle heading1({
    Color color = mainTextColor,
    double? fontSize,
  }) =>
      GoogleFonts.poppins(
        fontSize: (fontSize ?? 24).sp,
        fontWeight: w700,
        color: color,
        letterSpacing: 0.0,
        height: 1.3,
      );

  /// Heading 2 - Section headings
  static TextStyle heading2({
    Color color = mainTextColor,
    double? fontSize,
  }) =>
      GoogleFonts.poppins(
        fontSize: (fontSize ?? 22).sp,
        fontWeight: w700,
        color: color,
        letterSpacing: 0.0,
        height: 1.3,
      );

  /// Heading 3 - Subsection headings
  static TextStyle heading3({
    Color color = mainTextColor,
    double fontSize = 20,
  }) =>
      GoogleFonts.poppins(
        fontSize: fontSize.sp,
        fontWeight: w600,
        color: color,
        letterSpacing: 0.0,
        height: 1.4,
      );

  /// Heading 4 - Small headings
  static TextStyle heading4({
    Color color = mainTextColor,
    double fontSize = 16,
  }) =>
      GoogleFonts.poppins(
        fontSize: fontSize,
        fontWeight: w500,
        color: color,
        letterSpacing: 0.0,
        height: 1.4,
      );

  // ==================== Body Text Styles ====================

  /// Body Large - For important body text
  static TextStyle bodyLarge({
    Color color = mainTextColor,
    double? fontSize,
  }) =>
      GoogleFonts.inter(
        fontSize: (fontSize ?? 18).sp,
        fontWeight: w400,
        color: color,
        letterSpacing: 0.0,
        height: 1.5,
      );

  /// Body Medium - Standard body text
  static TextStyle bodyMedium({
    Color color = mainTextColor,
    double? fontSize,
  }) =>
      GoogleFonts.inter(
        fontSize: (fontSize ?? 16).sp,
        fontWeight: w600,
        color: color,
        letterSpacing: 0.0,
        height: 1.5,
      );

  /// Body Small - Secondary body text
  static TextStyle bodySmall({
    Color color = subtitleColor,
    double? fontSize,
  }) =>
      GoogleFonts.inter(
        fontSize: (fontSize ?? 14).sp,
        fontWeight: w400,
        color: color,
        letterSpacing: 0.0,
        height: 1.4,
      );

  // ==================== Label Text Styles ====================

  /// Label Large - For large labels
  static TextStyle labelLarge({
    Color color = mainTextColor,
    double? fontSize,
  }) =>
      GoogleFonts.inter(
        fontSize: (fontSize ?? 16).sp,
        fontWeight: w600,
        color: color,
        letterSpacing: 0.1,
        height: 1.4,
      );

  /// Label Medium - Standard labels
  static TextStyle labelMedium({
    Color color = mainTextColor,
    double? fontSize,
  }) =>
      GoogleFonts.inter(
        fontSize: (fontSize ?? 14).sp,
        fontWeight: w600,
        color: color,
        letterSpacing: 0.1,
        height: 1.4,
      );

  /// Label Small - Small labels
  static TextStyle labelSmall({
    Color color = subtitleColor,
    double? fontSize,
  }) =>
      GoogleFonts.inter(
        fontSize: (fontSize ?? 12).sp,
        fontWeight: w500,
        color: color,
        letterSpacing: 0.1,
        height: 1.3,
      );

  // ==================== Legacy Text Styles (Keep for compatibility) ====================

  /// Title Text - Legacy support
  static TextStyle titleText({
    Color color = mainTextColor,
    double fontSize = 22,
  }) =>
      heading2(color: color, fontSize: fontSize);

  /// Big Title Text - Legacy support
  static TextStyle bigTitleText({
    Color color = Colors.white,
    double? fontSize,
  }) =>
      displayMedium(color: color, fontSize: fontSize);

  /// General Text - Legacy support
  static TextStyle generalText({
    double fontSize = 14,
    Color color = hintTextColor,
  }) =>
      bodyLarge(color: color, fontSize: fontSize);

  /// Hint Text - Legacy support
  static TextStyle hintText({
    double fontSize = 16,
    Color color = hintTextColor,
  }) =>
      bodyMedium(color: color, fontSize: fontSize);

  /// Subtitle Text - Legacy support
  static TextStyle subtitleText({
    double fontSize = 16,
    Color color = subtitleColor,
    double height = 1.4,
  }) =>
      bodyMedium(
        color: color,
        fontSize: fontSize,
      );

  /// Sub Subtitle Text - Legacy support
  static TextStyle subSubtitleText({
    double fontSize = 14,
    Color color = subSubtitleColor,
    double height = 1.4,
  }) =>
      bodySmall(
        color: color,
        fontSize: fontSize,
      );

  /// Button Text - Legacy support
  static TextStyle buttonText({
    double fontSize = 14,
    Color color = Colors.white,
    double height = 1,
  }) =>
      labelLarge(
        color: color,
        fontSize: fontSize,
      );

  // ==================== Sports Specific Text Styles ====================

  /// Match Score - Large, bold for scores
  static TextStyle matchScore({
    Color color = mainTextColor,
    double? fontSize,
  }) =>
      GoogleFonts.poppins(
        fontSize: (fontSize ?? 32).sp,
        fontWeight: w800,
        color: color,
        letterSpacing: 0.0,
        height: 1.0,
      );

  /// Team Name - For team names in matches
  static TextStyle teamName({
    Color color = mainTextColor,
    double? fontSize,
  }) =>
      GoogleFonts.poppins(
        fontSize: (fontSize ?? 16).sp,
        fontWeight: w600,
        color: color,
        letterSpacing: 0.0,
        height: 1.3,
      );

  /// League Name - For league names
  static TextStyle leagueName({
    Color color = subtitleColor,
    double? fontSize,
  }) =>
      GoogleFonts.inter(
        fontSize: (fontSize ?? 14).sp,
        fontWeight: w500,
        color: color,
        letterSpacing: 0.0,
        height: 1.3,
      );

  /// Match Status - For LIVE, FT, HT, etc.
  static TextStyle matchStatus({
    Color color = AppColors.liveMatch,
    double? fontSize,
  }) =>
      GoogleFonts.inter(
        fontSize: (fontSize ?? 12).sp,
        fontWeight: w700,
        color: color,
        letterSpacing: 0.5,
        height: 1.2,
      );

  /// News Title - For news article titles
  static TextStyle newsTitle({
    Color color = mainTextColor,
    double? fontSize,
  }) =>
      GoogleFonts.poppins(
        fontSize: (fontSize ?? 18).sp,
        fontWeight: w600,
        color: color,
        letterSpacing: 0.0,
        height: 1.4,
      );

  /// News Excerpt - For news article excerpts
  static TextStyle newsExcerpt({
    Color color = subtitleColor,
    double? fontSize,
  }) =>
      GoogleFonts.inter(
        fontSize: (fontSize ?? 14).sp,
        fontWeight: w400,
        color: color,
        letterSpacing: 0.0,
        height: 1.5,
      );
}
