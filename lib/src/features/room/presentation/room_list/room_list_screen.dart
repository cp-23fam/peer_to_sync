import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:peer_to_sync/src/common_widgets/choose_button.dart';
import 'package:peer_to_sync/src/common_widgets/styled_text.dart';
import 'package:peer_to_sync/src/constants/app_sizes.dart';
import 'package:peer_to_sync/src/features/room/data/room_repository.dart';
import 'package:peer_to_sync/src/features/room/domain/room.dart';
import 'package:peer_to_sync/src/features/room/presentation/room_list/room_card.dart';
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

  Widget roomsList() {
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (context, index) => RoomCard(room: filteredRooms[index]),
      separatorBuilder: (context, index) => gapH8,
      itemCount: filteredRooms.length,
    );
  }

  String _searchQuery = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                height: 80,
                padding: const EdgeInsets.all(Sizes.p12),
                color: AppColors.navBackgroundColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StyledText(
                      'Salles'.hardcoded,
                      30.0,
                      bold: true,
                      upper: true,
                    ),
                    GestureDetector(
                      onTap: () => context.goNamed(RouteNames.user.name),
                      child: CircleAvatar(
                        backgroundColor: AppColors.backgroundIconColor,
                        radius: 28.0,
                        child: Icon(
                          Icons.person_outline,
                          color: AppColors.whiteColor,
                          size: 40.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              gapH12,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Sizes.p12),
                child: TextField(
                  style: TextStyle(color: AppColors.whiteColor),
                  decoration: InputDecoration(
                    hintText: 'Rechercher une salle...',
                    hintStyle: TextStyle(
                      color: AppColors.whiteColor.withAlpha(150),
                    ),
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Sizes.p4),
                    ),
                    fillColor: AppColors.firstColor,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(Sizes.p12),
                  child: Expanded(
                    child: Consumer(
                      builder: (context, ref, child) {
                        final roomsData = ref.watch(roomListStreamProvider);

                        return roomsData.when(
                          data: (rooms) {
                            if (_searchQuery.isNotEmpty) {
                              // rooms = searchInRooms(rooms, _searchQuery);

                              rooms = rooms.where((room) {
                                final fullName = room.name.toLowerCase();
                                return fullName.contains(_searchQuery);
                              }).toList();
                            }
                            filteredRooms = rooms;

                            return rooms.isEmpty
                                ? Center(
                                    child: StyledText(
                                      'Aucune salle trouvée.'.hardcoded,
                                      20.0,
                                    ),
                                  )
                                : roomsList();
                          },
                          error: (error, stackTrace) =>
                              Center(child: Text(error.toString())),
                          loading: () => const Expanded(
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ClipRRect(
        child: Container(
          height: 64,
          color: AppColors.navBackgroundColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChooseButton(
                text: 'Créer une Salle',
                color: AppColors.greenColor,
                onPressed: () {
                  context.goNamed(RouteNames.create.name);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
