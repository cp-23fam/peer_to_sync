import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peer_to_sync/src/common_widgets/styled_text.dart';
import 'package:peer_to_sync/src/constants/app_sizes.dart';
import 'package:peer_to_sync/src/features/user/data/user_repository.dart';
import 'package:peer_to_sync/src/features/user/presentation/friends/friends_pending_list/pending_card.dart';

class FriendsPendingListScreen extends StatefulWidget {
  const FriendsPendingListScreen({super.key});

  @override
  State<FriendsPendingListScreen> createState() =>
      _FriendsPendingListScreenState();
}

class _FriendsPendingListScreenState extends State<FriendsPendingListScreen> {
  @override
  Widget build(BuildContext context) {
    // final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          gapH4,
          StyledText('2 Demandes d\'amis', 20.0),
          gapH12,

          Consumer(
            builder: (context, ref, child) {
              final pendingData = ref.watch(pendingsProvider);

              return pendingData.when(
                data: (pendings) {
                  return ListView.separated(
                    itemBuilder: (context, index) =>
                        PendingCard(userId: pendings[index]),
                    separatorBuilder: (context, index) => gapH16,
                    itemCount: pendings.length,
                  );
                },
                error: (error, st) => Center(child: Text(error.toString())),
                loading: () => const Center(child: CircularProgressIndicator()),
              );
            },
          ),
        ],
      ),
    );
  }
}
