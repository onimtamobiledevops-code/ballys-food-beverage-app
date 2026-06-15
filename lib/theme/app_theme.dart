import 'package:flutter/material.dart';

/// Centralized color palette and theme for the
/// Bally's Food & Beverage app (Red / Orange / Black).
class AppColors {
  AppColors._();

  static const Color primaryRed = Color(0xFFE63238); // Bally's red
  static const Color primaryOrange = Color(0xFFFF7A1A); // Bally's orange
  static const Color black = Color(0xFF0D0D0D); // App background
  static const Color surfaceBlack = Color(0xFF1A1A1A); // Cards / fields
  static const Color surfaceBlackLight = Color(0xFF262626);
  static const Color white = Color(0xFFFFFFFF);
  static const Color greyText = Color(0xFFB3B3B3);

  /// Signature gradient used on buttons, headers, badges etc.
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryRed, primaryOrange],
  );
}

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.black,
      primaryColor: AppColors.primaryRed,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryRed,
        brightness: Brightness.dark,
        primary: AppColors.primaryRed,
        secondary: AppColors.primaryOrange,
        surface: AppColors.surfaceBlack,
      ),
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.black,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.white),
        titleTextStyle: TextStyle(
          color: AppColors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: AppColors.white,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: AppColors.white,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(color: AppColors.white),
        bodyMedium: TextStyle(color: AppColors.greyText),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceBlack,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.surfaceBlackLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryOrange, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryRed, width: 1.5),
        ),
        labelStyle: const TextStyle(color: AppColors.greyText),
        hintStyle: const TextStyle(color: AppColors.greyText),
        prefixIconColor: AppColors.primaryOrange,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryRed,
          foregroundColor: AppColors.white,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryOrange,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceBlack,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      iconTheme: const IconThemeData(color: AppColors.primaryOrange),
      dividerColor: AppColors.surfaceBlackLight,
    );
  }
}

/// Convenience extension to apply the signature gradient to a [BoxDecoration].
extension GradientBox on BoxDecoration {
  static BoxDecoration gradient({BorderRadius? borderRadius}) {
    return BoxDecoration(
      gradient: AppColors.primaryGradient,
      borderRadius: borderRadius ?? BorderRadius.circular(12),
    );
  }
}
