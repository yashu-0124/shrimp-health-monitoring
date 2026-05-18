import 'package:flutter/material.dart';

/// Custom Styles and Constants
/// Centralized styling for consistency across the app

class AppColors {
  // Primary Colors
  static const Color primaryBlue = Color(0xFF4A90E2);
  static const Color lightBlue = Color(0xFF5BA3E8);
  static const Color deepBlue = Color(0xFF0A4CA3);
  
  // Text Colors
  static const Color textDark = Color(0xFF333333);
  static const Color textMedium = Color(0xFF666666);
  static const Color textLight = Color(0xFF999999);
  
  // Background Colors
  static const Color bgLight = Color(0xFFF5F5F5);
  static const Color white = Colors.white;
  
  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryBlue, lightBlue],
  );
}

class AppTextStyles {
  static const TextStyle heading = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 0.5,
  );
  
  static const TextStyle subheading = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.white70,
  );
  
  static const TextStyle label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );
  
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.5,
  );
}

class AppConstants {
  // API
  static const String apiBaseUrl = 'https://aqabackend-9llxvgslt-adithyavennas-projects.vercel.app';
  
  // Languages
  static const List<String> supportedLanguages = [
    'English',
    'Telugu',
    'Hindi',
    'Tamil',
    'Bengali',
    'Spanish',
  ];
  
  // Dimensions
  static const double borderRadius = 12.0;
  static const double cardBorderRadius = 24.0;
  static const double buttonHeight = 52.0;
  static const double iconSize = 20.0;
  
  // Padding
  static const EdgeInsets pagePadding = EdgeInsets.symmetric(horizontal: 24);
  static const EdgeInsets cardPadding = EdgeInsets.all(24);
}
