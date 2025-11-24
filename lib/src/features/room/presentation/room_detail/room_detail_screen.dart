import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:peer_to_sync/src/common_widgets/styled_text.dart';
import 'package:peer_to_sync/src/constants/app_sizes.dart';
import 'package:peer_to_sync/src/features/room/data/room_repository.dart';
import 'package:peer_to_sync/src/features/room/domain/room.dart';
import 'package:peer_to_sync/src/features/room/presentation/room_detail/no_user_card.dart';
import 'package:peer_to_sync/src/features/room/presentation/room_detail/user_card.dart';
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
  Widget createCard(Room room, int index) {
    if (index == 0) {
      return const UserCard(isHost: true);
    }

    if (index < room.users.length) {
      return const UserCard(isHost: false);
    }

    return const NoUserCard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer(
          builder: (context, ref, child) {
            final roomData = ref.watch(roomProvider(widget.roomId));

            return roomData.when(
              data: (room) {
                if (room == null) {
                  return Center(
                    child: ElevatedButton(
                      onPressed: () {
                        context.goNamed(RouteNames.home.name);
                      },
                      child: Text('Salle inconnue'.hardcoded),
                    ),
                  );
                }

                return Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(Sizes.p16),
                      child: StyledText('RoomName', 36.0, bold: true),
                    ),
                    Text('${room.users.length} / ${room.maxPlayers}'.hardcoded),
                    gapH12,
                    Expanded(
                      child: ListView.separated(
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Sizes.p8,
                          ),
                          child: createCard(room, index),
                        ),
                        separatorBuilder: (context, index) => gapH16,
                        itemCount: room.maxPlayers,
                      ),
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
        borderRadius: BorderRadius.circular(10),
        child: Container(height: 60, color: AppColors.navBackgroundColor),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Consumer(
            builder: (context, ref, child) {
              return Container(
                margin: const EdgeInsets.only(top: 10),
                height: 60,
                width: 180,
                child: FloatingActionButton(
                  backgroundColor: AppColors.redColor,
                  elevation: 0,
                  onPressed: () async {
                    await ref
                        .read(roomRepositoryProvider)
                        .quitRoom(widget.roomId);

                    if (context.mounted) {
                      context.goNamed(RouteNames.home.name);
                    }
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: StyledText('Quitter'.hardcoded, 40.0, bold: true),
                ),
              );
            },
          ),
          gapW16,
          Container(
            margin: const EdgeInsets.only(top: 10),
            height: 60,
            width: 180,
            child: FloatingActionButton(
              backgroundColor: AppColors.greenColor,
              elevation: 0,
              onPressed: () {},
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              child: StyledText('Lancer'.hardcoded, 40.0, bold: true),
            ),
          ),
        ],
      ),
    );
  }
}
