import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peer_to_sync/src/common_widgets/styled_text.dart';
import 'package:peer_to_sync/src/constants/app_sizes.dart';
import 'package:peer_to_sync/src/features/room/data/room_repository.dart';
import 'package:peer_to_sync/src/features/room/domain/room.dart';
import 'package:peer_to_sync/src/features/room/presentation/room_list/room_card.dart';
import 'package:peer_to_sync/src/localization/string_hardcoded.dart';
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

  // String _searchQuery = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(Sizes.p12),
                  child: StyledText(
                    'Home'.hardcoded,
                    40.0,
                    bold: true,
                    upper: true,
                  ),
                ),
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
                        borderRadius: BorderRadius.circular(Sizes.p32),
                      ),
                      fillColor: AppColors.firstColor,
                    ),
                    // onChanged: (value) {
                    //   _searchQuery = value;
                    // },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(Sizes.p16),
                  child: Consumer(
                    builder: (context, ref, child) {
                      final roomsData = ref.watch(roomListProvider);

                      return roomsData.when(
                        data: (rooms) {
                          filteredRooms = rooms;

                          return roomsList();
                        },
                        error: (error, stackTrace) =>
                            Center(child: Text(error.toString())),
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
