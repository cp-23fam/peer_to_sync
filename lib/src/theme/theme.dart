import 'package:flutter/material.dart';
import 'package:peer_to_sync/src/constants/app_sizes.dart';

// Black
class AppColors {
  static Color firstColor = const Color(0xFF303030);
  static Color secondColor = const Color(0xFF2A2A2A);
  static Color thirdColor = const Color(0xFF242424);
  static Color fourthColor = const Color(0xFF222222);
  static Color fifthColor = const Color(0xFF1a1a1a);

  static Color navBackgroundColor = const Color(0xFF121212);

  static Color whiteColor = const Color(0xFFFFFFFF);
  static Color backgroundIconColor = const Color(0xFFA0A0A0);
  static Color backgroundIconAccent = const Color(0xFF606060);

  static Color greenColor = const Color(0xFF1BA300);
  static Color orangeColor = const Color(0xFFD77D00);
  static Color redColor = const Color(0xFFA30000);
  static Color goldColor = const Color(0xFFFFB753);
}

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,

  // scaffold color
  scaffoldBackgroundColor: AppColors.fifthColor,
);

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,

  // scaffold color
  scaffoldBackgroundColor: AppColors.whiteColor,
);


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

// ThemeData lightTheme = ThemeData(
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