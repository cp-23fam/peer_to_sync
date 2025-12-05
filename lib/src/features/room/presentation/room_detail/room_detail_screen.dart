import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:peer_to_sync/src/common_widgets/choose_button.dart';
import 'package:peer_to_sync/src/common_widgets/styled_text.dart';
import 'package:peer_to_sync/src/constants/app_sizes.dart';
import 'package:peer_to_sync/src/features/room/data/room_repository.dart';
import 'package:peer_to_sync/src/features/room/domain/room.dart';
import 'package:peer_to_sync/src/features/room/domain/room_type.dart';
import 'package:peer_to_sync/src/features/room/domain/room_visibility.dart';
import 'package:peer_to_sync/src/features/room/presentation/room_detail/no_user_card.dart';
import 'package:peer_to_sync/src/features/room/presentation/room_detail/user_card.dart';
import 'package:peer_to_sync/src/features/user/data/user_repository.dart';
import 'package:peer_to_sync/src/localization/string_hardcoded.dart';
import 'package:peer_to_sync/src/routing/app_router.dart';
import 'package:peer_to_sync/src/theme/theme.dart';

class RoomDetailScreen extends StatefulWidget {
  const RoomDetailScreen({required this.roomId, super.key});

  final String roomId;

  @override
  State<RoomDetailScreen> createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends State<RoomDetailScreen> {
  Widget createCard(
    Room room,
    int index, {
    required bool canControl,
    VoidCallback? onKick,
  }) {
    if (index == 0) {
      return UserCard(isHost: true, userId: room.users[index]);
    }

    if (index < room.users.length) {
      return UserCard(
        isHost: false,
        userId: room.users[index],
        canControl: canControl,
        onKick: onKick,
      );
    }

    return const NoUserCard();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Consumer(
          builder: (context, ref, child) {
            final roomData = ref.watch(roomStreamProvider(widget.roomId));

            return roomData.when(
              data: (room) {
                if (room == null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    context.goNamed(RouteNames.home.name);
                  });

                  return const Center(child: SizedBox());
                }

                return Column(
                  children: [
                    Container(
                      height: 80,
                      padding: const EdgeInsets.all(Sizes.p12),
                      color: colors.surface,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          Container(
                            padding: const EdgeInsets.all(Sizes.p8),
                            decoration: BoxDecoration(
                              color: colors.background.withAlpha(150),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            child: Icon(
                              room.type == RoomType.game
                                  ? Icons.games
                                  : room.type == RoomType.collab
                                  ? Icons.handshake
                                  : Icons.question_mark,
                              size: Sizes.p32,
                              color: colors.onSurface,
                            ),
                          ),

                          StyledText(room.name, 36.0, bold: true),

                          Container(
                            padding: const EdgeInsets.all(Sizes.p8),
                            decoration: BoxDecoration(
                              color: room.visibility == RoomVisibility.friends
                                  ? colors.blue
                                  : colors.background,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            child: Icon(
                              room.visibility == RoomVisibility.public
                                  ? Icons.public
                                  : room.visibility == RoomVisibility.private
                                  ? Icons.lock
                                  : Icons.groups_2_outlined,
                              size: Sizes.p32,
                              color: colors.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                    room.visibility == RoomVisibility.private
                        ? Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: StyledText(
                              'Mot de passe de la salle : ${room.password}',
                              24.0,
                            ),
                          )
                        : const SizedBox(),
                    gapH12,
                    Text('${room.users.length} / ${room.maxPlayers}'.hardcoded),
                    gapH12,
                    Consumer(
                      builder: (context, ref, child) {
                        final userData = ref.watch(userInfosProvider);

                        return userData.when(
                          data: (user) {
                            if (!room.users.contains(user!.uid)) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                context.goNamed(RouteNames.home.name);
                              });
                            }

                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(Sizes.p8),
                                child: ListView.separated(
                                  itemBuilder: (context, index) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: Sizes.p8,
                                    ),
                                    child: createCard(
                                      room,
                                      index,
                                      canControl: user.uid == room.hostId,
                                      onKick: () async => await ref
                                          .read(roomRepositoryProvider)
                                          .kickUser(room.id, room.users[index]),
                                    ),
                                  ),
                                  separatorBuilder: (context, index) => gapH16,
                                  itemCount: room.maxPlayers,
                                ),
                              ),
                            );
                          },
                          error: (error, stackTrace) =>
                              Center(child: Text(error.toString())),
                          loading: () {
                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(Sizes.p8),
                                child: ListView.separated(
                                  itemBuilder: (context, index) =>
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: Sizes.p8,
                                        ),
                                        child: NoUserCard(),
                                      ),
                                  separatorBuilder: (context, index) => gapH16,
                                  itemCount: room.maxPlayers,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                );
              },
              error: (error, stackTrace) =>
                  Center(child: Text(error.toString())),
              loading: () => const Center(child: CircularProgressIndicator()),
            );
          },
        ),
      ),
      bottomNavigationBar: ClipRRect(
        child: Container(
          height: 64,
          color: colors.surface,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Consumer(
                builder: (context, ref, child) {
                  return ChooseButton(
                    text: 'Quitter',
                    color: colors.error,
                    onPressed: () async {
                      await ref
                          .read(roomRepositoryProvider)
                          .quitRoom(widget.roomId);

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        context.goNamed(RouteNames.home.name);
                      });
                    },
                  );
                },
              ),
              gapW16,
              ChooseButton(
                text: 'Lancer',
                color: colors.green,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
