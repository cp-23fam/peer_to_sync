import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peer_to_sync/src/common_widgets/choose_button.dart';
import 'package:peer_to_sync/src/common_widgets/small_user_image.dart';
import 'package:peer_to_sync/src/common_widgets/styled_text.dart';
import 'package:peer_to_sync/src/constants/app_sizes.dart';
import 'package:peer_to_sync/src/features/user/data/user_repository.dart';
import 'package:peer_to_sync/src/features/user/domain/user.dart';
import 'package:peer_to_sync/src/theme/theme.dart';

class FriendCard extends StatelessWidget {
  const FriendCard({required this.friend, super.key});

  final User friend;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(Sizes.p4)),
        color: colors.secondary,
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
            final userData = ref.watch(userProvider(friend.uid));

            return userData.when(
              data: (user) {
                return Row(
                  children: [
                    SmallUserImage(colors: colors, userId: user!.uid),
                    gapW16,
                    StyledText(user.username, Sizes.p32, bold: true),
                    const Expanded(child: SizedBox()),
                    CircleButton(
                      icon: Icons.delete,
                      color: colors.error,
                      onPressed: () async {
                        await ref
                            .read(userRepositoryProvider)
                            .removeFriend(friend.uid);
                      },
                    ),
                    gapW4,
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
