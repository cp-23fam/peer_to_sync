import 'package:flutter/material.dart';
import 'package:peer_to_sync/src/common_widgets/nav_bar.dart';
import 'package:peer_to_sync/src/features/room/presentation/room_list/room_list_screen.dart';
import 'package:peer_to_sync/src/features/user/presentation/user_settings/user_settings_screen.dart';
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
      body: selectedTab == 0
          ?
            // TODO : Changement de la page si le user n'est pas connecté
            RoomListScreen()
          : UserSettingsScreen(),
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
          onPressed: () {},
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: Icon(Icons.add, color: AppColors.whiteColor, size: 60),
        ),
      ),
    );
  }
}
