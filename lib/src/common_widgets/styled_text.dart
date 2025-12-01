// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:peer_to_sync/src/theme/theme.dart';

// class StyledText extends StatelessWidget {
//   const StyledText(
//     this.text,
//     this.fontSize, {
//     this.upper = false,
//     this.bold = false,
//     super.key,
//   });
//   final String text;
//   final double fontSize;
//   final bool upper;
//   final bool bold;
//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       upper ? text.toUpperCase() : text,
//       style: GoogleFonts.lato(
//         color: AppColors.whiteColor,
//         fontSize: fontSize,
//         // textStyle: TextStyle(
//         //   fontWeight: bold ? FontWeight.bold : FontWeight.normal,
//         // ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StyledText extends StatelessWidget {
  const StyledText(
    this.text,
    this.fontSize, {
    this.upper = false,
    this.bold = false,
    super.key,
  });

  final String text;
  final double fontSize;
  final bool upper;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Text(
      upper ? text.toUpperCase() : text,
      style: GoogleFonts.lato(
        color: colors.onSurface,
        fontSize: fontSize,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
