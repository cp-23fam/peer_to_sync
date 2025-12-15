import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peer_to_sync/src/common_widgets/async_value_widget.dart';
import 'package:peer_to_sync/src/common_widgets/styled_text.dart';
import 'package:peer_to_sync/src/constants/app_sizes.dart';
import 'package:peer_to_sync/src/features/user/data/user_repository.dart';
import 'package:peer_to_sync/src/features/user/presentation/friends/friends_list/friend_card.dart';
import 'package:peer_to_sync/src/localization/string_hardcoded.dart';

class FriendsListScreen extends StatefulWidget {
  const FriendsListScreen({super.key});

  @override
  State<FriendsListScreen> createState() => _FriendsListScreenState();
}

class _FriendsListScreenState extends State<FriendsListScreen> {
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
              final friendData = ref.watch(friendsProvider);

              return AsyncValueWidget(
                asyncValue: friendData,
                onData: (friends) {
                  return friends.isEmpty
                      ? const StyledText('', 20.0)
                      // ? const StyledText('0 Ami', 20.0)
                      : friends.length == 1
                      ? StyledText('${friends.length} Ami', 20.0)
                      : StyledText('${friends.length} Amis', 20.0);
                },
              );
            },
          ),
          gapH12,

          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final friendData = ref.watch(friendsProvider);

                return AsyncValueWidget(
                  asyncValue: friendData,
                  onData: (friends) {
                    return friends.isEmpty
                        ? Center(
                            child: StyledText(
                              'Aucun ami trouvé.'.hardcoded,
                              20.0,
                            ),
                          )
                        : ListView.separated(
                            itemBuilder: (context, index) =>
                                FriendCard(friend: friends[index]),
                            separatorBuilder: (context, index) => gapH16,
                            itemCount: friends.length,
                          );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
