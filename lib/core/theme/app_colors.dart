import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryBlue = Color.fromARGB(255, 26, 114, 192);
  static const Color accentTurquoise = Color.fromARGB(255, 5, 176, 199); 
  static const Color lightBackground = Color.fromARGB(255, 230, 235, 245);

  // Colores para textos
  static const Color textPrimary = Color(0xFF424242);
  static const Color textSecondary = Color(0xFF757575);

  // Colores para campos de texto
  static const Color inputBorder = Color(0xFFE0E0E0);
  static const Color inputFill = Colors.white;

    static const Gradient blueGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromARGB(255, 11, 56, 122), 
      Color.fromARGB(255, 27, 119, 180),
      Color.fromARGB(255, 30, 191, 212), 
    ],
  );

}