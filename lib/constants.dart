import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const Color primary = Color(0xFFE57373); // Light Red
  static const Color primaryDark = Color(0xFFC62828); // Dark Red
  static const Color primaryDarker = Color(0xFF8E0000); // Darker Red

  // Text colors
  static const Color textLight = Colors.white;
  static const Color textDark = Colors.black87;

  // Background colors
  static const Color backgroundLight = Colors.white;
  static const Color backgroundDark = Color(0xFF121212);
}

class AppConstants {
  // App bar
  static const double appBarTitleSize = 24.0;
  static const FontWeight appBarTitleWeight = FontWeight.bold;

  // Spacing
  static const double defaultPadding = 16.0;
  static const double defaultMargin = 16.0;
  static const double defaultRadius = 12.0;

  // Animation durations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
}
