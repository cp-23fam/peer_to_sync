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
            ),
            navItem(
              Icons.messenger_outline_rounded,
              isSelected: pageIndex == 1,
              onTap: () => onTap(1),
            ),
            navItem(
              Icons.person_add_alt,
              isSelected: pageIndex == 2,
              onTap: () => onTap(2),
            ),
          ],
        ),
      ),
    );
  }

  Widget navItem(IconData icon, {required bool isSelected, Function()? onTap}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.white.withAlpha(100),
          size: 40.0,
        ),
      ),
    );
  }
}
