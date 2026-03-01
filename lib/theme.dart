import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scouting_app/consts.dart';

TextTheme getAppTextTheme(Brightness brightness) {
  final Color color =
      brightness == Brightness.light ? Colors.black : Colors.grey.shade200;
  return TextTheme(
    displayLarge: GoogleFonts.barlow(
      fontSize: 48,
      fontWeight: FontWeight.w800,
      color: color,
    ),
    displayMedium: GoogleFonts.barlow(
      fontSize: 40,
      fontWeight: FontWeight.w800,
      color: color,
    ),
    displaySmall: GoogleFonts.barlow(
      fontSize: 36,
      fontWeight: FontWeight.w800,
      color: color,
    ),
    headlineLarge: GoogleFonts.barlow(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      color: color,
    ),
    headlineMedium: GoogleFonts.barlow(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      color: color,
    ),
    headlineSmall: GoogleFonts.barlow(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: color,
    ),
    titleLarge: GoogleFonts.barlow(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      color: color,
    ),
    titleMedium: GoogleFonts.barlow(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      color: color,
    ),
    titleSmall: GoogleFonts.barlow(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: color,
    ),
    bodyLarge: GoogleFonts.barlow(
      fontSize: 22,
      fontWeight: FontWeight.w500,
      color: color,
    ),
    bodyMedium: GoogleFonts.barlow(
      fontSize: 18,
      fontWeight: FontWeight.w400,
      color: color,
    ),
    bodySmall: GoogleFonts.barlow(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: color,
    ),
  );
}

ButtonThemeData getAppButtonTheme(Brightness brightness) {
  return ButtonThemeData(
    padding: const EdgeInsets.all(0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(kBorderRadius),
    ),
  );
}

ColorScheme getAppColorScheme(Brightness brightness) {
  return switch (brightness) {
    Brightness.light => ColorScheme.fromSeed(
      seedColor: Color(0xFF910116),
      brightness: Brightness.light,
      dynamicSchemeVariant: DynamicSchemeVariant.rainbow,
      contrastLevel: 0.5,
      surface: Colors.grey[300],
      surfaceContainerLowest: Colors.grey[300],
      surfaceContainerLow: Colors.grey[300],
      surfaceContainer: Colors.grey[200],
      surfaceContainerHigh: Colors.grey[100],
      surfaceContainerHighest: Colors.white,
    ),
    Brightness.dark => ColorScheme.fromSeed(
      seedColor: Color(0xFF910116),
      brightness: Brightness.dark,
      dynamicSchemeVariant: DynamicSchemeVariant.rainbow,
      contrastLevel: 0.0,
    ),
  };
}
