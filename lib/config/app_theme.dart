import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design tokens — Tema Modern Premium (Slate & Lime)
class AppColors {
  AppColors._();

  static const inkNavy = Color(0xFF5B30AC); // Deep Purple (Primary/Text)
  static const navySurface = Color(0xFFFFFFFF); // Clean White (Cards)
  static const brass = Color(0xFF00BFA5); // Vibrant Teal (Accents)
  static const ivory = Color(0xFFFFFFFF); // Pure White
  static const parchment = Color(0xFFF4F5F9); // Light Grey/Purple (Background)
  static const charcoal = Color(0xFF5F6368); // Slate Grey (Secondary Text)
  static const sage = Color(0xFF00BFA5); // Success Teal
  static const rust = Color(0xFFEF4444); // Error Red
}

class AppTheme {
  AppTheme._();

  static ThemeData get theme {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
    );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.parchment,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.inkNavy,
        onPrimary: Colors.white,
        secondary: AppColors.brass,
        onSecondary: AppColors.inkNavy,
        surface: AppColors.ivory,
        error: AppColors.rust,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.inkNavy,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.plusJakartaSans(
          color: AppColors.inkNavy,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
        ),
      ),
      textTheme: GoogleFonts.plusJakartaSansTextTheme(base.textTheme).copyWith(
        headlineMedium: GoogleFonts.plusJakartaSans(
          fontSize: 26,
          fontWeight: FontWeight.w800,
          color: AppColors.inkNavy,
          letterSpacing: -0.5,
        ),
        titleLarge: GoogleFonts.plusJakartaSans(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.inkNavy,
          letterSpacing: -0.3,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.inkNavy,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            letterSpacing: 0.1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.inkNavy,
          side: const BorderSide(color: AppColors.inkNavy, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 14),
          textStyle: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.inkNavy.withOpacity(0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.inkNavy.withOpacity(0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.inkNavy, width: 1.6),
        ),
        labelStyle: GoogleFonts.plusJakartaSans(
          color: AppColors.charcoal.withOpacity(0.6),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
