import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.cardBackground,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimary,
        onError: Colors.white,
      ),
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: AppColors.textPrimary, size: 22),
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppStyles.roundedMedium,
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: AppStyles.roundedMedium,
          ),
          textStyle: AppStyles.buttonText,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: AppStyles.roundedMedium,
          ),
          textStyle: AppStyles.buttonText.copyWith(color: AppColors.primary),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.background,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        hintStyle: const TextStyle(
          color: AppColors.textMuted,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        labelStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: AppStyles.roundedMedium,
          borderSide: const BorderSide(color: AppColors.border, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppStyles.roundedMedium,
          borderSide: const BorderSide(color: AppColors.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppStyles.roundedMedium,
          borderSide: const BorderSide(color: AppColors.primary, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppStyles.roundedMedium,
          borderSide: const BorderSide(color: AppColors.error, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppStyles.roundedMedium,
          borderSide: const BorderSide(color: AppColors.error, width: 1.8),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
