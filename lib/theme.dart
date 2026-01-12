import 'package:flutter/material.dart';

TextTheme getAppTextTheme(Brightness brightness) {
  final Color color =
      brightness == Brightness.light ? Colors.black : Colors.grey.shade200;
  return TextTheme(
    displayLarge: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w800,
      color: color,
    ),
    displayMedium: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w800,
      color: color,
    ),
    displaySmall: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w800,
      color: color,
    ),
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      color: color,
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      color: color,
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: color,
    ),
    titleLarge: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      color: color,
    ),
    titleMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      color: color,
    ),
    titleSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: color,
    ),
    bodyLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: color,
    ),
    bodyMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w400,
      color: color,
    ),
    bodySmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: color,
    ),
  );
}

ButtonThemeData getAppButtonTheme(Brightness brightness) {
  return ButtonThemeData(
    // padding: const EdgeInsets.all(0),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
