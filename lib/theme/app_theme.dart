import 'package:flutter/material.dart';

/// Единая палитра и стили, подобранные под референс-скриншоты
/// ресторана «L'Art Culinaire».
class AppColors {
  static const Color accent = Color(0xFFC1552E); // терракотовый акцент
  static const Color accentDark = Color(0xFFA8471F);
  static const Color background = Color(0xFFFCFAF6); // тёплый белый фон
  static const Color card = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF25211D);
  static const Color textSecondary = Color(0xFF8A8178);
  static const Color divider = Color(0xFFEDE7DF);
  static const Color chipBg = Color(0xFFF3EEE6);
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'Georgia',
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.accent,
        primary: AppColors.accent,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
        bodyMedium: TextStyle(color: AppColors.textPrimary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
