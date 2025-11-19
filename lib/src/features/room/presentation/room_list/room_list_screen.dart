import 'package:flutter/material.dart';
import 'package:peer_to_sync/src/common_widgets/styled_text.dart';
import 'package:peer_to_sync/src/constants/app_sizes.dart';
import 'package:peer_to_sync/src/features/room/presentation/room_list/room_card.dart';
import 'package:peer_to_sync/src/localization/string_hardcoded.dart';
import 'package:peer_to_sync/src/theme/theme.dart';

class RoomListScreen extends StatefulWidget {
  const RoomListScreen({super.key});

  @override
  State<RoomListScreen> createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen> {
  // String _searchQuery = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                    prefixIcon: Icon(Icons.search),
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
                child: RoomCard(onClick: () {}),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
