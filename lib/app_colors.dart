import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // === PRIMARY CYBERPUNK PALETTE ===
  static const Color bgDeep     = Color(0xFF050510);
  static const Color bgSurface  = Color(0xFF0A0A1A);
  static const Color bgCard     = Color(0xFF0F0F24);
  static const Color bgElevated = Color(0xFF14142E);

  // Neon Cyan — primary accent
  static const Color neonCyan   = Color(0xFF00F5FF);
  static const Color neonCyanDim= Color(0xFF00B8C8);

  // Neon Purple — secondary accent
  static const Color neonPurple = Color(0xFFBF00FF);
  static const Color neonPurpleDim = Color(0xFF8A00C4);

  // Neon Green — highlight
  static const Color neonGreen  = Color(0xFF00FF88);

  // Silver — text
  static const Color silver     = Color(0xFFE8E8F0);
  static const Color silverDim  = Color(0xFF9898B0);
  static const Color silverMuted= Color(0xFF5A5A78);

  // Glitch red
  static const Color glitchRed  = Color(0xFFFF003C);

  // === GRADIENTS ===
  static const LinearGradient heroBg = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [bgDeep, Color(0xFF0A0020), Color(0xFF000A20)],
  );

  static const LinearGradient cyanPurple = LinearGradient(
    colors: [neonCyan, neonPurple],
  );

  static const LinearGradient cyanGreen = LinearGradient(
    colors: [neonCyan, neonGreen],
  );

  static const LinearGradient cardBorder = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [neonCyan, neonPurple, neonCyan],
  );

  // === SHADOWS / GLOWS ===
  static List<BoxShadow> neonCyanGlow = [
    BoxShadow(color: neonCyan.withOpacity(0.4), blurRadius: 20, spreadRadius: 2),
    BoxShadow(color: neonCyan.withOpacity(0.1), blurRadius: 60, spreadRadius: 10),
  ];

  static List<BoxShadow> neonPurpleGlow = [
    BoxShadow(color: neonPurple.withOpacity(0.4), blurRadius: 20, spreadRadius: 2),
    BoxShadow(color: neonPurple.withOpacity(0.1), blurRadius: 60, spreadRadius: 10),
  ];

  static List<BoxShadow> cardGlow = [
    BoxShadow(color: neonCyan.withOpacity(0.08), blurRadius: 30, spreadRadius: 0),
  ];

  // Light theme
  static const Color ltBg      = Color(0xFFF0F4FF);
  static const Color ltSurface = Color(0xFFFFFFFF);
  static const Color ltCard    = Color(0xFFF8F9FF);
  static const Color ltText    = Color(0xFF0A0A2E);
  static const Color ltTextDim = Color(0xFF4A4A6A);
  static const Color ltAccent  = Color(0xFF0088AA);
  static const Color ltAccent2 = Color(0xFF8800CC);
}
