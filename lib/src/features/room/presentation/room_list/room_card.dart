// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:peer_to_sync/src/common_widgets/styled_text.dart';
// import 'package:peer_to_sync/src/constants/app_sizes.dart';
// import 'package:peer_to_sync/src/features/room/data/room_repository.dart';
// import 'package:peer_to_sync/src/features/room/domain/room.dart';
// import 'package:peer_to_sync/src/features/room/domain/room_status.dart';
// import 'package:peer_to_sync/src/features/user/data/user_repository.dart';
// import 'package:peer_to_sync/src/features/user/domain/logged_out_exception.dart';
// import 'package:peer_to_sync/src/localization/string_hardcoded.dart';
// import 'package:peer_to_sync/src/routing/app_router.dart';
// import 'package:peer_to_sync/src/theme/theme.dart';
// import 'package:peer_to_sync/src/utils/logged_out_dialog.dart';

// class RoomCard extends StatefulWidget {
//   const RoomCard({required this.room, super.key});

//   final Room room;

//   @override
//   State<RoomCard> createState() => _RoomCardState();
// }

// class _RoomCardState extends State<RoomCard> {
//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: const BorderRadius.all(Radius.circular(Sizes.p4)),
//         color: colors.surface,
//         boxShadow: [
//           BoxShadow(
//             color: colors.surface,
//             spreadRadius: 2,
//             blurRadius: 2,
//             offset: const Offset(3, 2),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(Sizes.p16),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(4.0),
//                       decoration: BoxDecoration(
//                         color: colors.iconBackground,
//                         borderRadius: const BorderRadius.all(
//                           Radius.circular(5),
//                         ),
//                       ),
//                       child: Icon(
//                         Icons.person_outline,
//                         size: 38.0,
//                         color: colors.onSurface,
//                       ),
//                     ),
//                     gapW12,
//                     StyledText(widget.room.name, 32.0, bold: true),
//                   ],
//                 ),
//               ],
//             ),
//             gapH8,
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Consumer(
//                       builder: (context, ref, child) {
//                         final userData = ref.watch(
//                           userProvider(widget.room.hostId),
//                         );

//                         return userData.when(
//                           data: (user) => user != null
//                               ? StyledText(user.username, 20.0)
//                               : StyledText('Inconnu'.hardcoded, 20.0),
//                           error: (error, stackTrace) =>
//                               StyledText(error.toString(), 20.0),
//                           loading: () => const StyledText('...', 20.0),
//                         );
//                       },
//                     ),
//                     gapH4,
//                     StyledText(widget.room.type.name, 20.0),
//                     gapH8,
//                     Container(
//                       padding: const EdgeInsets.all(4.0),
//                       decoration: BoxDecoration(
//                         color: colors.iconAccent,
//                         borderRadius: const BorderRadius.all(
//                           Radius.circular(5),
//                         ),
//                       ),
//                       child: Row(
//                         children: [
//                           gapW4,
//                           Icon(
//                             Icons.group,
//                             size: Sizes.p32,
//                             color: colors.onSurface,
//                           ),
//                           gapW8,
//                           StyledText(
//                             '${widget.room.users.length} / ${widget.room.maxPlayers}',
//                             20.0,
//                           ),
//                           gapW8,
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     gapH32,
//                     Container(
//                       width: 140,
//                       height: 30,
//                       decoration: BoxDecoration(
//                         borderRadius: const BorderRadius.all(
//                           Radius.circular(Sizes.p4),
//                         ),
//                         color: widget.room.status == RoomStatus.playing
//                             ? colors.error.withAlpha(150)
//                             : widget.room.status == RoomStatus.waiting
//                             ? colors.orange.withAlpha(150)
//                             : colors.green.withAlpha(150),
//                       ),
//                       child: Center(
//                         child: StyledText(
//                           widget.room.status.name,
//                           16.0,
//                           bold: true,
//                         ),
//                       ),
//                     ),
//                     gapH12,
//                     Consumer(
//                       builder: (context, ref, child) {
//                         return ElevatedButton(
//                           onPressed:
//                               widget.room.users.length == widget.room.maxPlayers
//                               ? null
//                               : () async {
//                                   try {
//                                     await ref
//                                         .read(roomRepositoryProvider)
//                                         .joinRoom(widget.room.id)
//                                         .then((value) {
//                                           WidgetsBinding.instance
//                                               .addPostFrameCallback((_) {
//                                                 context.goNamed(
//                                                   RouteNames.detail.name,
//                                                   pathParameters: {
//                                                     'id': widget.room.id,
//                                                   },
//                                                 );
//                                               });
//                                         });
//                                   } on LoggedOutException {
//                                     WidgetsBinding.instance
//                                         .addPostFrameCallback(
//                                           (_) => loggedOutDialog(context),
//                                         );
//                                     return;
//                                   }
//                                 },
//                           style: ButtonStyle(
//                             backgroundColor: WidgetStateProperty.all<Color>(
//                               widget.room.users.length == widget.room.maxPlayers
//                                   ? colors.primary
//                                   : colors.green,
//                             ),
//                             shape:
//                                 WidgetStateProperty.all<RoundedRectangleBorder>(
//                                   RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(
//                                       Sizes.p4,
//                                     ),
//                                   ),
//                                 ),
//                           ),
//                           child: const Padding(
//                             padding: EdgeInsets.all(Sizes.p8),
//                             child: StyledText('Rejoindre', 18.0, bold: true),
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:peer_to_sync/src/common_widgets/small_user_image.dart';
import 'package:peer_to_sync/src/common_widgets/styled_text.dart';
import 'package:peer_to_sync/src/constants/app_sizes.dart';
import 'package:peer_to_sync/src/features/room/data/room_repository.dart';
import 'package:peer_to_sync/src/features/room/domain/room.dart';
import 'package:peer_to_sync/src/features/room/domain/room_status.dart';
import 'package:peer_to_sync/src/features/room/domain/room_type.dart';
import 'package:peer_to_sync/src/features/room/domain/room_visibility.dart';
import 'package:peer_to_sync/src/features/user/data/user_repository.dart';
import 'package:peer_to_sync/src/features/user/domain/logged_out_exception.dart';
import 'package:peer_to_sync/src/localization/string_hardcoded.dart';
import 'package:peer_to_sync/src/routing/app_router.dart';
import 'package:peer_to_sync/src/theme/theme.dart';
import 'package:peer_to_sync/src/utils/logged_out_dialog.dart';

class RoomCard extends StatefulWidget {
  const RoomCard({required this.room, super.key});

  final Room room;

  @override
  State<RoomCard> createState() => _RoomCardState();
}

class _RoomCardState extends State<RoomCard> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(Sizes.p4)),
        color: colors.surface,
        boxShadow: [
          BoxShadow(
            color: colors.surface,
            spreadRadius: 2,
            blurRadius: 2,
            offset: const Offset(3, 2),
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
                Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: colors.iconBackground,
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),
                  child: SmallUserImage(
                    colors: colors,
                    userId: widget.room.hostId,
                  ),
                ),
                gapW12,
                const Expanded(child: SizedBox()),
                Container(
                  padding: const EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                    color: colors.primary,
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Stack(
                    children: [
                      Icon(Icons.group, size: 42.0, color: colors.surface),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14.0,
                          vertical: 4.0,
                        ),
                        child: StyledText(
                          '${widget.room.users.length}',
                          20.0,
                          bold: true,
                        ),
                      ),
                    ],
                  ),
                ),
                gapW12,
                Container(
                  padding: const EdgeInsets.all(Sizes.p8),
                  decoration: BoxDecoration(
                    color: colors.background.withAlpha(150),
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Icon(
                    widget.room.type == RoomType.game
                        ? Icons.games
                        : widget.room.type == RoomType.collab
                        ? Icons.handshake
                        : Icons.question_mark,
                    size: Sizes.p32,
                    color: colors.onSurface,
                  ),
                ),
                gapW12,
                Container(
                  padding: const EdgeInsets.all(Sizes.p8),
                  decoration: BoxDecoration(
                    color: widget.room.status == RoomStatus.playing
                        ? colors.error.withAlpha(200)
                        : widget.room.status == RoomStatus.waiting
                        ? colors.orange.withAlpha(200)
                        : colors.green.withAlpha(200),
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Icon(
                    widget.room.status == RoomStatus.playing
                        ? Icons.close
                        : widget.room.status == RoomStatus.waiting
                        ? Icons.change_circle_outlined
                        : Icons.check,
                    size: Sizes.p32,
                    color: colors.onSurface,
                  ),
                ),
                gapW12,
                Container(
                  padding: const EdgeInsets.all(Sizes.p8),
                  decoration: BoxDecoration(
                    color: colors.background,
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Icon(
                    widget.room.visibility == RoomVisibility.public
                        ? Icons.public
                        : widget.room.visibility == RoomVisibility.private
                        ? Icons.lock
                        : Icons.groups_2_outlined,
                    size: Sizes.p32,
                    color: colors.onSurface,
                  ),
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
                    Consumer(
                      builder: (context, ref, child) {
                        final userData = ref.watch(
                          userProvider(widget.room.hostId),
                        );

                        return userData.when(
                          data: (user) => user != null
                              ? StyledText(user.username, 20.0)
                              : StyledText('Inconnu'.hardcoded, 20.0),
                          error: (error, stackTrace) =>
                              StyledText(error.toString(), 20.0),
                          loading: () => const StyledText('...', 20.0),
                        );
                      },
                    ),
                    gapH4,
                    StyledText(widget.room.name, 20.0),
                    // gapH8,
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    gapH20,
                    Consumer(
                      builder: (context, ref, child) {
                        return ElevatedButton(
                          onPressed:
                              widget.room.users.length == widget.room.maxPlayers
                              ? null
                              : () async {
                                  try {
                                    await ref
                                        .read(roomRepositoryProvider)
                                        .joinRoom(widget.room.id)
                                        .then((value) {
                                          WidgetsBinding.instance
                                              .addPostFrameCallback((_) {
                                                context.goNamed(
                                                  RouteNames.detail.name,
                                                  pathParameters: {
                                                    'id': widget.room.id,
                                                  },
                                                );
                                              });
                                        });
                                  } on LoggedOutException {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback(
                                          (_) => loggedOutDialog(context),
                                        );
                                    return;
                                  }
                                },
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                              widget.room.users.length == widget.room.maxPlayers
                                  ? colors.primary
                                  : colors.green,
                            ),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      Sizes.p4,
                                    ),
                                  ),
                                ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(Sizes.p8),
                            child: StyledText('Rejoindre', 18.0, bold: true),
                          ),
                        );
                      },
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
