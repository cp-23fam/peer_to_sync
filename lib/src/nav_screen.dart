import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:peer_to_sync/src/common_widgets/nav_bar.dart';
import 'package:peer_to_sync/src/features/room/presentation/room_list/room_list_screen.dart';
import 'package:peer_to_sync/src/features/user/data/user_repository.dart';
import 'package:peer_to_sync/src/features/user/presentation/user_form/user_login_screen.dart';
import 'package:peer_to_sync/src/features/user/presentation/user_settings/user_settings_screen.dart';
import 'package:peer_to_sync/src/routing/app_router.dart';
import 'package:peer_to_sync/src/theme/theme.dart';

class NavScreen extends StatefulWidget {
  const NavScreen({super.key});

  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  int selectedTab = 0;
  // List<NavModel> items = [];

  // @override
  // void initState() {
  //   super.initState();
  //   items = [
  //     NavModel(page: const , navKey: homeNavKey),
  //     NavModel(page: const , navKey: profileNavKey),
  //   ];
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, ref, child) {
          final userData = ref.watch(userInfosProvider);

          if (selectedTab == 0) {
            return RoomListScreen();
          } else {
            return userData.when(
              data: (user) {
                if (user != null) {
                  return UserSettingsScreen();
                } else {
                  return UserLoginScreen();
                }
              },
              error: (error, stackTrace) =>
                  Center(child: Text(error.toString())),
              loading: () => const Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
      bottomNavigationBar: NavBar(
        pageIndex: selectedTab,
        onTap: (index) {
          if (index != selectedTab) {
            setState(() {
              selectedTab = index;
            });
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        margin: const EdgeInsets.only(top: 10),
        height: 64,
        width: 64,
        child: FloatingActionButton(
          backgroundColor: AppColors.greenColor,
          elevation: 0,
          onPressed: () {
            context.goNamed(RouteNames.create.name);
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: Icon(Icons.add, color: AppColors.whiteColor, size: 60),
        ),
      ),
    );
  }
}
