import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bgDeep,
      colorScheme: const ColorScheme.dark(
        background: AppColors.bgDeep,
        surface: AppColors.bgSurface,
        primary: AppColors.neonCyan,
        secondary: AppColors.neonPurple,
        tertiary: AppColors.neonGreen,
        onBackground: AppColors.silver,
        onSurface: AppColors.silver,
        onPrimary: AppColors.bgDeep,
      ),
      textTheme: GoogleFonts.spaceGroteskTextTheme(
        ThemeData.dark().textTheme,
      ).apply(bodyColor: AppColors.silver, displayColor: AppColors.silver),
      dividerColor: AppColors.silverMuted.withOpacity(0.15),
      iconTheme: const IconThemeData(color: AppColors.neonCyan),
      useMaterial3: true,
    );
  }

  static ThemeData light() {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.ltBg,
      colorScheme: const ColorScheme.light(
        background: AppColors.ltBg,
        surface: AppColors.ltSurface,
        primary: AppColors.ltAccent,
        secondary: AppColors.ltAccent2,
        onBackground: AppColors.ltText,
        onSurface: AppColors.ltText,
        onPrimary: Colors.white,
      ),
      textTheme: GoogleFonts.spaceGroteskTextTheme(
        ThemeData.light().textTheme,
      ).apply(bodyColor: AppColors.ltText, displayColor: AppColors.ltText),
      dividerColor: AppColors.ltTextDim.withOpacity(0.15),
      iconTheme: const IconThemeData(color: AppColors.ltAccent),
      useMaterial3: true,
    );
  }
}
