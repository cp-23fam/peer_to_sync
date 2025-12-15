import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peer_to_sync/src/common_widgets/async_value_widget.dart';
import 'package:peer_to_sync/src/constants/app_sizes.dart';
import 'package:peer_to_sync/src/features/user/data/user_repository.dart';
import 'package:peer_to_sync/src/theme/theme.dart';

class SmallUserImage extends ConsumerWidget {
  const SmallUserImage({required this.colors, required this.userId, super.key});

  final ColorScheme colors;
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userProvider(userId));

    return AsyncValueWidget(
      asyncValue: userData,
      onData: (user) {
        return Container(
          padding: const EdgeInsets.all(Sizes.p8),
          decoration: BoxDecoration(
            color: colors.iconBackground,

            image: DecorationImage(
              image: NetworkImage(user?.imageUrl ?? ''),
              fit: BoxFit.contain,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(Sizes.p4)),
          ),
          child: const Icon(
            Icons.person_outline,
            color: Colors.transparent,
            size: 35.0,
          ),
        );
      },
      onLoading: () {
        return Container(
          padding: const EdgeInsets.all(Sizes.p8),
          decoration: BoxDecoration(
            color: colors.iconBackground,
            borderRadius: const BorderRadius.all(Radius.circular(Sizes.p4)),
          ),
          child: Icon(
            Icons.person_outline,
            color: colors.onSurface,
            size: 35.0,
          ),
        );
      },
    );
  }
}
