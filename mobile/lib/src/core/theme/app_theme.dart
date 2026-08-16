import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.surface,
      colorScheme: const ColorScheme.light(
        primary: AppColors.gold,
        secondary: AppColors.emerald,
        surface: AppColors.surface,
        onSurface: AppColors.ink,
        error: AppColors.clay,
      ),
      fontFamily: 'Roboto',
      textTheme: const TextTheme(
        displaySmall: TextStyle(
          color: AppColors.ink,
          fontSize: 26,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.5,
          height: 1.25,
        ),
        headlineSmall: TextStyle(
          color: AppColors.ink,
          fontSize: 20,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.2,
        ),
        titleMedium: TextStyle(
          color: AppColors.ink,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
        bodyMedium: TextStyle(
          color: AppColors.muted,
          fontSize: 13,
          height: 1.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.paper,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.paper,
        indicatorColor: AppColors.gold.withValues(alpha: .1),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              color: AppColors.gold,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            );
          }
          return const TextStyle(color: AppColors.muted, fontSize: 11);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.gold);
          }
          return const IconThemeData(color: AppColors.muted);
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.paper,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.gold, width: 1.5),
        ),
        labelStyle: const TextStyle(color: AppColors.muted, fontSize: 13),
        hintStyle: const TextStyle(color: AppColors.muted, fontSize: 13),
      ),
    );
  }
}
