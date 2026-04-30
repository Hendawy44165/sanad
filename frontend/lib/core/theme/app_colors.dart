import 'package:flutter/material.dart';

/// Centralized color palette for the Sanad application.
/// 
/// Defines the brand colors, text colors, and UI status colors
/// to ensure visual consistency across all features.
class AppColors {
  // Primary - Vibrant teal (from screenshot)
  static const Color primary = Color(0xFF00A38D);
  static const Color onPrimary = Colors.white;

  // Secondary - Very soft mint (background from screenshot)
  static const Color secondary = Color(0xFFEEF7F5);
  static const Color onSecondary = Color(0xFF00A38D);

  // Backgrounds
  static const Color background = Color(0xFFEEF7F5);
  static const Color surface = Colors.white;

  // Text
  static const Color text = Color(0xFF2D3142); // Darker blue-grey for better contrast
  static const Color textLight = Color(0xFF64748B);

  // Accent - Updated to match primary or a complementary shade
  static const Color accent = Color(0xFF00A38D);

  // Status
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);

  // Borders
  static const Color border = Color(0xFFE2E8F0);
  static const Color inputFill = Color(0xFFF8FAFC);
}
