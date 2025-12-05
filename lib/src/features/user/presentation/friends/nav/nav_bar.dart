import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key, required this.pageIndex, required this.onTap});

  final int pageIndex;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ClipRRect(
      child: Container(
        height: 60,
        color: colors.surface,
        child: Row(
          children: [
            navItem(
              Icons.group_outlined,
              isSelected: pageIndex == 0,
              onTap: () => onTap(0),
              colors: colors,
            ),
            navItem(
              Icons.messenger_outline_rounded,
              isSelected: pageIndex == 1,
              onTap: () => onTap(1),
              colors: colors,
            ),
            navItem(
              Icons.person_add_alt,
              isSelected: pageIndex == 2,
              onTap: () => onTap(2),
              colors: colors,
            ),
          ],
        ),
      ),
    );
  }

  Widget navItem(
    IconData icon, {
    required bool isSelected,
    Function()? onTap,
    required ColorScheme colors,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Icon(
          icon,
          color: isSelected
              ? colors.onSurface
              : colors.onSurface.withAlpha(100),
          size: 40.0,
        ),
      ),
    );
  }
}
