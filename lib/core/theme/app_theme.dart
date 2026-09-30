import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

abstract final class AppTheme {
  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.cream,
      colorScheme: const ColorScheme.light(
        primary: AppColors.brown,
        onPrimary: AppColors.cream,
        secondary: AppColors.mocha,
        onSecondary: AppColors.espresso,
        surface: AppColors.ivory,
        onSurface: AppColors.espresso,
        error: AppColors.error,
      ),
    );

    return base.copyWith(
      textTheme: base.textTheme.copyWith(
        displayLarge: const TextStyle(
          fontFamily: 'CormorantGaramond',
          fontSize: 72,
          fontWeight: FontWeight.w400,
          color: AppColors.espresso,
          height: 0.94,
          letterSpacing: -1.8,
        ),
        displayMedium: const TextStyle(
          fontFamily: 'CormorantGaramond',
          fontSize: 58,
          fontWeight: FontWeight.w400,
          color: AppColors.espresso,
          height: 0.98,
          letterSpacing: -1.2,
        ),
        headlineLarge: const TextStyle(
          fontFamily: 'CormorantGaramond',
          fontSize: 44,
          fontWeight: FontWeight.w400,
          color: AppColors.espresso,
          height: 1.0,
        ),
        headlineMedium: const TextStyle(
          fontFamily: 'CormorantGaramond',
          fontSize: 34,
          fontWeight: FontWeight.w400,
          color: AppColors.espresso,
          height: 1.05,
        ),
        titleLarge: const TextStyle(
          fontFamily: 'Manrope',
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: AppColors.espresso,
        ),
        titleMedium: const TextStyle(
          fontFamily: 'Manrope',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.espresso,
          letterSpacing: 0.2,
        ),
        bodyLarge: const TextStyle(
          fontFamily: 'Manrope',
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: AppColors.darkBrown,
          height: 1.7,
        ),
        bodyMedium: const TextStyle(
          fontFamily: 'Manrope',
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: AppColors.brown,
          height: 1.6,
        ),
        labelLarge: const TextStyle(
          fontFamily: 'Manrope',
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.8,
          color: AppColors.espresso,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.cream,
        foregroundColor: AppColors.espresso,
        elevation: 0,
        centerTitle: false,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.espresso,
          foregroundColor: AppColors.cream,
          elevation: 0,
          minimumSize: const Size(double.infinity, 54),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
          textStyle: const TextStyle(
            fontFamily: 'Manrope',
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.8,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.espresso,
          minimumSize: const Size(double.infinity, 54),
          side: const BorderSide(color: AppColors.espresso, width: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
          textStyle: const TextStyle(
            fontFamily: 'Manrope',
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.8,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.ivory,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2),
          borderSide: const BorderSide(color: AppColors.brown, width: 1.5),
        ),
      ),
    );
  }
}
