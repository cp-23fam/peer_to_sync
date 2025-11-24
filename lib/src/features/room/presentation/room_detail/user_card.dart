import 'package:flutter/material.dart';
import 'package:peer_to_sync/src/common_widgets/styled_text.dart';
import 'package:peer_to_sync/src/constants/app_sizes.dart';
import 'package:peer_to_sync/src/theme/theme.dart';

class UserCard extends StatelessWidget {
  const UserCard({
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
        borderRadius: const BorderRadius.all(Radius.circular(Sizes.p4)),
        color: AppColors.secondColor,
        border: Border.all(
          width: 3.0,
          color: !isHost
              ? AppColors.goldColor.withAlpha(0)
              : AppColors.goldColor,
        ),
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
              padding: EdgeInsets.all(Sizes.p8),
              decoration: BoxDecoration(
                color: AppColors.backgroundIconColor,
                borderRadius: BorderRadius.all(Radius.circular(Sizes.p4)),
              ),
              child: Icon(
                Icons.person_outline,
                color: AppColors.whiteColor,
                size: 35.0,
              ),
            ),
            gapW16,
            StyledText('UserName', Sizes.p32, bold: true),
            const Expanded(child: SizedBox()),
            if (isHost)
              Icon(Icons.star, color: AppColors.goldColor, size: 45.0)
            else if (!isHost)
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.delete, color: AppColors.redColor, size: 30.0),
              ),
          ],
        ),
      ),
    );
  }
}
