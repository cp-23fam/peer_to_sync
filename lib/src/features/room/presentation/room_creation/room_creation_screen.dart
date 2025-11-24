import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:peer_to_sync/src/common_widgets/choose_button.dart';
import 'package:peer_to_sync/src/common_widgets/filter_dropdown.dart';
import 'package:peer_to_sync/src/common_widgets/styled_text.dart';
import 'package:peer_to_sync/src/constants/app_sizes.dart';
import 'package:peer_to_sync/src/features/room/data/room_repository.dart';
import 'package:peer_to_sync/src/features/room/domain/room_type.dart';
import 'package:peer_to_sync/src/features/user/data/user_repository.dart';
import 'package:peer_to_sync/src/localization/string_hardcoded.dart';
import 'package:peer_to_sync/src/routing/app_router.dart';
import 'package:peer_to_sync/src/theme/theme.dart';

class RoomCreationScreen extends StatefulWidget {
  const RoomCreationScreen({super.key});

  @override
  State<RoomCreationScreen> createState() => _RoomCreationScreenState();
}

class _RoomCreationScreenState extends State<RoomCreationScreen> {
  RoomType? selectedType;

  final _formKey = GlobalKey<FormState>();

  late final TextEditingController nameTextController;
  late final TextEditingController numberTextController;

  @override
  void initState() {
    nameTextController = TextEditingController();
    numberTextController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    nameTextController.dispose();
    numberTextController.dispose();

    super.dispose();
  }

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
                children: [
                  StyledText(
                    'Création de Room'.hardcoded,
                    30.0,
                    bold: true,
                    upper: true,
                  ),
                ],
              ),
            ),
            gapH16,
            Padding(
              padding: const EdgeInsets.all(Sizes.p12),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: nameTextController,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          return null;
                        }

                        return 'Veuillez entrer un nom de salle'.hardcoded;
                      },
                      // maxLength: 20,
                      style: TextStyle(color: AppColors.whiteColor),
                      decoration: InputDecoration(
                        fillColor: AppColors.secondColor,
                        labelText: 'Nom de la room'.hardcoded,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Sizes.p4),
                        ),
                      ),
                    ),
                    gapH16,
                    TextFormField(
                      controller: numberTextController,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          if (int.tryParse(value) != null) {
                            final max = int.parse(value);

                            if (max > 0 && max <= 100) {
                              return null;
                            }

                            return 'Veuillez entrer un nombre entre 1 et 100'
                                .hardcoded;
                          }
                          return 'Veuillez entrer un nombre valide'.hardcoded;
                        }
                        return 'Veuillez remplir ce champ'.hardcoded;
                      },
                      style: TextStyle(color: AppColors.whiteColor),
                      decoration: InputDecoration(
                        fillColor: AppColors.secondColor,
                        labelText: 'Nombre de participants'.hardcoded,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Sizes.p4),
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
            ),
          ],
        ),
      ),
      bottomNavigationBar: ClipRRect(
        child: Container(
          height: 64,
          color: AppColors.navBackgroundColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChooseButton(
                text: 'Annuler',
                color: AppColors.redColor,
                onPressed: () {
                  context.goNamed(RouteNames.home.name);
                },
              ),
              gapW16,
              Consumer(
                builder: (context, ref, child) {
                  return ChooseButton(
                    text: 'Créer',
                    color: AppColors.greenColor,
                    onPressed: () async {
                      if (_formKey.currentState!.validate() &&
                          selectedType != null) {
                        final currentUser = await ref
                            .read(userRepositoryProvider)
                            .fetchCurrentUser();

                        if (currentUser == null && context.mounted) {
                          context.goNamed(RouteNames.user.name);
                          return;
                        }

                        final room = await ref
                            .read(roomRepositoryProvider)
                            .createRoom(
                              nameTextController.text,
                              currentUser!.uid,
                              int.parse(numberTextController.text),
                              selectedType!,
                            );

                        if (context.mounted) {
                          context.goNamed(
                            RouteNames.detail.name,
                            pathParameters: {'id': room.id},
                          );
                        }
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
