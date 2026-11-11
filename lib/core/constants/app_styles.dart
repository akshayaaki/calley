import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppStyles {
  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 14.0;
  static const double radiusLarge = 18.0;
  static const double radiusExtraLarge = 24.0;

  static BorderRadius get roundedSmall => BorderRadius.circular(radiusSmall);
  static BorderRadius get roundedMedium => BorderRadius.circular(radiusMedium);
  static BorderRadius get roundedLarge => BorderRadius.circular(radiusLarge);
  static BorderRadius get roundedExtraLarge => BorderRadius.circular(radiusExtraLarge);

  // Subtle SaaS Shadows
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: const Color(0xFF1E293B).withValues(alpha: 0.04),
      offset: const Offset(0, 4),
      blurRadius: 16,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: const Color(0xFF1E293B).withValues(alpha: 0.02),
      offset: const Offset(0, 1),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> get buttonShadow => [
    BoxShadow(
      color: AppColors.primary.withValues(alpha: 0.25),
      offset: const Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> get modalShadow => [
    BoxShadow(
      color: const Color(0xFF0F172A).withValues(alpha: 0.08),
      offset: const Offset(0, -6),
      blurRadius: 24,
      spreadRadius: 0,
    ),
  ];

  // Text Styles
  static const TextStyle h1 = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.45,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.2,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
  );
}

