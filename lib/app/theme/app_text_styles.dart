import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // Display — Orbitron (cyberpunk/tech)
  static TextStyle displayXL = GoogleFonts.orbitron(
    fontSize: 72, fontWeight: FontWeight.w900,
    color: AppColors.silver, letterSpacing: -1.5,
    height: 1.05,
  );

  static TextStyle displayLG = GoogleFonts.orbitron(
    fontSize: 48, fontWeight: FontWeight.w800,
    color: AppColors.silver, letterSpacing: -1.0,
    height: 1.1,
  );

  static TextStyle displayMD = GoogleFonts.orbitron(
    fontSize: 32, fontWeight: FontWeight.w700,
    color: AppColors.silver, letterSpacing: -0.5,
    height: 1.2,
  );

  // Body — Space Grotesk
  static TextStyle bodyLG = GoogleFonts.spaceGrotesk(
    fontSize: 18, fontWeight: FontWeight.w400,
    color: AppColors.silverDim, height: 1.7,
  );

  static TextStyle bodyMD = GoogleFonts.spaceGrotesk(
    fontSize: 16, fontWeight: FontWeight.w400,
    color: AppColors.silverDim, height: 1.6,
  );

  static TextStyle bodySM = GoogleFonts.spaceGrotesk(
    fontSize: 14, fontWeight: FontWeight.w400,
    color: AppColors.silverMuted, height: 1.5,
  );

  // Labels — Space Mono (monospace for tech feel)
  static TextStyle labelLG = GoogleFonts.spaceMono(
    fontSize: 13, fontWeight: FontWeight.w700,
    color: AppColors.neonCyan, letterSpacing: 3.0,
  );

  static TextStyle labelMD = GoogleFonts.spaceMono(
    fontSize: 11, fontWeight: FontWeight.w400,
    color: AppColors.neonCyan, letterSpacing: 2.0,
  );

  static TextStyle code = GoogleFonts.spaceMono(
    fontSize: 14, fontWeight: FontWeight.w400,
    color: AppColors.neonGreen, height: 1.6,
  );

  // Gradient name style (used in hero)
  static TextStyle heroName = GoogleFonts.orbitron(
    fontSize: 56, fontWeight: FontWeight.w900,
    letterSpacing: -1.0, height: 1.05,
  );

  static TextStyle heroNameMobile = GoogleFonts.orbitron(
    fontSize: 34, fontWeight: FontWeight.w900,
    letterSpacing: -0.5, height: 1.1,
  );

  static TextStyle sectionTitle = GoogleFonts.orbitron(
    fontSize: 36, fontWeight: FontWeight.w800,
    color: AppColors.silver, letterSpacing: -0.5,
    height: 1.15,
  );

  static TextStyle navItem = GoogleFonts.spaceGrotesk(
    fontSize: 14, fontWeight: FontWeight.w600,
    color: AppColors.silverDim, letterSpacing: 0.5,
  );
}
