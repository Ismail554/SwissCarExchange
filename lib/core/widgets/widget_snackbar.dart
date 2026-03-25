import 'package:flutter/material.dart';
import 'package:rionydo/core/utils/app_colors.dart';

enum SnackBarType { success, error, info, warning }

class AppSnackBar {
  AppSnackBar._();

  static void show(
    BuildContext context, {
    required String message,
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(milliseconds: 1500),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final cfg = _config(type);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: duration,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          content: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: cfg.bgColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: cfg.borderColor, width: 1),
              boxShadow: [
                BoxShadow(
                  color: cfg.glowColor.withOpacity(0.25),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: cfg.iconBgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(cfg.icon, color: cfg.iconColor, size: 16),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                ),
                if (actionLabel != null && onAction != null) ...[
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      onAction();
                    },
                    child: Text(
                      actionLabel,
                      style: TextStyle(
                        color: cfg.iconColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
  }

  // Convenience shortcuts
  static void success(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
  }) => show(
    context,
    message: message,
    type: SnackBarType.success,
    actionLabel: actionLabel,
    onAction: onAction,
  );

  static void error(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
  }) => show(
    context,
    message: message,
    type: SnackBarType.error,
    actionLabel: actionLabel,
    onAction: onAction,
  );

  static void info(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
  }) => show(
    context,
    message: message,
    type: SnackBarType.info,
    actionLabel: actionLabel,
    onAction: onAction,
  );

  static void warning(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
  }) => show(
    context,
    message: message,
    type: SnackBarType.warning,
    actionLabel: actionLabel,
    onAction: onAction,
  );

  static _SnackBarConfig _config(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return _SnackBarConfig(
          bgColor: AppColors.sceSuccessDarkBg,
          borderColor: AppColors.sceTeal.withOpacity(0.4),
          glowColor: AppColors.sceTeal,
          icon: Icons.check_circle_outline_rounded,
          iconColor: AppColors.sceTeal,
          iconBgColor: AppColors.sceTeal.withOpacity(0.12),
        );
      case SnackBarType.error:
        return _SnackBarConfig(
          bgColor: AppColors.sceErrorDarkBg,
          borderColor: AppColors.errorRed.withOpacity(0.4),
          glowColor: AppColors.errorRed,
          icon: Icons.error_outline_rounded,
          iconColor: AppColors.errorRed,
          iconBgColor: AppColors.errorRed.withOpacity(0.12),
        );
      case SnackBarType.warning:
        return _SnackBarConfig(
          bgColor: AppColors.sceWarningDarkBg,
          borderColor: AppColors.sceRegistrationGold.withOpacity(0.4),
          glowColor: AppColors.sceRegistrationGold,
          icon: Icons.warning_amber_rounded,
          iconColor: AppColors.sceRegistrationGold,
          iconBgColor: AppColors.sceRegistrationGold.withOpacity(0.12),
        );
      case SnackBarType.info:
        return _SnackBarConfig(
          bgColor: AppColors.sceInfoDarkBg,
          borderColor: AppColors.info.withOpacity(0.4),
          glowColor: AppColors.info,
          icon: Icons.info_outline_rounded,
          iconColor: AppColors.info,
          iconBgColor: AppColors.info.withOpacity(0.12),
        );
    }
  }
}

class _SnackBarConfig {
  final Color bgColor;
  final Color borderColor;
  final Color glowColor;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;

  const _SnackBarConfig({
    required this.bgColor,
    required this.borderColor,
    required this.glowColor,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
  });
}
