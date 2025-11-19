import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peer_to_sync/src/common_widgets/styled_text.dart';
import 'package:peer_to_sync/src/constants/app_sizes.dart';
import 'package:peer_to_sync/src/features/user/data/user_repository.dart';
import 'package:peer_to_sync/src/features/user/presentation/user_settings/profile_picture.dart';
import 'package:peer_to_sync/src/localization/string_hardcoded.dart';
import 'package:peer_to_sync/src/theme/theme.dart';

class UserSettingsScreen extends StatefulWidget {
  const UserSettingsScreen({super.key});

  @override
  State<UserSettingsScreen> createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
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
                    Padding(
                      padding: const EdgeInsets.all(Sizes.p12),
                      child: StyledText(
                        'User'.hardcoded,
                        40.0,
                        bold: true,
                        upper: true,
                      ),
                    ),
                    const ProfilePicture(),
                    if (user != null)
                      Padding(
                        padding: const EdgeInsets.all(Sizes.p8),
                        child: StyledText(user.username, 32.0, bold: true),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.all(Sizes.p8),
                        child: StyledText(
                          'User not logged in'.hardcoded,
                          32.0,
                          bold: true,
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
                              labelText: 'Nom d\'utilisateur'.hardcoded,
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
                              labelText: 'Adresse mail'.hardcoded,
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
                              labelText: 'Mot de passe'.hardcoded,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(Sizes.p12),
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
    );
  }
}
