import 'package:flutter/material.dart';
import 'package:peer_to_sync/src/common_widgets/styled_text.dart';
import 'package:peer_to_sync/src/constants/app_sizes.dart';
import 'package:peer_to_sync/src/theme/theme.dart';

class NoUserCard extends StatelessWidget {
  const NoUserCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(Sizes.p4)),
        color: AppColors.thirdColor,
        border: Border.all(width: 3.0, color: AppColors.goldColor.withAlpha(0)),
        boxShadow: [
          BoxShadow(
            color: AppColors.navBackgroundColor,
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
                color: AppColors.backgroundIconAccent,
                borderRadius: const BorderRadius.all(Radius.circular(Sizes.p4)),
              ),
              child: Icon(
                Icons.person_outline,
                color: AppColors.whiteColor,
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
