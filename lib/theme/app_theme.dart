import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  // Золотий градієнт кнопок та іконок
  static const goldGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [goldLight, goldDark],
  );

  // Зелений градієнт (для активних елементів)
  static const greenGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [green, greenDark],
  );

  // Фоновий градієнт для темних екранів (gameplay, splash)
  static const skyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFD4B896), Color(0xFFB89B72)],
  );
}

class AppTheme {
  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.cream,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.gold,
        brightness: Brightness.light,
        surface: AppColors.cream,
      ),
    );
    return base.copyWith(
      textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(
        bodyColor: AppColors.textDark,
        displayColor: AppColors.textDark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.cream,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textDark,
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

  static TextStyle display({double size = 24, FontWeight weight = FontWeight.w700, Color? color}) {
    return GoogleFonts.cinzel(fontSize: size, fontWeight: weight, color: color ?? AppColors.textDark);
  }
}
