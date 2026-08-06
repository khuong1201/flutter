import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_color_scheme.dart';

class AppTheme {
  AppTheme._();

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: AppColorScheme.lightColorScheme,
      scaffoldBackgroundColor: AppColorScheme.lightColorScheme.surface,

      textTheme: TextTheme(
        displayLarge: GoogleFonts.plusJakartaSans(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColorScheme.lightColorScheme.onSurface,
        ),
        headlineLarge: GoogleFonts.plusJakartaSans(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColorScheme.lightColorScheme.onSurface,
        ),
        bodyLarge: GoogleFonts.beVietnamPro(
          fontSize: 16,
          color: AppColorScheme.lightColorScheme.onSurface,
        ),
        bodyMedium: GoogleFonts.beVietnamPro(
          fontSize: 14,
          color: AppColorScheme.lightColorScheme.onSurface,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColorScheme.lightColorScheme.primary,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: AppColorScheme.darkColorScheme,
      scaffoldBackgroundColor: AppColorScheme.darkColorScheme.surface,

      textTheme: TextTheme(
        displayLarge: GoogleFonts.hankenGrotesk(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColorScheme.darkColorScheme.onSurface,
        ),
        headlineLarge: GoogleFonts.hankenGrotesk(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColorScheme.darkColorScheme.onSurface,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          color: AppColorScheme.darkColorScheme.onSurface,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          color: AppColorScheme.darkColorScheme.onSurface,
        ),
        labelLarge: GoogleFonts.jetBrainsMono(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColorScheme.darkColorScheme.primary,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}