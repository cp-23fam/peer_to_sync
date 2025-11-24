import 'package:flutter/material.dart';
import 'package:peer_to_sync/src/common_widgets/styled_text.dart';
import 'package:peer_to_sync/src/constants/app_sizes.dart';
import 'package:peer_to_sync/src/features/room/domain/room.dart';
import 'package:peer_to_sync/src/theme/theme.dart';

class RoomCard extends StatefulWidget {
  const RoomCard({required this.room, super.key});

  final Room room;

  @override
  State<RoomCard> createState() => _RoomCardState();
}

class _RoomCardState extends State<RoomCard> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(Sizes.p4)),
        color: AppColors.thirdColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.navBackgroundColor,
            spreadRadius: 2,
            blurRadius: 2,
            offset: Offset(3, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundIconColor,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Icon(
                        Icons.person_outline,
                        size: 38.0,
                        color: AppColors.whiteColor,
                      ),
                    ),
                    gapW12,
                    StyledText(widget.room.name, 32.0, bold: true),
                  ],
                ),
              ],
            ),
            gapH8,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // StyledText(widget.room.hostId, 20.0),
                    StyledText('UserName', 24.0),
                    gapH4,
                    StyledText(widget.room.type.name, 20.0),
                    gapH8,
                    Container(
                      padding: EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundIconAccent,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Row(
                        children: [
                          gapW4,
                          Icon(
                            Icons.group,
                            size: Sizes.p32,
                            color: AppColors.whiteColor,
                          ),
                          gapW8,
                          StyledText('2 / 4', 20.0),
                          gapW8,
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    gapH32,
                    Container(
                      width: 140,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(Sizes.p4),
                        ),
                        color: AppColors.greenColor.withAlpha(150),
                      ),
                      child: Center(
                        child: StyledText(
                          widget.room.status.name,
                          16.0,
                          bold: true,
                        ),
                      ),
                    ),
                    gapH12,
                    ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                          AppColors.greenColor,
                        ),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(Sizes.p4),
                          ),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(Sizes.p8),
                        child: StyledText('Rejoindre', 18.0, bold: true),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
