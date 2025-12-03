import 'package:flutter/material.dart';
import 'package:peer_to_sync/src/common_widgets/styled_text.dart';

class ChooseButton extends StatelessWidget {
  const ChooseButton({
    super.key,
    required this.text,
    required this.color,
    required this.onPressed,
  });

  final Color? color;
  final VoidCallback? onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 180,
      child: FloatingActionButton(
        heroTag: text,
        backgroundColor: color,
        elevation: 0,
        onPressed: onPressed,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        child: StyledText(text, 20.0),
      ),
    );
  }
}

class CircleButton extends StatelessWidget {
  const CircleButton({
    super.key,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  final Color? color;
  final VoidCallback? onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      height: 50,
      width: 50,
      child: FloatingActionButton(
        backgroundColor: color,
        elevation: 0,
        onPressed: onPressed,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: Icon(icon, color: colors.onSurface, size: 40.0),
      ),
    );
  }
}
