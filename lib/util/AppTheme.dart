import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      colorScheme: const ColorScheme.light(
        primary: Colors.white, // Verde Primario
        secondary: Colors.lightGreen, // Verde Secondario
        background: Color(0xFF7BFF81), // Colore di sfondo
        surface: Colors.white, // Superficie
        onPrimary: Colors.black, // Testo su primario
        onSecondary: Colors.black, // Testo su secondario
        tertiary: Colors.grey,
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      colorScheme:  ColorScheme.dark(
        primary: Color(0xff303030),
        secondary: Colors.lightGreen,
        background: const Color(0xFF7BFF81),
        surface: Colors.white,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
      ),
    );
  }
}