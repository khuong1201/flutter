import 'package:flutter/material.dart';
import '../constants/app_palette.dart';

class AppColorScheme {
  AppColorScheme._();

  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,

    primary: AppPalette.teal5,
    onPrimary: AppPalette.teal1,
    primaryContainer: AppPalette.teal3,
    onPrimaryContainer: AppPalette.teal9,

    secondary: AppPalette.orange5,
    onSecondary: AppPalette.orange1,
    secondaryContainer: AppPalette.orange3,
    onSecondaryContainer: AppPalette.orange9,

    tertiary: AppPalette.blue5,
    onTertiary: AppPalette.blue1,
    tertiaryContainer: AppPalette.blue3,
    onTertiaryContainer: AppPalette.blue9,

    error: Colors.redAccent,
    onError: Colors.white,

    surface: AppPalette.neutral1,
    onSurface: AppPalette.neutral12,

    surfaceContainer: AppPalette.neutral2,
    onSurfaceVariant: AppPalette.neutral8,

    outline: AppPalette.neutral4,
  );

  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,

    primary: AppPalette.teal5,
    onPrimary: AppPalette.teal12,
    primaryContainer: AppPalette.teal9,
    onPrimaryContainer: AppPalette.teal3,

    secondary: AppPalette.blue6,
    onSecondary: AppPalette.blue12,
    secondaryContainer: AppPalette.blue9,
    onSecondaryContainer: AppPalette.blue3,

    tertiary: AppPalette.orange5,
    onTertiary: AppPalette.orange12,
    tertiaryContainer: AppPalette.orange9,
    onTertiaryContainer: AppPalette.orange3,

    error: Colors.redAccent,
    onError: Colors.black,

    surface: AppPalette.neutral12,
    onSurface: AppPalette.neutral2,

    surfaceContainer: AppPalette.neutral11,
    onSurfaceVariant: AppPalette.neutral4,

    outline: AppPalette.neutral8,
  );
}