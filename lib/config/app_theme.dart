import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design tokens — tema "Stempel Akademik"
class AppColors {
  AppColors._();

  static const inkNavy = Color(0xFF0F172A); // Primary dark text (slate-900)
  static const navySurface = Color(0xFFFFFFFF); // Card surfaces (pure white)
  static const brass = Color(0xFF10B981); // Brand Emerald Green accent
  static const ivory = Color(0xFF0F172A); // Primary text (slate-900)
  static const parchment = Color(0xFFF8FAFC); // Scaffold background (slate-50)
  static const charcoal = Color(0xFF64748B); // Secondary text (slate-500)
  static const sage = Color(0xFF10B981); // Emerald Green success
  static const rust = Color(0xFFEF4444); // Error color red
}

class AppTheme {
  AppTheme._();

  static ThemeData get theme {
    final base = ThemeData(useMaterial3: true, brightness: Brightness.light);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.parchment,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.brass,
        onPrimary: Colors.white,
        secondary: AppColors.brass,
        surface: AppColors.navySurface,
        error: AppColors.rust,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.inkNavy,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.manrope(
          color: AppColors.inkNavy,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
      textTheme: GoogleFonts.manropeTextTheme(base.textTheme).copyWith(
        headlineMedium: GoogleFonts.manrope(
          fontSize: 26,
          fontWeight: FontWeight.w800,
          color: AppColors.inkNavy,
        ),
        titleLarge: GoogleFonts.manrope(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.inkNavy,
        ),
        bodyLarge: GoogleFonts.manrope(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.inkNavy,
        ),
        bodyMedium: GoogleFonts.manrope(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.charcoal,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brass,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: GoogleFonts.manrope(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            letterSpacing: 0.3,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.brass,
          side: const BorderSide(color: AppColors.brass, width: 1.6),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          textStyle: GoogleFonts.manrope(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.charcoal.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.charcoal.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.brass, width: 1.6),
        ),
        labelStyle: GoogleFonts.manrope(color: AppColors.charcoal),
        hintStyle: GoogleFonts.manrope(
          color: AppColors.charcoal.withOpacity(0.6),
        ),
      ),
    );
  }
}
