import 'package:flutter/material.dart';

/// ------------------------------------------------------------
/// EXTENSIONS
/// ------------------------------------------------------------
extension ExtraColors on ColorScheme {
  Color get gold => const Color(0xFFFFB753); // Or
  Color get orange => const Color(0xFFD77D00); // Orange vif
  Color get green => const Color(0xFF1BA300); // Vert validation
  Color get blue => const Color(0xFF07739A);
  Color get black => const Color(0xFF000000);
  Color get iconBackground => primaryContainer; // Fond icônes normal
  Color get iconAccent => secondaryContainer; // Fond icônes accent
}

// ------------------------------------------------------------
// Dark Mode
// ------------------------------------------------------------
ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,

  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF303030), // Éléments principaux
    secondary: Color(0xFF2A2A2A), // Éléments secondaires
    surface: Color(0xFF242424), // Cartes / containers
    background: Color(0xFF1A1A1A), // Fond global
    error: Color(0xFFA30000), // Erreurs
  ),

  scaffoldBackgroundColor: const Color(0xFF1A1A1A),

  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF222222),
    foregroundColor: Colors.white,
    centerTitle: true,
  ),
);

// ------------------------------------------------------------
// Light Mode
// ------------------------------------------------------------
ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,

  colorScheme: const ColorScheme.light(
    primary: Color(0xFFBBBBBB), // Éléments principaux
    secondary: Color(0xFFCCCCCC), // Éléments secondaires
    // surface: Color(0xFFDDDDDD), // Cartes / containers
    surface: Color(0xFFF4F4F4), // Cartes / containers
    background: Colors.white, // Fond global
    error: Color(0xFFA30000), // Erreurs
  ),

  // scaffoldBackgroundColor: Colors.white,
  scaffoldBackgroundColor: Color(0xFFEEEEEE),

  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    centerTitle: true,
  ),
);
