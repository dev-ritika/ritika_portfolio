import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Background
  static const Color background = Color(0xFF060912);
  static const Color surface = Color(0xFF0D1117);
  static const Color card = Color(0xFF111827);
  static const Color cardHover = Color(0xFF1A2236);
  static const Color border = Color(0xFF1E2D40);
  static const Color borderGlow = Color(0xFF00D9FF);

  // Primary - Cyan
  static const Color primary = Color(0xFF00D9FF);
  static const Color primaryLight = Color(0xFF66EAFF);
  static const Color primaryDark = Color(0xFF0099BB);

  // Secondary - Purple
  static const Color secondary = Color(0xFF7C3AED);
  static const Color secondaryLight = Color(0xFFA855F7);
  static const Color secondaryDark = Color(0xFF5B21B6);

  // Accent - Magenta
  static const Color accent = Color(0xFFEC4899);

  // Text
  static const Color textPrimary = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF475569);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF00D9FF), Color(0xFF7C3AED)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF00D9FF), Color(0xFFA855F7), Color(0xFFEC4899)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF111827), Color(0xFF0D1117)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glowGradient = LinearGradient(
    colors: [Color(0x2000D9FF), Color(0x207C3AED)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Skill category colors
  static const Color skillCore = Color(0xFF00D9FF);
  static const Color skillState = Color(0xFF7C3AED);
  static const Color skillFirebase = Color(0xFFFF6B2B);
  static const Color skillBackend = Color(0xFF10B981);
  static const Color skillTesting = Color(0xFFF59E0B);
  static const Color skillDevOps = Color(0xFFEC4899);

  // Shadows
  static const Color shadowPrimary = Color(0x3300D9FF);
  static const Color shadowSecondary = Color(0x337C3AED);
}
