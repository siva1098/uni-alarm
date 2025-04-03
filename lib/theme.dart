import 'package:flutter/material.dart';
import 'constants.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: AppColors.textLight,
        titleTextStyle: TextStyle(
          fontSize: AppConstants.appBarTitleSize,
          fontWeight: AppConstants.appBarTitleWeight,
          color: AppColors.textLight,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryDarker,
        foregroundColor: AppColors.textLight,
        titleTextStyle: TextStyle(
          fontSize: AppConstants.appBarTitleSize,
          fontWeight: AppConstants.appBarTitleWeight,
          color: AppColors.textLight,
        ),
      ),
    );
  }
}
