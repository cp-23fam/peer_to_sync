import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:messages/messages.dart';
import 'package:peer_to_sync/src/common_widgets/choose_button.dart';
import 'package:peer_to_sync/src/common_widgets/styled_text.dart';
import 'package:peer_to_sync/src/constants/app_sizes.dart';
import 'package:peer_to_sync/src/features/room/data/room_repository.dart';
import 'package:peer_to_sync/src/features/room/domain/room_visibility.dart';
import 'package:peer_to_sync/src/features/room/presentation/room_creation/room_type_list.dart';
import 'package:peer_to_sync/src/features/room/presentation/room_creation/room_visibility_list.dart';
import 'package:peer_to_sync/src/features/user/data/user_repository.dart';
import 'package:peer_to_sync/src/localization/string_hardcoded.dart';
import 'package:peer_to_sync/src/routing/app_router.dart';
import 'package:peer_to_sync/src/theme/theme.dart';
import 'package:peer_to_sync/src/utils/logged_out_dialog.dart';

class RoomCreationScreen extends StatefulWidget {
  const RoomCreationScreen({super.key});

  @override
  State<RoomCreationScreen> createState() => _RoomCreationScreenState();
}

class _RoomCreationScreenState extends State<RoomCreationScreen> {
  RoomType? selectedType = RoomType.values.map((e) => e).toList().first;
  RoomVisibility? selectedVisibility = RoomVisibility.values
      .map((e) => e)
      .toList()
      .first;

  final _formKey = GlobalKey<FormState>();

  late final TextEditingController nameTextController;
  late final TextEditingController numberTextController;
  late final TextEditingController passwordTextController;

  @override
  void initState() {
    nameTextController = TextEditingController();
    numberTextController = TextEditingController();
    passwordTextController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    nameTextController.dispose();
    numberTextController.dispose();
    passwordTextController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 80,
              padding: const EdgeInsets.all(Sizes.p12),
              color: colors.surface,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StyledText(
                    'Création de salle'.hardcoded,
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
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                      style: TextStyle(color: colors.onSurface),
                      decoration: InputDecoration(
                        fillColor: colors.secondary,
                        labelText: 'Nom de la salle'.hardcoded,
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
                      style: TextStyle(color: colors.onSurface),
                      decoration: InputDecoration(
                        fillColor: colors.secondary,
                        labelText: 'Nombre de participants'.hardcoded,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Sizes.p4),
                        ),
                      ),
                    ),
                    gapH16,
                    RoomTypeList((newValue) {
                      for (RoomType type in RoomType.values) {
                        if (type == newValue) selectedType = type;
                      }
                    }),
                    RoomVisibilityList((newValue) {
                      for (RoomVisibility visibility in RoomVisibility.values) {
                        if (visibility == newValue) {
                          setState(() {
                            selectedVisibility = visibility;
                          });
                        }
                      }
                    }),
                    gapH16,
                    selectedVisibility == RoomVisibility.private
                        ? TextFormField(
                            controller: passwordTextController,
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                return null;
                              }

                              return 'Veuillez entrer un mot de passe'
                                  .hardcoded;
                            },
                            style: TextStyle(color: colors.onSurface),
                            decoration: InputDecoration(
                              fillColor: colors.secondary,
                              labelText: 'Mot de passe de la room'.hardcoded,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(Sizes.p4),
                              ),
                            ),
                          )
                        : const SizedBox(),
                    // FilterDropdown(
                    //   title: 'Type'.hardcoded,
                    //   selected: selectedType?.name,
                    //   isSelected: (String? newValue) {
                    //     setState(() {
                    //       for (RoomType type in RoomType.values) {
                    //         if (type.name == newValue) selectedType = type;
                    //       }
                    //     });
                    //   },
                    //   list: RoomType.values.map((e) => e.name).toList(),
                    // ),
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
          color: colors.surface,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChooseButton(
                text: 'Annuler',
                color: colors.error,
                onPressed: () {
                  context.goNamed(RouteNames.home.name);
                },
              ),
              gapW16,
              Consumer(
                builder: (context, ref, child) {
                  return ChooseButton(
                    text: 'Créer',
                    color: colors.green,
                    onPressed: () async {
                      if (_formKey.currentState!.validate() &&
                          selectedType != null) {
                        final currentUser = await ref
                            .read(userRepositoryProvider)
                            .fetchCurrentUser();

                        if (currentUser == null) {
                          WidgetsBinding.instance.addPostFrameCallback(
                            (_) => loggedOutDialog(context),
                          );
                          return;
                        }

                        final room = await ref
                            .read(roomRepositoryProvider)
                            .createRoom(
                              nameTextController.text,
                              currentUser.uid,
                              int.parse(numberTextController.text),
                              selectedType!,
                              selectedVisibility!,
                              password: passwordTextController.text,
                            );

                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          context.goNamed(
                            RouteNames.detail.name,
                            pathParameters: {'id': room.id},
                          );
                        });
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
