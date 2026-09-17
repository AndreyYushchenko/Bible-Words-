import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const cream = Color(0xFFFAF8F4);
  static const card = Color(0xFFFFFFFF);
  static const textDark = Color(0xFF241F17);
  static const textMuted = Color(0xFF8B8577);
  static const goldLight = Color(0xFFE8C878);
  static const goldDark = Color(0xFFC9862E);
  static const gold = Color(0xFFD9A94E);
  static const teal = Color(0xFF2C9678);
  static const tealDark = Color(0xFF1F7A62);
  static const lockedBg = Color(0xFFECEAE3);
  static const lockedIcon = Color(0xFFABA694);
  static const border = Color(0x14000000);

  static const goldGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [goldLight, goldDark],
  );

  static const tealGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [teal, tealDark],
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
    );
  }

  static TextStyle display({double size = 24, FontWeight weight = FontWeight.w700, Color? color}) {
    return GoogleFonts.cinzel(fontSize: size, fontWeight: weight, color: color ?? AppColors.textDark);
  }
}
