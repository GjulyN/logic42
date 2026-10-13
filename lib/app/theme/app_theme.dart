import 'package:flutter/material.dart';

class AppColors {
  static const accent = Color(0xFF2F6FED);
  static const accent42 = Color(0xFFC45C26);
  static const lightSurface = Color(0xFFF4F1EA);
  static const darkSurface = Color(0xFF16181D);
}

ThemeData buildLightTheme() {
  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.accent,
      brightness: Brightness.light,
      surface: AppColors.lightSurface,
    ),
  );
  return base.copyWith(
    appBarTheme: const AppBarTheme(centerTitle: true, scrolledUnderElevation: 0),
  );
}

ThemeData buildDarkTheme() {
  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.accent,
      brightness: Brightness.dark,
      surface: AppColors.darkSurface,
    ),
  );
  return base.copyWith(
    appBarTheme: const AppBarTheme(centerTitle: true, scrolledUnderElevation: 0),
  );
}
