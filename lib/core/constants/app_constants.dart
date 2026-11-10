import 'package:flutter/material.dart';

class AppConstants {
  static const appName = 'ClipVault';
  static const tagline = 'Your Media. Your Control.';
}

class AppColors {
  static const primary = Color(0xFF7C3AED);
  static const secondary = Color(0xFF2563EB);
  static const bgDark = Color(0xFF111827);
  static const bgLight = Color(0xFFF8FAFC);
  static const accent = Color(0xFF10B981);
}

class ThemePreset {
  const ThemePreset(this.id, this.name, this.color);
  final String id;
  final String name;
  final Color color;
}

const kThemePresets = <ThemePreset>[
  ThemePreset('violet', 'Violet', AppColors.primary),
  ThemePreset('ocean', 'Ocean', AppColors.secondary),
  ThemePreset('emerald', 'Emerald', AppColors.accent),
  ThemePreset('rose', 'Rose', Color(0xFFE11D48)),
  ThemePreset('amber', 'Amber', Color(0xFFD97706)),
  ThemePreset('teal', 'Teal', Color(0xFF0D9488)),
];
