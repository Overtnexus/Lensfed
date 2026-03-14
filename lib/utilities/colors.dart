import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // =========================
  // 🎨 LIGHT MODE COLORS
  // =========================

  static const Color primaryLight = Color(0xFF7C3AED);
  static const Color secondaryLight = Color(0xFF3B82F6);

  static const Color backgroundLight = Color(0xFFF5F5FA);
  static const Color foregroundLight = Color(0xFF18181B);

  static const Color cardLight = Color(0xFFFFFFFF);

  static const Color mutedLight = Color(0xFFEFEFF2);
  static const Color mutedForegroundLight = Color(0xFF71717A);

  static const Color accentLight = Color(0xFFEDE9FE);
  static const Color accentForegroundLight = Color(0xFF5B21B6);

  static const Color destructiveLight = Color(0xFFEF4444);

  static const Color borderLight = Color(0xFFE4E4E7);

  static const Color sidebarBackgroundLight = Color(0xFF1E1033);
  static const Color sidebarAccentLight = Color(0xFF2E1A4A);

  // =========================
  // 🌙 DARK MODE COLORS
  // =========================

  static const Color primaryDark = Color(0xFF8B5CF6);
  static const Color secondaryDark = Color(0xFF60A5FA);

  static const Color backgroundDark = Color(0xFF131318);
  static const Color cardDark = Color(0xFF1E1E26);

  static const Color mutedDark = Color(0xFF2A2A30);

  static const Color foregroundDark = Colors.white;
  static const Color borderDark = Color(0xFF2A2A30);

  static const Color destructiveDark = Color(0xFFEF4444);

  // =========================
  // 🌈 GRADIENTS
  // =========================

  static const LinearGradient gradientPrimary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF7C3AED),
      Color(0xFF3B82F6),
    ],
  );

  static const LinearGradient gradientPrimaryDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF8B5CF6),
      Color(0xFF60A5FA),
    ],
  );

  // =========================
  // 🪟 GLASS EFFECT
  // =========================

  static Color glassLight = Colors.white.withOpacity(0.85);
  static Color glassDark = const Color(0xFF1E1E26).withOpacity(0.85);

}