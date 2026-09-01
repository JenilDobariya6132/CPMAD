import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor =
      Color(0xFF2563EB);

  static const Color backgroundColor =
      Color(0xFFF4F7FC);

  static const Color textColor =
      Color(0xFF1E293B);

  static const Color secondaryTextColor =
      Color(0xFF64748B);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    scaffoldBackgroundColor:
        backgroundColor,

    colorScheme:
        ColorScheme.fromSeed(
      seedColor: primaryColor,
    ),

    appBarTheme:
        const AppBarTheme(
      backgroundColor:
          primaryColor,

      foregroundColor:
          Colors.white,

      centerTitle: true,

      elevation: 0,
    ),

    cardTheme:
        CardThemeData(
      elevation: 3,

      margin:
          const EdgeInsets.symmetric(
        vertical: 8,
      ),

      shape:
          RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(16),
      ),
    ),

    textTheme:
        const TextTheme(

      headlineSmall:
          TextStyle(
        fontSize: 26,
        fontWeight:
            FontWeight.bold,
        color: textColor,
      ),

      titleLarge:
          TextStyle(
        fontSize: 20,
        fontWeight:
            FontWeight.bold,
        color: textColor,
      ),

      titleMedium:
          TextStyle(
        fontSize: 16,
        fontWeight:
            FontWeight.w600,
        color: textColor,
      ),

      bodyMedium:
          TextStyle(
        fontSize: 14,
        color:
            secondaryTextColor,
      ),
    ),
  );
}