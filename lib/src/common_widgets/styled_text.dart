import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StyledText extends StatelessWidget {
  const StyledText(
    this.text,
    this.fontSize, {
    this.upper = false,
    this.bold = false,
    this.white = false,
    super.key,
  });

  final String text;
  final double fontSize;
  final bool upper;
  final bool bold;
  final bool white;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Text(
      upper ? text.toUpperCase() : text,
      style: GoogleFonts.lato(
        color: white ? Colors.white : colors.onSurface,
        fontSize: fontSize,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
