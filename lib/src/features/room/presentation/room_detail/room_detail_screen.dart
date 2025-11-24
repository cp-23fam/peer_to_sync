import 'package:flutter/material.dart';
import 'package:peer_to_sync/src/common_widgets/styled_text.dart';
import 'package:peer_to_sync/src/constants/app_sizes.dart';
import 'package:peer_to_sync/src/features/room/presentation/room_detail/no_user_card.dart';
import 'package:peer_to_sync/src/features/room/presentation/room_detail/user_card.dart';
import 'package:peer_to_sync/src/localization/string_hardcoded.dart';
import 'package:peer_to_sync/src/theme/theme.dart';

class RoomDetailScreen extends StatefulWidget {
  const RoomDetailScreen({
    // required this.roomId,
    super.key,
  });

  // final String? roomId;

  @override
  State<RoomDetailScreen> createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends State<RoomDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 80,
              padding: const EdgeInsets.all(Sizes.p12),
              color: AppColors.navBackgroundColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [StyledText('RoomName', 30.0, bold: true)],
              ),
            ),
            Text('5 / 8'.hardcoded),
            gapH12,
            Padding(
              padding: const EdgeInsets.all(Sizes.p12),
              child: Column(
                children: [
                  UserCard(isHost: true),
                  gapH16,
                  UserCard(isHost: false),
                  gapH16,
                  UserCard(isHost: false),
                  gapH16,
                  UserCard(isHost: false),
                  gapH16,
                  NoUserCard(isHost: false),
                  gapH16,
                  NoUserCard(isHost: false),
                ],
              ),
            ),
          ],
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
          Container(
            margin: const EdgeInsets.only(top: 10),
            height: 60,
            width: 180,
            child: FloatingActionButton(
              backgroundColor: AppColors.redColor,
              elevation: 0,
              onPressed: () {},
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              child: StyledText('Quitter'.hardcoded, 40.0, bold: true),
            ),
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
