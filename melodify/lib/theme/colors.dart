import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const Color primaryBlue = Color(0xFF1E3A8A); // Dark blue
  static const Color primaryPink = Color(0xFFEC4899); // Pink

  // Glassmorphic colors
  static const Color glassBackground = Color(0x20FFFFFF); // Semi-transparent white
  static const Color glassBorder = Color(0x40FFFFFF); // Light border

  // Gradients
  static const LinearGradient bluePinkGradient = LinearGradient(
    colors: [primaryBlue, primaryPink],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient pinkBlueGradient = LinearGradient(
    colors: [primaryPink, primaryBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Background gradients
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [
      Color(0xFF0F172A), // Dark slate
      Color(0xFF1E293B), // Slate
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Text colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB3B3B3);

  // Surface colors
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color surfaceLight = Color(0xFF334155);
}