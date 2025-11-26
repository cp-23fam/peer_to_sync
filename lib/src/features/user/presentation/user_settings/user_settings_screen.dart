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

class UserSettingsScreen extends StatefulWidget {
  const UserSettingsScreen({super.key});

  @override
  State<UserSettingsScreen> createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                      color: AppColors.navBackgroundColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          StyledText(
                            'User'.hardcoded,
                            30.0,
                            bold: true,
                            upper: true,
                          ),
                        ],
                      ),
                    ),
                    gapH24,
                    const ProfilePicture(),
                    Padding(
                      padding: const EdgeInsets.all(Sizes.p8),
                      child: StyledText(user!.username, 32.0, bold: true),
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
                              labelText: 'Nom d\'utilisateur'.hardcoded,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(Sizes.p4),
                              ),
                            ),
                          ),
                          gapH16,
                          TextFormField(
                            // maxLength: 20,
                            style: TextStyle(color: AppColors.whiteColor),
                            decoration: InputDecoration(
                              fillColor: AppColors.secondColor,
                              labelText: 'Adresse mail'.hardcoded,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(Sizes.p4),
                              ),
                            ),
                          ),
                          gapH16,
                          TextFormField(
                            // maxLength: 20,
                            style: TextStyle(color: AppColors.whiteColor),
                            decoration: InputDecoration(
                              fillColor: AppColors.secondColor,
                              labelText: 'Mot de passe'.hardcoded,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(Sizes.p4),
                              ),
                            ),
                          ),
                          gapH16,
                          Center(
                            child: Container(
                              margin: const EdgeInsets.only(top: 10),
                              height: 48,
                              width: 250,
                              child: FloatingActionButton(
                                backgroundColor: AppColors.fourthColor,
                                elevation: 0,
                                onPressed: () async {
                                  await ref
                                      .read(userRepositoryProvider)
                                      .logOut();

                                  WidgetsBinding.instance.addPostFrameCallback((
                                    _,
                                  ) {
                                    context.goNamed(RouteNames.home.name);
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: StyledText(
                                  'Log out'.hardcoded,
                                  20.0,
                                  bold: true,
                                ),
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
                    text: 'Modifier',
                    color: AppColors.greenColor,
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
