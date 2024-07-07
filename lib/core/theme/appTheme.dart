import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF1E1E1E); // Dark background
  static const Color accentColor = Color(0xFF66C6FF); // Light blue accent
  static const Color backgroundColor = Color(0xFF121212); // Darker background
  static const Color cardColor = Color(0xFF1E1E1E); // Same as primary for cards
  static const Color textColor = Color(0xFFE0E0E0); // Light grey text
  static const Color buttonTextColor = Colors.white; // White text for buttons
  static const Color normalTextColor = Color(0xFF66C6FF); // Light blue text

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    hintColor: accentColor,
    scaffoldBackgroundColor: backgroundColor,
    cardColor: cardColor,
    iconTheme: IconThemeData(color: accentColor), // Set default icon color
    textTheme: TextTheme(
      titleLarge: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 24),
      bodyMedium: TextStyle(color: normalTextColor, fontSize: 16),
      bodySmall: TextStyle(color: normalTextColor, fontSize: 14),
      bodyLarge: TextStyle(color: normalTextColor, fontSize: 18),
      headlineSmall: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 20),
      headlineMedium: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 22),
      headlineLarge: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 24),
      displaySmall: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 26),
      displayMedium: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 28),
      displayLarge: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 30),
    ),
    appBarTheme: AppBarTheme(
      color: primaryColor,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold),
      iconTheme: IconThemeData(color: accentColor), // Set AppBar icon color
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: accentColor,
      foregroundColor: buttonTextColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(accentColor),
        foregroundColor: MaterialStateProperty.all(buttonTextColor),
        textStyle: MaterialStateProperty.all(TextStyle(fontSize: 16)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(accentColor),
        textStyle: MaterialStateProperty.all(TextStyle(fontSize: 16)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        side: MaterialStateProperty.all(BorderSide(color: accentColor)),
        foregroundColor: MaterialStateProperty.all(accentColor),
        textStyle: MaterialStateProperty.all(TextStyle(fontSize: 16)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFF2E2E2E),
      hintStyle: TextStyle(color: Colors.grey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: accentColor),
      ),
      labelStyle: TextStyle(color: textColor),
      prefixIconColor: accentColor, // Set color for prefix icons in input fields
      suffixIconColor: accentColor, // Set color for suffix icons in input fields
    ),
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: primaryColor,
      onPrimary: Colors.white,
      secondary: accentColor,
      onSecondary: Colors.white,
      surface: primaryColor,
      onSurface: textColor,
      background: backgroundColor,
      onBackground: textColor,
      error: Colors.red,
      onError: Colors.white,
    ),
  );
}