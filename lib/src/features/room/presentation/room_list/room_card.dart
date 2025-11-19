import 'dart:math';

import 'package:flutter/material.dart';
import 'package:peer_to_sync/src/common_widgets/styled_text.dart';
import 'package:peer_to_sync/src/constants/app_sizes.dart';
import 'package:peer_to_sync/src/theme/theme.dart';

class RoomCard extends StatefulWidget {
  const RoomCard({
    // required this.room,
    required this.onClick,
    super.key,
  });

  // final Room room;
  final VoidCallback? onClick;

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
      duration: Duration(milliseconds: 150),
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
        mainAxisAlignment: MainAxisAlignment.start,
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
                      StyledText('RoomName', 32.0, bold: true),
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
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StyledText('RoomType', 24.0),
                          gapH8,
                          StyledText('HostName', 20.0),
                          gapH8,

                          Row(
                            children: [
                              SizedBox(
                                height: 30,
                                width: 200,
                                child: ListView.builder(
                                  itemBuilder: (context, index) {
                                    if (index < 3) {
                                      return CircleAvatar(
                                        radius: Sizes.p16,
                                        backgroundColor:
                                            AppColors.backgroundIconColor,
                                        child: Icon(
                                          Icons.person_outline,
                                          size: Sizes.p24,
                                          color: AppColors.whiteColor,
                                        ),
                                      );
                                    } else if (index == 2 - 1) {
                                      return CircleAvatar(
                                        radius: Sizes.p16,
                                        backgroundColor:
                                            AppColors.backgroundIconAccent,
                                        child: StyledText(
                                          '${2 - 3}+',
                                          Sizes.p16,
                                        ),
                                      );
                                    } else {
                                      return SizedBox.shrink();
                                    }
                                  },
                                  itemCount: 2,
                                  scrollDirection: Axis.horizontal,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
