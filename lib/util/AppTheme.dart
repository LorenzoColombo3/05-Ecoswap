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
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF2E7D32), // Verde Primario
        secondary: Color(0xFF4CAF50), // Verde Secondario
        background: Color(0xFF212121), // Colore di sfondo
        surface: Color(0xFF424242), // Superficie
        onPrimary: Colors.white, // Testo su primario
        onSecondary: Colors.white, // Testo su secondario
      ),
      // Altri attributi del tema...
    );
  }
}