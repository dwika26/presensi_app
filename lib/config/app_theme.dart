import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design tokens — tema "Stempel Akademik"
class AppColors {
  AppColors._();

  static const inkNavy = Color(0xFF12213D);
  static const navySurface = Color(0xFF1C2F52);
  static const brass = Color(0xFFC9A227);
  static const ivory = Color(0xFFF4EEDD);
  static const parchment = Color(0xFFFAF7EF);
  static const charcoal = Color(0xFF232323);
  static const sage = Color(0xFF6B9080);
  static const rust = Color(0xFFA8503B);
}

class AppTheme {
  AppTheme._();

  static ThemeData get theme {
    final base = ThemeData(useMaterial3: true, brightness: Brightness.light);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.parchment,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.brass,
        onPrimary: AppColors.inkNavy,
        secondary: AppColors.inkNavy,
        surface: AppColors.parchment,
        error: AppColors.rust,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.inkNavy,
        foregroundColor: AppColors.ivory,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.fraunces(
          color: AppColors.ivory,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
      textTheme: GoogleFonts.manropeTextTheme(base.textTheme).copyWith(
        headlineMedium: GoogleFonts.fraunces(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: AppColors.charcoal,
        ),
        titleLarge: GoogleFonts.fraunces(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.charcoal,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brass,
          foregroundColor: AppColors.inkNavy,
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: GoogleFonts.manrope(fontWeight: FontWeight.w700, letterSpacing: 0.3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.inkNavy,
          side: const BorderSide(color: AppColors.brass, width: 1.4),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.inkNavy.withOpacity(0.15)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.brass, width: 1.6),
        ),
        labelStyle: GoogleFonts.manrope(color: AppColors.charcoal.withOpacity(0.7)),
      ),
    );
  }
}