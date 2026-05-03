// Liquid Glass Design System
import 'package:flutter/material.dart';

class LiquidGlass {
  // Core accent
  static const accent = Color(0xFF7B61FF);
  static const accentLight = Color(0xFFA78BFA);

  // Backgrounds
  static const bg = Color(0xFF0D0D0F);
  static const bgCard = Color.fromRGBO(255, 255, 255, 0.06);
  static const bgElevated = Color.fromRGBO(255, 255, 255, 0.10);
  static const bgInput = Color.fromRGBO(255, 255, 255, 0.08);

  // Glass
  static const glassBg = Color.fromRGBO(30, 30, 35, 0.75);
  static const glassBorder = Color.fromRGBO(255, 255, 255, 0.08);
  static const glassHighlight = Color.fromRGBO(255, 255, 255, 0.12);

  // Text
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color.fromRGBO(255, 255, 255, 0.55);
  static const textMuted = Color.fromRGBO(255, 255, 255, 0.35);

  // Bubbles
  static const bubbleMeStart = Color(0xFF7B61FF);
  static const bubbleMeEnd = Color(0xFF6C52E8);
  static const bubbleOther = Color.fromRGBO(255, 255, 255, 0.08);

  // Misc
  static const separator = Color.fromRGBO(255, 255, 255, 0.06);
  static const badge = Color(0xFFFF3B6F);
  static const online = Color(0xFF4ADE80);

  static ThemeData get theme => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bg,
    primaryColor: accent,
    colorScheme: const ColorScheme.dark(
      primary: accent,
      secondary: accentLight,
      surface: bg,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: bg,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
      iconTheme: IconThemeData(color: textPrimary),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: bg,
      selectedItemColor: accent,
      unselectedItemColor: textMuted,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    fontFamily: 'Roboto',
  );
}
