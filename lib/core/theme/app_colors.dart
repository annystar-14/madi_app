import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryBlue = Color.fromARGB(255, 26, 114, 192);
  static const Color accentTurquoise = Color.fromARGB(255, 5, 176, 199); // El turquesa del botón
  static const Color lightBackground = Color.fromARGB(255, 230, 235, 245); // Fondo blanco/gris muy claro

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
    Color(0xFF0D47A1), // Azul profundo
    Color.fromARGB(255, 31, 138, 209),
    Color.fromARGB(255, 24, 177, 197), // Turquesa vibrante
  ],
);
}