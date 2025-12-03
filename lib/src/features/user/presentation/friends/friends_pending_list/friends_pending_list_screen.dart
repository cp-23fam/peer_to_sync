import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peer_to_sync/src/common_widgets/styled_text.dart';
import 'package:peer_to_sync/src/constants/app_sizes.dart';
import 'package:peer_to_sync/src/features/user/data/user_repository.dart';
import 'package:peer_to_sync/src/features/user/presentation/friends/friends_pending_list/pending_card.dart';
import 'package:peer_to_sync/src/localization/string_hardcoded.dart';

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
          Consumer(
            builder: (context, ref, child) {
              final pendingData = ref.watch(pendingsProvider);
              return pendingData.when(
                data: (pendings) {
                  return pendings.isEmpty
                      ? const StyledText('', 20.0)
                      // ? const StyledText('0 Demande d\'amis', 20.0)
                      : pendings.length == 1
                      ? StyledText('${pendings.length} Demande d\'amis', 20.0)
                      : StyledText('${pendings.length} Demandes d\'amis', 20.0);
                },
                error: (error, st) => Center(child: Text(error.toString())),
                loading: () => const Center(child: CircularProgressIndicator()),
              );
            },
          ),
          gapH12,

          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final pendingData = ref.watch(pendingsProvider);

                return pendingData.when(
                  data: (pendings) {
                    return pendings.isEmpty
                        ? Center(
                            child: StyledText(
                              'Aucune demande d\'ami trouvée.'.hardcoded,
                              20.0,
                            ),
                          )
                        : ListView.separated(
                            itemBuilder: (context, index) =>
                                PendingCard(user: pendings[index]),
                            separatorBuilder: (context, index) => gapH16,
                            itemCount: pendings.length,
                          );
                  },
                  error: (error, st) => Center(child: Text(error.toString())),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
