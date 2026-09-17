import 'package:flutter/material.dart';

class AppColors {
  static const cream = Color(0xFFFAF8F2);
  static const card = Color(0xFFFFFFFF);
  static const textDark = Color(0xFF1E1A14);
  static const textMuted = Color(0xFF8B8577);
  static const goldLight = Color(0xFFEDCC7A);
  static const goldMid = Color(0xFFD4A84B);
  static const goldDark = Color(0xFFC08B28);
  static const gold = Color(0xFFD4A84B);
  static const green = Color(0xFF4CAF82);
  static const greenDark = Color(0xFF3A9068);
  // Alias for backwards compatibility
  static const teal = green;
  static const tealDark = greenDark;
  static const lockedBg = Color(0xFFECEAE3);
  static const lockedIcon = Color(0xFFABA694);
  static const border = Color(0x18000000);

  static const goldGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [goldLight, goldDark],
  );

  static const greenGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [green, greenDark],
  );
}

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.cream,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.gold,
        brightness: Brightness.light,
        surface: AppColors.cream,
      ),
      fontFamily: 'Inter',
      textTheme: const TextTheme(
        bodySmall: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textDark),
        bodyMedium: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.textDark),
        bodyLarge: TextStyle(fontFamily: 'Inter', fontSize: 16, color: AppColors.textDark),
        labelSmall: TextStyle(fontFamily: 'Inter', fontSize: 10, color: AppColors.textMuted),
        labelMedium: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textMuted),
        titleMedium: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textDark),
        titleLarge: TextStyle(fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textDark),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.cream,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textDark,
        titleTextStyle: TextStyle(fontFamily: 'Inter', fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textDark),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) {
          if (s.contains(WidgetState.selected)) return Colors.white;
          return const Color(0xFFCCC8BE);
        }),
        trackColor: WidgetStateProperty.resolveWith((s) {
          if (s.contains(WidgetState.selected)) return AppColors.green;
          return const Color(0xFFDDD9D1);
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),
    );
  }

  /// Cinzel display font — використовується для заголовків
  static TextStyle display({double size = 24, FontWeight weight = FontWeight.w700, Color? color}) {
    return TextStyle(
      fontFamily: 'Cinzel',
      fontSize: size,
      fontWeight: weight,
      color: color ?? AppColors.textDark,
      letterSpacing: 0.5,
    );
  }
}
