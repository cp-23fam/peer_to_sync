import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:peer_to_sync/src/common_widgets/styled_text.dart';
import 'package:peer_to_sync/src/constants/app_sizes.dart';
import 'package:peer_to_sync/src/features/room/data/room_repository.dart';
import 'package:peer_to_sync/src/features/room/domain/room.dart';
import 'package:peer_to_sync/src/routing/app_router.dart';
import 'package:peer_to_sync/src/theme/theme.dart';

class RoomCard extends StatefulWidget {
  const RoomCard({required this.room, super.key});

  final Room room;

  @override
  State<RoomCard> createState() => _RoomCardState();
}

class _RoomCardState extends State<RoomCard> with TickerProviderStateMixin {
  bool _showData = false;
  late Animation _arrowAnimation;
  late AnimationController _arrowAnimationController;

  @override
  void initState() {
    super.initState();
    _arrowAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _arrowAnimation = Tween(
      begin: 0.0,
      end: pi / 2,
    ).animate(_arrowAnimationController);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(Sizes.p20)),
        color: AppColors.thirdColor,
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(Sizes.p20)),
              color: AppColors.secondColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(Sizes.p16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: Sizes.p24,
                        backgroundColor: AppColors.backgroundIconColor,
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
                  IconButton(
                    onPressed: () {
                      setState(() => _showData = !_showData);
                      _arrowAnimationController.toggle();
                    },
                    icon: AnimatedBuilder(
                      animation: _arrowAnimationController,
                      builder: (context, child) => Transform.rotate(
                        angle: _arrowAnimation.value,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _showData
              ? Padding(
                  padding: const EdgeInsets.all(Sizes.p12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StyledText(widget.room.type.name, 24.0),
                          gapH8,
                          // StyledText(widget.room.hostId, 20.0),
                          StyledText('UserName', 20.0),
                          gapH8,

                          Row(
                            children: [
                              SizedBox(
                                height: 30,
                                width: 200,
                                child: ListView.builder(
                                  itemBuilder: (context, index) {
                                    if (index < 3) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          right: Sizes.p4,
                                        ),
                                        child: CircleAvatar(
                                          radius: Sizes.p16,
                                          backgroundColor:
                                              AppColors.backgroundIconColor,
                                          child: Icon(
                                            Icons.person_outline,
                                            size: Sizes.p24,
                                            color: AppColors.whiteColor,
                                          ),
                                        ),
                                      );
                                    } else if (index ==
                                        widget.room.users.length - 1) {
                                      return CircleAvatar(
                                        radius: Sizes.p16,
                                        backgroundColor:
                                            AppColors.backgroundIconAccent,
                                        child: StyledText(
                                          '${widget.room.users.length - 3}+',
                                          Sizes.p16,
                                        ),
                                      );
                                    } else {
                                      return const SizedBox.shrink();
                                    }
                                  },
                                  itemCount: 7,
                                  scrollDirection: Axis.horizontal,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(Sizes.p24),
                              ),
                              color: AppColors.greenColor.withAlpha(150),
                            ),
                            child: Center(
                              child: StyledText(
                                widget.room.status.name,
                                16.0,
                                bold: true,
                                upper: true,
                              ),
                            ),
                          ),
                          gapH24,
                          Consumer(
                            builder: (context, ref, child) {
                              return ElevatedButton(
                                onPressed: () async {
                                  await ref
                                      .read(roomRepositoryProvider)
                                      .joinRoom(widget.room.id);

                                  if (context.mounted) {
                                    context.goNamed(
                                      RouteNames.detail.name,
                                      pathParameters: {'id': widget.room.id},
                                    );
                                  }
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                        AppColors.greenColor,
                                      ),
                                  shape:
                                      WidgetStateProperty.all<
                                        RoundedRectangleBorder
                                      >(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            Sizes.p24,
                                          ),
                                        ),
                                      ),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(Sizes.p8),
                                  child: StyledText(
                                    'Rejoindre',
                                    24.0,
                                    bold: true,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
