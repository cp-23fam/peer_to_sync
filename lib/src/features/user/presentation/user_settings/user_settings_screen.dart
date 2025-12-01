// import 'package:adaptive_theme/adaptive_theme.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:peer_to_sync/src/common_widgets/choose_button.dart';
// import 'package:peer_to_sync/src/common_widgets/styled_text.dart';
// import 'package:peer_to_sync/src/constants/app_sizes.dart';
// import 'package:peer_to_sync/src/features/user/data/user_repository.dart';
// import 'package:peer_to_sync/src/features/user/presentation/user_settings/profile_picture.dart';
// import 'package:peer_to_sync/src/localization/string_hardcoded.dart';
// import 'package:peer_to_sync/src/routing/app_router.dart';
// import 'package:peer_to_sync/src/theme/theme.dart';
// import 'package:toggle_switch/toggle_switch.dart';

// class UserSettingsScreen extends StatefulWidget {
//   const UserSettingsScreen({super.key});

//   @override
//   State<UserSettingsScreen> createState() => _UserSettingsScreenState();
// }

// class _UserSettingsScreenState extends State<UserSettingsScreen> {
//   int initialLabelIndex = 2;
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Consumer(
//           builder: (context, ref, child) {
//             final userData = ref.watch(userInfosProvider);

//             return userData.when(
//               data: (user) {
//                 return Column(
//                   children: [
//                     Container(
//                       height: 80,
//                       padding: const EdgeInsets.all(Sizes.p12),
//                       color: AppColors.navBackgroundColor,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           StyledText(
//                             'Paramètres utilisateur'.hardcoded,
//                             30.0,
//                             bold: true,
//                             upper: true,
//                           ),
//                         ],
//                       ),
//                     ),
//                     gapH24,
//                     const ProfilePicture(),
//                     Padding(
//                       padding: const EdgeInsets.all(Sizes.p8),
//                       child: StyledText(user!.username, 32.0, bold: true),
//                     ),
//                     gapH16,
//                     Padding(
//                       padding: const EdgeInsets.all(Sizes.p12),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           GestureDetector(
//                             onTap: () {},
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 borderRadius: const BorderRadius.all(
//                                   Radius.circular(Sizes.p4),
//                                 ),
//                                 color: AppColors.secondColor,
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: AppColors.navBackgroundColor,
//                                     spreadRadius: 2,
//                                     blurRadius: 2,
//                                     offset: const Offset(3, 3),
//                                   ),
//                                 ],
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(Sizes.p4),
//                                 child: Row(
//                                   children: [
//                                     gapW4,
//                                     Padding(
//                                       padding: const EdgeInsets.all(Sizes.p12),
//                                       child: Icon(
//                                         Icons.groups_2_outlined,
//                                         color: AppColors.whiteColor,
//                                         size: 45.0,
//                                       ),
//                                     ),
//                                     gapW16,
//                                     StyledText(
//                                       'Amis'.hardcoded,
//                                       Sizes.p24,
//                                       bold: true,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                           gapH16,
//                           GestureDetector(
//                             onTap: () {
//                               context.goNamed(RouteNames.edit.name);
//                             },
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 borderRadius: const BorderRadius.all(
//                                   Radius.circular(Sizes.p4),
//                                 ),
//                                 color: AppColors.secondColor,
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: AppColors.navBackgroundColor,
//                                     spreadRadius: 2,
//                                     blurRadius: 2,
//                                     offset: const Offset(3, 3),
//                                   ),
//                                 ],
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(Sizes.p4),
//                                 child: Row(
//                                   children: [
//                                     gapW4,
//                                     Padding(
//                                       padding: const EdgeInsets.all(Sizes.p12),
//                                       child: Icon(
//                                         Icons.person_outline,
//                                         color: AppColors.whiteColor,
//                                         size: 50.0,
//                                       ),
//                                     ),
//                                     gapW16,
//                                     StyledText(
//                                       'Modifier le profil'.hardcoded,
//                                       Sizes.p24,
//                                       bold: true,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                           gapH16,
//                           Center(
//                             child: ToggleSwitch(
//                               minWidth: double.infinity,
//                               minHeight: 50.0,
//                               initialLabelIndex: initialLabelIndex,
//                               cornerRadius: 20.0,
//                               activeFgColor: Colors.white,
//                               inactiveBgColor: AppColors.secondColor,
//                               totalSwitches: 3,
//                               icons: [
//                                 Icons.light_mode,
//                                 Icons.dark_mode,
//                                 Icons.settings,
//                               ],
//                               iconSize: 30.0,
//                               activeBgColors: [
//                                 // [Colors.white.withAlpha(100)],
//                                 [Colors.yellow.withAlpha(200)],
//                                 [Colors.black],
//                                 [Colors.blueGrey],
//                               ],
//                               onToggle: (index) {
//                                 setState(() {
//                                   initialLabelIndex = index!;
//                                   index == 0
//                                       ? AdaptiveTheme.of(context).setLight()
//                                       : index == 1
//                                       ? AdaptiveTheme.of(context).setDark()
//                                       : AdaptiveTheme.of(context).setSystem();
//                                 });
//                               },
//                             ),
//                           ),
//                           // StyledText(
//                           //   'You are using ${AdaptiveTheme.of(context).mode}',
//                           //   20.0,
//                           // ),
//                           gapH16,
//                           Center(
//                             child: Container(
//                               margin: const EdgeInsets.only(top: 10),
//                               height: 48,
//                               width: 250,
//                               child: FloatingActionButton(
//                                 backgroundColor: AppColors.fourthColor,
//                                 elevation: 0,
//                                 onPressed: () async {
//                                   await ref
//                                       .read(userRepositoryProvider)
//                                       .logOut();

//                                   WidgetsBinding.instance.addPostFrameCallback((
//                                     _,
//                                   ) {
//                                     context.goNamed(RouteNames.home.name);
//                                   });
//                                 },
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(4),
//                                 ),
//                                 child: StyledText(
//                                   'Déconnexion'.hardcoded,
//                                   20.0,
//                                   bold: true,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 );
//               },
//               error: (error, stackTrace) =>
//                   Center(child: Text(error.toString())),
//               loading: () => const Center(child: CircularProgressIndicator()),
//             );
//           },
//         ),
//       ),
//       bottomNavigationBar: ClipRRect(
//         child: Container(
//           height: 64,
//           color: AppColors.navBackgroundColor,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ChooseButton(
//                 text: 'Annuler',
//                 color: AppColors.redColor,
//                 onPressed: () {
//                   context.goNamed(RouteNames.home.name);
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:adaptive_theme/adaptive_theme.dart';
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
import 'package:toggle_switch/toggle_switch.dart';

class UserSettingsScreen extends StatefulWidget {
  const UserSettingsScreen({super.key});

  @override
  State<UserSettingsScreen> createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  int initialLabelIndex = 2;

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
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(Sizes.p4),
                                ),
                                color: colors.secondary,
                                boxShadow: [
                                  BoxShadow(
                                    color: colors.surface,
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                    offset: const Offset(3, 3),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(Sizes.p4),
                                child: Row(
                                  children: [
                                    gapW4,
                                    Padding(
                                      padding: const EdgeInsets.all(Sizes.p12),
                                      child: Icon(
                                        Icons.groups_2_outlined,
                                        color: colors.onSurface,
                                        size: 45.0,
                                      ),
                                    ),
                                    gapW16,
                                    StyledText(
                                      'Amis'.hardcoded,
                                      Sizes.p24,
                                      bold: true,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          gapH16,
                          GestureDetector(
                            onTap: () {
                              context.goNamed(RouteNames.edit.name);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(Sizes.p4),
                                ),
                                color: colors.secondary,
                                boxShadow: [
                                  BoxShadow(
                                    color: colors.surface,
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                    offset: const Offset(3, 3),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(Sizes.p4),
                                child: Row(
                                  children: [
                                    gapW4,
                                    Padding(
                                      padding: const EdgeInsets.all(Sizes.p12),
                                      child: Icon(
                                        Icons.person_outline,
                                        color: colors.onSurface,
                                        size: 50.0,
                                      ),
                                    ),
                                    gapW16,
                                    StyledText(
                                      'Modifier le profil'.hardcoded,
                                      Sizes.p24,
                                      bold: true,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          gapH16,
                          Center(
                            child: ToggleSwitch(
                              minWidth: double.infinity,
                              minHeight: 50.0,
                              initialLabelIndex: initialLabelIndex,
                              cornerRadius: 20.0,
                              activeFgColor: Colors.white,
                              inactiveBgColor: colors.secondary,
                              totalSwitches: 3,
                              icons: [
                                Icons.light_mode,
                                Icons.dark_mode,
                                Icons.settings,
                              ],
                              iconSize: 30.0,
                              activeBgColors: [
                                [Colors.yellow.withAlpha(200)],
                                [Colors.black],
                                [Colors.blueGrey],
                              ],
                              onToggle: (index) {
                                setState(() {
                                  initialLabelIndex = index!;
                                  if (index == 0) {
                                    AdaptiveTheme.of(context).setLight();
                                  } else if (index == 1) {
                                    AdaptiveTheme.of(context).setDark();
                                  } else {
                                    AdaptiveTheme.of(context).setSystem();
                                  }
                                });
                              },
                            ),
                          ),
                          gapH16,
                          Center(
                            child: Container(
                              margin: const EdgeInsets.only(top: 10),
                              height: 48,
                              width: 250,
                              child: FloatingActionButton(
                                backgroundColor: colors.primary,
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
                                  'Déconnexion'.hardcoded,
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
            ],
          ),
        ),
      ),
    );
  }
}
