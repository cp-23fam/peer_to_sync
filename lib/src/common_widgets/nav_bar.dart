import 'package:flutter/material.dart';
import 'package:peer_to_sync/src/theme/theme.dart';

class NavBar extends StatelessWidget {
  final int pageIndex;
  final Function(int) onTap;

  const NavBar({super.key, required this.pageIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 60,
        color: AppColors.navBackgroundColor,
        child: Row(
          children: [
            navItem(Icons.home_outlined, pageIndex == 0, onTap: () => onTap(0)),
            const SizedBox(width: 80),
            navItem(
              // TODO : Changement d'icon si le user n'est pas connecté
              Icons.person_outline, // login
              pageIndex == 1,
              onTap: () => onTap(1),
            ),
          ],
        ),
      ),
    );
  }

  Widget navItem(IconData icon, bool selected, {Function()? onTap}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Icon(
          icon,
          color: selected ? Colors.white : Colors.white.withAlpha(100),
          size: 40.0,
        ),
      ),
    );
  }
}
