import 'package:flutter/material.dart';
import 'package:peer_to_sync/src/common_widgets/styled_text.dart';
import 'package:peer_to_sync/src/constants/app_sizes.dart';
import 'package:peer_to_sync/src/theme/theme.dart';

class NoUserCard extends StatelessWidget {
  const NoUserCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(Sizes.p4)),
        color: colors.surface,
        border: Border.all(width: 3.0, color: colors.gold.withAlpha(0)),
        boxShadow: [
          BoxShadow(
            color: colors.surface,
            spreadRadius: 2,
            blurRadius: 2,
            offset: const Offset(3, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(Sizes.p8),
              decoration: BoxDecoration(
                color: colors.iconAccent,
                borderRadius: const BorderRadius.all(Radius.circular(Sizes.p4)),
              ),
              child: Icon(
                Icons.person_outline,
                color: colors.onSurface,
                size: 35.0,
              ),
            ),
            gapW16,
            const StyledText('. . .', Sizes.p32, bold: true),
          ],
        ),
      ),
    );
  }
}
