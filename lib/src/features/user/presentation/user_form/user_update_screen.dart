import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:peer_to_sync/src/common_widgets/async_value_widget.dart';
import 'package:peer_to_sync/src/common_widgets/choose_button.dart';
import 'package:peer_to_sync/src/common_widgets/styled_text.dart';
import 'package:peer_to_sync/src/constants/app_sizes.dart';
import 'package:peer_to_sync/src/features/user/data/user_repository.dart';
import 'package:peer_to_sync/src/features/user/domain/password_exception.dart';
import 'package:peer_to_sync/src/localization/string_hardcoded.dart';
import 'package:peer_to_sync/src/routing/app_router.dart';
import 'package:peer_to_sync/src/theme/theme.dart';

class UserUpdateScreen extends StatefulWidget {
  const UserUpdateScreen({super.key});

  @override
  State<UserUpdateScreen> createState() => _UserUpdateScreenState();
}

class _UserUpdateScreenState extends State<UserUpdateScreen> {
  final _key = GlobalKey<FormState>();

  late TextEditingController usernameController;
  late TextEditingController newPasswordController;
  late TextEditingController confirmNewPasswordController;
  late TextEditingController passwordConfirmController;

  String? passwordError;

  @override
  void initState() {
    usernameController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmNewPasswordController = TextEditingController();
    passwordConfirmController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    passwordConfirmController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Consumer(
          builder: (context, ref, child) {
            final userData = ref.watch(userInfosProvider);

            return AsyncValueWidget(
              asyncValue: userData,
              onData: (user) {
                usernameController.value = TextEditingValue(
                  text: user!.username,
                );

                return Form(
                  key: _key,
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
                              'Paramètres utilisateur'.hardcoded,
                              30.0,
                              bold: true,
                              upper: true,
                            ),
                          ],
                        ),
                      ),
                      gapH24,
                      Padding(
                        padding: const EdgeInsets.all(Sizes.p12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: usernameController,
                              validator: (value) {
                                if (value == null || value == '') {
                                  return 'Veuillez entrer un nom d\'utilisateur'
                                      .hardcoded;
                                }

                                return null;
                              },
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
                            const Divider(),
                            gapH16,
                            TextFormField(
                              controller: newPasswordController,
                              style: TextStyle(color: colors.onSurface),
                              obscureText: true,
                              decoration: InputDecoration(
                                fillColor: colors.onSurface, //colors.secondary,
                                labelText: 'Nouveau mot de passe'.hardcoded,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(Sizes.p4),
                                ),
                              ),
                            ),
                            gapH16,
                            TextFormField(
                              validator: (value) {
                                if (newPasswordController.text != '' &&
                                    (value == null || value == '')) {
                                  return 'Veuillez confirmer votre nouveau mot de passe'
                                      .hardcoded;
                                }

                                if (value != newPasswordController.text) {
                                  return 'Les mots de passe ne correspondent pas'
                                      .hardcoded;
                                }

                                return null;
                              },
                              controller: confirmNewPasswordController,
                              style: TextStyle(color: colors.onSurface),
                              obscureText: true,
                              decoration: InputDecoration(
                                fillColor: colors.onSurface, //colors.secondary,
                                labelText:
                                    'Confirmer nouveau mot de passe'.hardcoded,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(Sizes.p4),
                                ),
                              ),
                            ),
                            gapH16,
                            const Divider(),
                            gapH16,
                            TextFormField(
                              forceErrorText: passwordError,
                              controller: passwordConfirmController,
                              validator: (value) {
                                if (value == null || value == '') {
                                  return 'Veuillez entrer votre mot de passe'
                                      .hardcoded;
                                }

                                return null;
                              },
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
                  ),
                );
              },
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
                text: 'Annuler'.hardcoded,
                color: colors.error,
                onPressed: () {
                  context.goNamed(RouteNames.user.name);
                },
              ),
              gapW16,
              Consumer(
                builder: (context, ref, child) {
                  return ChooseButton(
                    text: 'Modifier'.hardcoded,
                    color: colors.green,
                    onPressed: () async {
                      // setState(() {
                      //   passwordError = null;
                      // });

                      if (_key.currentState?.validate() ?? false) {
                        try {
                          final user = await ref
                              .read(userRepositoryProvider)
                              .fetchCurrentUser();

                          await ref
                              .read(userRepositoryProvider)
                              .logIn(
                                user!.email,
                                passwordConfirmController.text,
                              );

                          if (usernameController.text != user.username) {
                            await ref
                                .read(userRepositoryProvider)
                                .updateSelf(
                                  user.copyWith(
                                    username: usernameController.text,
                                  ),
                                  passwordConfirmController.text,
                                );
                          }

                          if (confirmNewPasswordController.text != '') {
                            await ref
                                .read(userRepositoryProvider)
                                .updateSelf(
                                  user.copyWith(
                                    username: usernameController.text,
                                  ),
                                  confirmNewPasswordController.text,
                                );
                          }

                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            context.goNamed(RouteNames.user.name);
                          });
                        } on PasswordException {
                          setState(() {
                            passwordError = 'Mot de passe invalide'.hardcoded;
                          });
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
