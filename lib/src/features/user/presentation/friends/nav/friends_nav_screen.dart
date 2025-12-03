import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:peer_to_sync/src/common_widgets/choose_button.dart';
import 'package:peer_to_sync/src/common_widgets/styled_text.dart';
import 'package:peer_to_sync/src/constants/app_sizes.dart';
import 'package:peer_to_sync/src/features/user/data/user_repository.dart';
import 'package:peer_to_sync/src/features/user/presentation/friends/friends_list/friends_list_screen.dart';
import 'package:peer_to_sync/src/features/user/presentation/friends/friends_request_list/friends_request_list_screen.dart';
import 'package:peer_to_sync/src/features/user/presentation/friends/nav/nav_bar.dart';
import 'package:peer_to_sync/src/features/user/presentation/friends/user_list/users_list_screen.dart';
import 'package:peer_to_sync/src/localization/string_hardcoded.dart';
import 'package:peer_to_sync/src/routing/app_router.dart';

class FriendsNavScreen extends StatefulWidget {
  const FriendsNavScreen({super.key});

  @override
  State<FriendsNavScreen> createState() => _FriendsNavScreenState();
}

class _FriendsNavScreenState extends State<FriendsNavScreen> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 80,
            padding: const EdgeInsets.all(Sizes.p12),
            color: colors.surface,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StyledText('Amis'.hardcoded, 30.0, bold: true, upper: true),
              ],
            ),
          ),
          NavBar(
            pageIndex: selectedTab,
            onTap: (index) {
              if (index != selectedTab) {
                setState(() {
                  selectedTab = index;
                });
              }
            },
          ),
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                // ignore: unused_local_variable
                final userData = ref.watch(userInfosProvider);

                if (selectedTab == 0) {
                  return FriendsListScreen();
                } else if (selectedTab == 1) {
                  return FriendsRequestListScreen();
                } else {
                  return UsersListScreen();
                }
              },
            ),
          ),
        ],
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
            ],
          ),
        ),
      ),
    );
  }
}
