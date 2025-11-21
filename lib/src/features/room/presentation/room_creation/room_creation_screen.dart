import 'package:flutter/material.dart';
import 'package:peer_to_sync/src/common_widgets/filter_dropdown.dart';
import 'package:peer_to_sync/src/common_widgets/styled_text.dart';
import 'package:peer_to_sync/src/constants/app_sizes.dart';
import 'package:peer_to_sync/src/features/room/domain/room_type.dart';
import 'package:peer_to_sync/src/localization/string_hardcoded.dart';
import 'package:peer_to_sync/src/theme/theme.dart';

class RoomCreationScreen extends StatefulWidget {
  const RoomCreationScreen({super.key});

  @override
  State<RoomCreationScreen> createState() => _RoomCreationScreenState();
}

class _RoomCreationScreenState extends State<RoomCreationScreen> {
  RoomType? selectedType;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(Sizes.p12),
              child: StyledText(
                'Création de Room'.hardcoded,
                40.0,
                bold: true,
                upper: true,
              ),
            ),
            gapH16,
            Padding(
              padding: const EdgeInsets.all(Sizes.p12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    // maxLength: 20,
                    style: TextStyle(color: AppColors.whiteColor),
                    decoration: InputDecoration(
                      fillColor: AppColors.secondColor,
                      labelText: 'Nom de la room'.hardcoded,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Sizes.p12),
                      ),
                    ),
                  ),
                  gapH16,
                  TextFormField(
                    // maxLength: 20,
                    style: TextStyle(color: AppColors.whiteColor),
                    decoration: InputDecoration(
                      fillColor: AppColors.secondColor,
                      labelText: 'Nombre de participants'.hardcoded,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Sizes.p12),
                      ),
                    ),
                  ),
                  gapH16,
                  FilterDropdown(
                    title: 'Type'.hardcoded,
                    selected: selectedType?.name,
                    isSelected: (String? newValue) {
                      setState(() {
                        for (RoomType type in RoomType.values) {
                          if (type.name == newValue) selectedType = type;
                        }
                      });
                    },
                    list: RoomType.values.map((e) => e.name).toList(),
                  ),
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
              child: StyledText('Annuler'.hardcoded, 40.0, bold: true),
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
              child: StyledText('Créer'.hardcoded, 40.0, bold: true),
            ),
          ),
        ],
      ),
    );
  }
}
