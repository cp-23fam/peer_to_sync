import 'package:flutter/material.dart';
import 'package:peer_to_sync/src/common_widgets/styled_text.dart';
import 'package:peer_to_sync/src/constants/app_sizes.dart';
import 'package:peer_to_sync/src/features/room/domain/room_visibility.dart';
import 'package:peer_to_sync/src/localization/string_hardcoded.dart';
import 'package:peer_to_sync/src/theme/theme.dart';

class RoomVisibilityList extends StatefulWidget {
  const RoomVisibilityList(this.atSelection, {super.key});

  final Function(Object? newValue) atSelection;

  @override
  State<RoomVisibilityList> createState() => _RoomVisibilityListState();
}

class _RoomVisibilityListState extends State<RoomVisibilityList> {
  late List<RoomVisibility> availableVisibilitys;
  late RoomVisibility selectedVisibility;
  @override
  void initState() {
    availableVisibilitys = RoomVisibility.values.map((e) => e).toList();
    selectedVisibility = availableVisibilitys.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(Sizes.p8),
      child: Container(
        height: 180,
        padding: const EdgeInsets.all(Sizes.p16),
        color: colors.surface.withValues(alpha: 0.5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StyledText('Visibilitée de la room :'.hardcoded, 16.0),
            gapH8,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: availableVisibilitys.map((visibility) {
                return Container(
                  height: 80,
                  width: 80,
                  margin: const EdgeInsets.all(Sizes.p4),
                  padding: const EdgeInsets.all(Sizes.p4),
                  color: visibility == selectedVisibility
                      ? colors.gold
                      : Colors.transparent,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.atSelection(visibility);
                        selectedVisibility = visibility;
                      });
                    },
                    child: Container(
                      color: colors.primary,
                      child: visibility == RoomVisibility.public
                          ? const Icon(Icons.public, size: 50.0)
                          : visibility == RoomVisibility.private
                          ? const Icon(Icons.lock, size: 50.0)
                          : const Icon(Icons.groups_2_outlined, size: 50.0),
                    ),
                  ),
                );
              }).toList(),
            ),
            gapH8,
            StyledText(selectedVisibility.name, 12.0, upper: true),
          ],
        ),
      ),
    );
  }
}
