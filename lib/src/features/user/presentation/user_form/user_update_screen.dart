import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:peer_to_sync/src/common_widgets/choose_button.dart';
import 'package:peer_to_sync/src/common_widgets/styled_text.dart';
import 'package:peer_to_sync/src/constants/app_sizes.dart';
import 'package:peer_to_sync/src/features/user/data/user_repository.dart';
import 'package:peer_to_sync/src/features/user/presentation/user_settings/profile_picture.dart';
import 'package:peer_to_sync/src/localization/string_hardcoded.dart';
import 'package:peer_to_sync/src/routing/app_router.dart';
import 'package:peer_to_sync/src/theme/theme.dart';

class UserUpdateScreen extends StatefulWidget {
  const UserUpdateScreen({super.key});

  @override
  State<UserUpdateScreen> createState() => _UserUpdateScreenState();
}

class _UserUpdateScreenState extends State<UserUpdateScreen> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Consumer(
          builder: (context, ref, child) {
            final userData = ref.watch(userInfosProvider);

            return userData.when(
              data: (user) {
                return Column(
                  children: [
                    Container(
                      height: 80,
                      padding: const EdgeInsets.all(Sizes.p12),
                      color: colors.surface,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          StyledText(
                            'Paramètres utilisateur'.hardcoded,
                            30.0,
                            bold: true,
                            upper: true,
                          ),
                        ],
                      ),
                    ),
                    gapH24,
                    ProfilePicture(user!.imageUrl),
                    gapH16,
                    Padding(
                      padding: const EdgeInsets.all(Sizes.p12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            style: TextStyle(color: colors.onSurface),
                            decoration: InputDecoration(
                              fillColor: colors.secondary,
                              labelText: 'Nom d\'utilisateur'.hardcoded,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(Sizes.p4),
                              ),
                            ),
                          ),
                          gapH16,
                          TextFormField(
                            style: TextStyle(color: colors.onSurface),
                            decoration: InputDecoration(
                              fillColor: colors.secondary,
                              labelText: 'Adresse mail'.hardcoded,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(Sizes.p4),
                              ),
                            ),
                          ),
                          gapH16,
                          TextFormField(
                            style: TextStyle(color: colors.onSurface),
                            obscureText: true,
                            decoration: InputDecoration(
                              fillColor: colors.onSurface, //colors.secondary,
                              labelText: 'Mot de passe'.hardcoded,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(Sizes.p4),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
              error: (error, stackTrace) =>
                  Center(child: Text(error.toString())),
              loading: () => const Center(child: CircularProgressIndicator()),
            );
          },
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
                  context.goNamed(RouteNames.user.name);
                },
              ),
              gapW16,
              Consumer(
                builder: (context, ref, child) {
                  return ChooseButton(
                    text: 'Modifier',
                    color: colors.green,
                    onPressed: () {},
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
