import 'package:flutter/material.dart';

/// App Colors for ScoreLivePro
/// Colors extracted from Figma design
/// Note: Verify all colors match Figma design exactly
class AppColors {
  /* ==================== Primary Colors ==================== */
  /// Primary brand color (Orange) - Extract exact value from Figma
  static const Color primaryColor = Color(0xFFFF7931);
  static const Color primaryDark = Color(0xFFE6681F);
  static const Color primaryLight = Color(0xFFFF9D6B);
  static const Color primaryContainer = Color(0xFFFFE8DC);

  /* ==================== Background Colors ==================== */
  static const Color bgColor = Color(0xFFF0F0F0);
  static const Color bgSecondary = Color(0xFFFFFFFF);
  static const Color bgTertiary = Color(0xFFF8F8F8);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F5F5);

  /* ==================== Text Colors ==================== */
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF4B4B4B);
  static const Color textTertiary = Color(0xFF848484);
  static const Color textHint = Color(0xFF848484);
  static const Color textDisabled = Color(0xFFD4D4D4);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnSecondary = Color(0xFFFFFFFF);

  /* ==================== Neutral Colors ==================== */
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color darkGrey = Color(0xFF1F2937);
  static const Color grey2D = Color(0xFF2D2D2D);
  static const Color grey4B = Color(0xFF4B4B4B);
  static const Color grey = Color(0xFF848484);
  static const Color lightGrey = Color(0xFFDADADA);
  static const Color greyD9 = Color(0xFFD9D9D9);
  static const Color greyE8 = Color(0xFFE8E8E8);
  static const Color greyD4 = Color(0xFFD4D4D4);
  static const Color greyEFF = Color(0xFFEFF6FF);

  /* ==================== Semantic Colors ==================== */
  // Success
  static const Color success = Color(0xFF28A745);
  static const Color successLight = Color(0xFFD4EDDA);
  static const Color successDark = Color(0xFF1E7E34);

  // Error
  static const Color error = Color(0xFFFF0040);
  static const Color errorLight = Color(0xFFFFE5E5);
  static const Color errorDark = Color(0xFFCC0033);

  // Warning
  static const Color warning = Color(0xFFFDC300);
  static const Color warningLight = Color(0xFFFFF4D6);
  static const Color warningDark = Color(0xFFE6B000);

  // Info
  static const Color info = Color(0xFF1E90FF);
  static const Color infoLight = Color(0xFFE6F3FF);
  static const Color infoDark = Color(0xFF0066CC);

  /* ==================== Accent Colors ==================== */
  static const Color red = Color(0xFFFF0040);
  static const Color yellow = Color(0xFFFDC300);
  static const Color green = Color(0xFF28A745);
  static const Color blue = Color(0xFF1E90FF);
  static const Color blueTransparent = Color(0x421E90FF);
  static const Color amberTransparent = Color(0x4DA66E00);

  /* ==================== UI Element Colors ==================== */
  static const Color borderColor = Color(0xFFD4D4D4);
  static const Color borderLight = Color(0xFFE8E8E8);
  static const Color borderDark = Color(0xFFB0B0B0);
  static const Color divider = Color(0xFFE8E8E8);
  static const Color dividerDark = Color(0xFFD4D4D4);

  // Input Fields
  static const Color fieldBgColor = Color(0xFFFFFFFF);
  static const Color fieldBorder = Color(0xFFD4D4D4);
  static const Color fieldBorderFocused = Color(0xFFFF7931);
  static const Color fieldBorderError = Color(0xFFFF0040);

  // Buttons
  static const Color buttonColor = Color(0xFFFF7931);
  static const Color buttonSecondary = Color(0xFFF0F0F0);
  static const Color buttonDisabled = Color(0xFFD4D4D4);
  static const Color buttonText = Color(0xFFFFFFFF);
  static const Color buttonTextSecondary = Color(0xFF000000);

  // Cards
  static const Color cardBG = Color(0xFFFFFFFF);
  static const Color cardShadow = Color(0x1A000000);

  // Splash & Onboarding
  static const Color splashBG = Color(0xFFFF7931);
  static const Color onboardingBG = Color(0xFFFFFFFF);

  /* ==================== Sports Specific Colors ==================== */
  // Match Status
  static const Color liveMatch = Color(0xFFFF0040);
  static const Color upcomingMatch = Color(0xFF1E90FF);
  static const Color finishedMatch = Color(0xFF848484);
  static const Color postponedMatch = Color(0xFFFDC300);

  // Team Colors (can be customized per team)
  static const Color homeTeam = Color(0xFF1E90FF);
  static const Color awayTeam = Color(0xFFFF7931);

  /* ==================== Shadow Colors ==================== */
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x33000000);
  static const Color shadowDark = Color(0x4D000000);

  /* ==================== Overlay Colors ==================== */
  static const Color overlayLight = Color(0x33000000);
  static const Color overlayMedium = Color(0x66000000);
  static const Color overlayDark = Color(0x99000000);

  /* ==================== Legacy Colors (Keep for compatibility) ==================== */
  static const Color subtitleText = Color(0xFF848484);
  static const Color defTextColor = Color(0xFFFFFFFF);
  static const Color statFillColor = Color(0x261E90FF);
}
