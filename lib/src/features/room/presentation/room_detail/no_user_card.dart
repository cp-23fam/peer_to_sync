import 'package:flutter/material.dart';
import 'package:peer_to_sync/src/common_widgets/styled_text.dart';
import 'package:peer_to_sync/src/constants/app_sizes.dart';
import 'package:peer_to_sync/src/theme/theme.dart';

class NoUserCard extends StatelessWidget {
  const NoUserCard({
    // required this.userId,
    required this.isHost,
    super.key,
  });

  // final String userId;
  final bool isHost;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(Sizes.p20)),
        color: AppColors.thirdColor,
        border: Border.all(width: 3.0, color: AppColors.goldColor.withAlpha(0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.backgroundIconAccent,
              radius: 25.0,
              child: Icon(
                Icons.person_outline,
                color: AppColors.whiteColor,
                size: 35.0,
              ),
            ),
            gapW16,
            StyledText('. . .', Sizes.p32, bold: true),
          ],
        ),
      ),
    );
  }
}
