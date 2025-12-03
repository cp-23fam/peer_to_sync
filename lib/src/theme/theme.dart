// import 'package:flutter/material.dart';
// import 'package:peer_to_sync/src/constants/app_sizes.dart';

// // Black
// class AppColors {
//   static Color firstColor = const Color(0xFF303030);
//   static Color secondColor = const Color(0xFF2A2A2A);
//   static Color thirdColor = const Color(0xFF242424);
//   static Color fourthColor = const Color(0xFF222222);
//   static Color fifthColor = const Color(0xFF1a1a1a);

//   static Color navBackgroundColor = const Color(0xFF121212);

//   static Color whiteColor = const Color(0xFFFFFFFF);
//   static Color blackColor = const Color(0xFF000000);
//   static Color backgroundIconColor = const Color(0xFFA0A0A0);
//   static Color backgroundIconAccent = const Color(0xFF606060);

//   static Color greenColor = const Color(0xFF1BA300);
//   static Color orangeColor = const Color(0xFFD77D00);
//   static Color redColor = const Color(0xFFA30000);
//   static Color goldColor = const Color(0xFFFFB753);
// }

// // ThemeData darkTheme = ThemeData(
// //   brightness: Brightness.dark,

// //   // scaffold color
// //   scaffoldBackgroundColor: AppColors.fifthColor,
// // );

// // ThemeData lightTheme = ThemeData(
// //   brightness: Brightness.light,

// //   // scaffold color
// //   scaffoldBackgroundColor: AppColors.whiteColor,
// // );

// ThemeData darkTheme = ThemeData(
//   // seed color
//   colorScheme: ColorScheme.fromSeed(seedColor: AppColors.firstColor),

//   // scaffold color
//   scaffoldBackgroundColor: AppColors.fifthColor,

//   // app bar theme colors
//   appBarTheme: AppBarTheme(
//     backgroundColor: AppColors.fourthColor,
//     foregroundColor: AppColors.whiteColor,
//     surfaceTintColor: Colors.transparent,
//     centerTitle: true,
//   ),

//   // text
//   textTheme: const TextTheme().copyWith(
//     bodyMedium: TextStyle(
//       color: AppColors.whiteColor,
//       fontSize: 16,
//       letterSpacing: 1,
//     ),
//     headlineMedium: TextStyle(
//       color: AppColors.whiteColor,
//       fontSize: 16,
//       fontWeight: FontWeight.bold,
//       letterSpacing: 1,
//     ),
//     titleMedium: TextStyle(
//       color: AppColors.whiteColor,
//       fontSize: 18,
//       fontWeight: FontWeight.bold,
//       letterSpacing: 2,
//     ),
//   ),

//   // card theme
//   cardTheme: CardThemeData(
//     color: AppColors.thirdColor,
//     surfaceTintColor: Colors.transparent,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadiusGeometry.circular(Sizes.p4),
//     ),
//     shadowColor: Colors.transparent,
//     margin: const EdgeInsets.only(bottom: Sizes.p16),
//   ),

//   // input decoration theme
//   inputDecorationTheme: InputDecorationTheme(
//     filled: true,
//     fillColor: AppColors.thirdColor.withValues(alpha: 0.5),
//     border: InputBorder.none,
//     labelStyle: TextStyle(color: AppColors.whiteColor),
//     prefixIconColor: AppColors.whiteColor,
//   ),

//   elevatedButtonTheme: ElevatedButtonThemeData(
//     style: ButtonStyle(
//       backgroundColor: WidgetStateProperty.all<Color>(AppColors.fourthColor),
//       // textStyle: TextStyle(color: )
//     ),
//   ),

//   iconTheme: IconThemeData(color: AppColors.whiteColor, size: Sizes.p32),
//   iconButtonTheme: IconButtonThemeData(
//     style: ButtonStyle(
//       iconColor: WidgetStateProperty.all<Color>(AppColors.whiteColor),
//       iconSize: WidgetStateProperty.all<double>(Sizes.p32),
//     ),
//   ),
// );

// // -----------------------------------------------------------------------

// ThemeData lightTheme = ThemeData(
//   // seed color
//   colorScheme: ColorScheme.fromSeed(seedColor: AppColors.firstColor),

//   // scaffold color
//   scaffoldBackgroundColor: AppColors.whiteColor,

//   // app bar theme colors
//   appBarTheme: AppBarTheme(
//     backgroundColor: AppColors.whiteColor,
//     foregroundColor: AppColors.blackColor,
//     surfaceTintColor: Colors.transparent,
//     centerTitle: true,
//   ),

//   // text
//   textTheme: const TextTheme().copyWith(
//     bodyMedium: TextStyle(
//       color: AppColors.blackColor,
//       fontSize: 16,
//       letterSpacing: 1,
//     ),
//     headlineMedium: TextStyle(
//       color: AppColors.blackColor,
//       fontSize: 16,
//       fontWeight: FontWeight.bold,
//       letterSpacing: 1,
//     ),
//     titleMedium: TextStyle(
//       color: AppColors.blackColor,
//       fontSize: 18,
//       fontWeight: FontWeight.bold,
//       letterSpacing: 2,
//     ),
//   ),

//   // card theme
//   cardTheme: CardThemeData(
//     color: AppColors.thirdColor,
//     surfaceTintColor: Colors.transparent,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadiusGeometry.circular(Sizes.p4),
//     ),
//     shadowColor: Colors.transparent,
//     margin: const EdgeInsets.only(bottom: Sizes.p16),
//   ),

//   // input decoration theme
//   inputDecorationTheme: InputDecorationTheme(
//     filled: true,
//     fillColor: AppColors.thirdColor.withValues(alpha: 0.5),
//     border: InputBorder.none,
//     labelStyle: TextStyle(color: AppColors.whiteColor),
//     prefixIconColor: AppColors.whiteColor,
//   ),

//   elevatedButtonTheme: ElevatedButtonThemeData(
//     style: ButtonStyle(
//       backgroundColor: WidgetStateProperty.all<Color>(AppColors.fourthColor),
//       // textStyle: TextStyle(color: )
//     ),
//   ),

//   iconTheme: IconThemeData(color: AppColors.whiteColor, size: Sizes.p32),
//   iconButtonTheme: IconButtonThemeData(
//     style: ButtonStyle(
//       iconColor: WidgetStateProperty.all<Color>(AppColors.whiteColor),
//       iconSize: WidgetStateProperty.all<double>(Sizes.p32),
//     ),
//   ),
// );

// ThemeData darkTheme = ThemeData(
//   brightness: Brightness.dark,
//   colorScheme: const ColorScheme.dark(
//     primary: Color(0xFF303030),
//     secondary: Color(0xFF2A2A2A),
//     surface: Color(0xFF242424),
//     background: Color(0xFF1A1A1A),
//     error: Color(0xFFA30000),
//   ),

//   scaffoldBackgroundColor: Color(0xFF1A1A1A),

//   appBarTheme: const AppBarTheme(
//     backgroundColor: Color(0xFF222222),
//     foregroundColor: Colors.white,
//     centerTitle: true,
//   ),
// );

// ThemeData lightTheme = ThemeData(
//   brightness: Brightness.light,

//   colorScheme: const ColorScheme.light(
//     primary: Color(0xFF303030),
//     secondary: Color(0xFFEEEEEE),
//     surface: Colors.white,
//     background: Colors.white,
//     error: Color(0xFFA30000),
//   ),

//   scaffoldBackgroundColor: Colors.white,

//   appBarTheme: const AppBarTheme(
//     backgroundColor: Colors.white,
//     foregroundColor: Colors.black,
//     centerTitle: true,
//   ),
// );

import 'package:flutter/material.dart';

/// ------------------------------------------------------------
/// EXTENSIONS
/// ------------------------------------------------------------
extension ExtraColors on ColorScheme {
  Color get gold => const Color(0xFFFFB753); // Or
  Color get orange => const Color(0xFFD77D00); // Orange vif
  Color get green => const Color(0xFF1BA300); // Vert validation
  Color get blue => const Color(0xFF07739A);
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
    surface: Color(0xFFDDDDDD), // Cartes / containers
    background: Colors.white, // Fond global
    error: Color(0xFFA30000), // Erreurs
  ),

  scaffoldBackgroundColor: Colors.white,

  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    centerTitle: true,
  ),
);
