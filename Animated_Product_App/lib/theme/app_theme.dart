import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color background = Color(0xFF0A0E21);
  static const Color surface = Color(0xFF1C2040);
  static const Color cardSurface = Color(0xFF242850);
  static const Color accent = Color(0xFF6C63FF);
  static const Color accentLight = Color(0xFF9D97FF);
  static const Color accentGlow = Color(0x336C63FF);
  static const Color success = Color(0xFF4CAF7D);
  static const Color warning = Color(0xFFFFB74D);
  static const Color error = Color(0xFFEF5350);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B8D4);
  static const Color textHint = Color(0xFF6B7394);
  static const Color divider = Color(0xFF2A3060);
  static const Color favorite = Color(0xFFFF4081);
  static const Color starColor = Color(0xFFFFD700);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF9D97FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF0A0E21), Color(0xFF14193A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF242850), Color(0xFF1C2040)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accent,
        secondary: AppColors.accentLight,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(
        const TextTheme(
          displayLarge: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 32,
          ),
          displayMedium: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 28,
          ),
          headlineLarge: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
          headlineMedium: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
          titleLarge: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
          titleMedium: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
          bodyLarge: TextStyle(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
          bodyMedium: TextStyle(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
          bodySmall: TextStyle(
            color: AppColors.textHint,
            fontWeight: FontWeight.w400,
            fontSize: 12,
          ),
          labelLarge: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        titleTextStyle: GoogleFonts.poppins(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        hintStyle: GoogleFonts.poppins(
          color: AppColors.textHint,
          fontSize: 14,
        ),
        labelStyle: GoogleFonts.poppins(
          color: AppColors.textHint,
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.accent, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          minimumSize: const Size(double.infinity, 56),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.accent,
        labelStyle: GoogleFonts.poppins(
          color: AppColors.textSecondary,
          fontSize: 13,
        ),
        secondaryLabelStyle: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 13,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.divider),
        ),
      ),
      useMaterial3: true,
    );
  }
}
