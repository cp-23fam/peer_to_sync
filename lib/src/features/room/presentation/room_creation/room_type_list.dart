import 'package:flutter/material.dart';
import 'package:messages/messages.dart';
import 'package:peer_to_sync/src/common_widgets/styled_text.dart';
import 'package:peer_to_sync/src/constants/app_sizes.dart';
import 'package:peer_to_sync/src/localization/string_hardcoded.dart';
import 'package:peer_to_sync/src/theme/theme.dart';

class RoomTypeList extends StatefulWidget {
  const RoomTypeList(this.atSelection, {super.key});

  final Function(Object? newValue) atSelection;

  @override
  State<RoomTypeList> createState() => _RoomTypeListState();
}

class _RoomTypeListState extends State<RoomTypeList> {
  late List<RoomType> availableTypes;
  late RoomType selectedType;
  @override
  void initState() {
    availableTypes = RoomType.values.map((e) => e).toList();
    selectedType = availableTypes.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(Sizes.p8),
      child: Container(
        height: 180,
        width: double.infinity,
        padding: const EdgeInsets.all(Sizes.p16),
        color: colors.surface.withValues(alpha: 0.5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StyledText('Type d\'activitée :'.hardcoded, 16.0),
            gapH8,
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: availableTypes.map((type) {
                  return Container(
                    height: 80,
                    width: 80,
                    margin: const EdgeInsets.all(Sizes.p4),
                    padding: const EdgeInsets.all(Sizes.p4),
                    color: type == selectedType
                        ? colors.gold
                        : Colors.transparent,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.atSelection(type);
                          selectedType = type;
                        });
                      },
                      child: Container(
                        color: colors.primary,
                        child: Icon(type.icon, size: 50.0),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            gapH8,
            StyledText(selectedType.name, 12.0, upper: true),
          ],
        ),
      ),
    );
  }
}
