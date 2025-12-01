import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peer_to_sync/src/common_widgets/small_user_image.dart';
import 'package:peer_to_sync/src/common_widgets/styled_text.dart';
import 'package:peer_to_sync/src/constants/app_sizes.dart';
import 'package:peer_to_sync/src/features/room/presentation/room_detail/no_user_card.dart';
import 'package:peer_to_sync/src/features/user/data/user_repository.dart';
import 'package:peer_to_sync/src/theme/theme.dart';

class UserCard extends StatelessWidget {
  const UserCard({
    required this.userId,
    required this.isHost,
    this.canControl = false,
    this.onKick,
    super.key,
  });

  final String userId;
  final bool isHost;
  final bool canControl;
  final VoidCallback? onKick;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(Sizes.p4)),
        color: colors.secondary,
        border: Border.all(
          width: 3.0,
          color: !isHost ? colors.gold.withAlpha(0) : colors.gold,
        ),
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
        child: Consumer(
          builder: (context, ref, child) {
            final userData = ref.watch(userProvider(userId));

            return userData.when(
              data: (user) {
                if (user == null) {
                  return const NoUserCard();
                }

                return Row(
                  children: [
                    SmallUserImage(colors: colors, userId: userId),
                    gapW16,
                    StyledText(user.username, Sizes.p32, bold: true),
                    const Expanded(child: SizedBox()),
                    if (isHost)
                      Icon(Icons.star, color: colors.gold, size: 45.0)
                    else if (canControl)
                      IconButton(
                        onPressed: onKick,
                        icon: Icon(
                          Icons.delete,
                          color: colors.error,
                          size: 30.0,
                        ),
                      ),
                  ],
                );
              },
              error: (error, stackTrace) =>
                  Center(child: Text(error.toString())),
              loading: () {
                return Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(Sizes.p8),
                      decoration: BoxDecoration(
                        color: colors.iconBackground,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(Sizes.p4),
                        ),
                      ),
                      child: Icon(
                        Icons.person_outline,
                        color: colors.onSurface,
                        size: 35.0,
                      ),
                    ),
                    gapW16,
                    const StyledText('. . .', Sizes.p32, bold: true),
                    const Expanded(child: SizedBox()),
                    if (isHost)
                      Icon(Icons.star, color: colors.gold, size: 45.0),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
