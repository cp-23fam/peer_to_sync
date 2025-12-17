import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:peer_to_sync/src/common_widgets/async_value_widget.dart';
import 'package:peer_to_sync/src/common_widgets/choose_button.dart';
import 'package:peer_to_sync/src/common_widgets/styled_text.dart';
import 'package:peer_to_sync/src/constants/app_sizes.dart';
import 'package:peer_to_sync/src/features/room/data/room_repository.dart';
import 'package:peer_to_sync/src/features/room/domain/room.dart';
import 'package:peer_to_sync/src/features/room/domain/room_visibility.dart';
import 'package:peer_to_sync/src/features/room/presentation/room_list/room_card.dart';
import 'package:peer_to_sync/src/features/user/data/user_repository.dart';
import 'package:peer_to_sync/src/features/user/presentation/user_settings/profile_picture.dart';
import 'package:peer_to_sync/src/localization/string_hardcoded.dart';
import 'package:peer_to_sync/src/routing/app_router.dart';
import 'package:peer_to_sync/src/theme/theme.dart';

class RoomListScreen extends StatefulWidget {
  const RoomListScreen({super.key});

  @override
  State<RoomListScreen> createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen> {
  List<Room> filteredRooms = [];
  String _searchQuery = '';

  Widget roomsList() {
    return ListView.separated(
      itemBuilder: (context, index) => RoomCard(room: filteredRooms[index]),
      separatorBuilder: (context, index) => gapH16,
      itemCount: filteredRooms.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 80,
              padding: const EdgeInsets.all(Sizes.p12),
              color: colors.surface,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StyledText('Salles'.hardcoded, 30.0, bold: true, upper: true),
                  GestureDetector(
                    onTap: () => context.goNamed(RouteNames.user.name),
                    child: Consumer(
                      builder: (context, ref, child) {
                        final userData = ref.watch(userInfosProvider);

                        return AsyncValueWidget(
                          asyncValue: userData,
                          onData: (user) {
                            if (user != null) {
                              return ProfilePicture(
                                user.imageUrl,
                                radius: 28.0,
                              );
                            } else {
                              return CircleAvatar(
                                backgroundColor: colors.secondary,
                                radius: 40.0,
                                child: Icon(
                                  Icons.login,
                                  color: colors.onSurface,
                                  size: 40.0,
                                ),
                              );
                            }
                          },
                          onLoading: () => CircleAvatar(
                            backgroundColor: colors.secondary,
                            radius: 40.0,
                            child: Icon(
                              Icons.person_outline,
                              color: colors.onSurface,
                              size: 40.0,
                            ),
                          ),
                          onError: (e, st) => CircleAvatar(
                            backgroundColor: colors.secondary,
                            radius: 40.0,
                            child: Icon(
                              Icons.close,
                              color: colors.onSurface,
                              size: 40.0,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            gapH12,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.p12),
              child: TextField(
                style: TextStyle(color: colors.onSurface),
                decoration: InputDecoration(
                  hintText: 'Rechercher une salle...',
                  hintStyle: TextStyle(color: colors.onSurface.withAlpha(150)),
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Sizes.p4),
                  ),
                  fillColor: colors.primary,
                ),
                onChanged: (value) {
                  setState(() => _searchQuery = value.toLowerCase());
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(Sizes.p12),
                child: Consumer(
                  builder: (context, ref, child) {
                    final roomsData = ref.watch(roomListStreamProvider);
                    final userData = ref.watch(userInfosProvider);

                    return AsyncValueWidget(
                      asyncValue: roomsData,
                      onData: (rooms) => AsyncValueWidget(
                        asyncValue: userData,
                        onData: (user) {
                          if (user == null) {
                            rooms = rooms
                                .where(
                                  (room) =>
                                      room.visibility ==
                                          RoomVisibility.public ||
                                      room.visibility == RoomVisibility.private,
                                )
                                .toList();
                          } else {
                            rooms = rooms.where((room) {
                              if (room.visibility == RoomVisibility.public ||
                                  room.visibility == RoomVisibility.private) {
                                return true;
                              }

                              if (room.visibility == RoomVisibility.friends) {
                                return user.friends.contains(room.hostId);
                              }
                              return false;
                            }).toList();
                          }

                          if (_searchQuery.isNotEmpty) {
                            rooms = rooms
                                .where(
                                  (room) => room.name.toLowerCase().contains(
                                    _searchQuery,
                                  ),
                                )
                                .toList();
                          }

                          rooms.sort((a, b) {
                            final aIsFriend =
                                // user?.friends.contains(a.hostId) ?? false;
                                user?.friends.contains(a.hostId) ?? false
                                ? a.visibility == RoomVisibility.friends
                                      ? true
                                      : false
                                : false;
                            final bIsFriend =
                                // user?.friends.contains(b.hostId) ?? false;
                                user?.friends.contains(b.hostId) ?? false
                                ? b.visibility == RoomVisibility.friends
                                      ? true
                                      : false
                                : false;

                            if (aIsFriend && !bIsFriend) return -1;
                            if (!aIsFriend && bIsFriend) return 1;

                            return 0;
                          });

                          filteredRooms = rooms;

                          return rooms.isEmpty
                              ? Center(
                                  child: StyledText(
                                    'Aucune salle trouvée.'.hardcoded,
                                    20,
                                  ),
                                )
                              : roomsList();
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 64,
        color: colors.surface,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ChooseButton(
              text: 'Créer une salle',
              color: colors.green,
              onPressed: () => context.goNamed(RouteNames.create.name),
            ),
          ],
        ),
      ),
    );
  }
}
