import 'package:flutter_svg/svg.dart';

const String imagePath = "assets/images";
const String iconPath = "assets/icons";
const String jsonPath = "assets/json";
const String svgPath = "assets/svg";

class ImageAssets {
  static const String splash = "$imagePath/splash_screen.png";
  static const String onboadiing1 = "$imagePath/onboarding1_bg.png";
  static const String onboadiing2 = "$imagePath/onboarding2_bg.png";
  static const String onboadiing3 = "$imagePath/onboarding3_bg.png";
  static const String home_bg = '$imagePath/home_bg.jpg';
  static const String news_im1 = "$imagePath/news_im1.png";
}

class IconAssets {
  static const String app_logo = "$iconPath/app_logo.png";
  static const String soccer_icon = "$iconPath/soccer.png";
  static const String red_card = "$iconPath/red_card.png";
  static const String yellow_card = "$iconPath/yellow_card.png";
  static const String trophy = "$iconPath/trophy.png";
}

class JsonAssets {}

class SvgAssets {
  // ✅ General SVG Files
  static const String splash = "$svgPath/splash.svg";
  static const String logo = "$svgPath/logo.svg";
}
